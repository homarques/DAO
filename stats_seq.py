import numpy as np
from glob import iglob
from pysal.lib import weights
from pysal.explore import esda
from scipy.spatial import KDTree

if(not path.exists('experiments/stats')):
	mkdir('experiments/stats')

datasets = list(iglob('datasets/real/**/*.txt', recursive = True))
for dataset in datasets:
	stats = np.zeros(2)

	ids = np.genfromtxt('experiments/lids/' + dataset.split('/')[-1], delimiter = ',')
	n = ids.size

	r = 0
	for i in range(n):
		for j in range(i + 1, n):
			r = r + np.abs(np.log(ids[i] / ids[j]))

	stats[0] = r / ((n * (n-1))/2)
	np.savetxt('experiments/stats/' + dataset.split('/')[-1]+ '.part1', stats.reshape(1,2), delimiter=',', header = "R, MoransI")

	X = np.genfromtxt(dataset, delimiter=' ')
	X = np.delete(X, -1, 1)

	log_ids = np.log(ids)
	nn = KDTree(X)
	kmax = min(n, 101)
	indices_full = nn.query(X, (kmax + 1))[1]
	for k in range(5, kmax):
		indices = indices_full[:,:(k + 1)]
		full_indices = np.arange(n)
		not_self_mask = indices != full_indices.reshape(-1, 1)
		has_one_too_many = not_self_mask.sum(axis=1) == (k+1)
		not_self_mask[has_one_too_many, -1] &= False
		not_self_indices = indices[not_self_mask].reshape(n, -1)

		to_weight = not_self_indices
		ids = list(full_indices)
		named_indices = not_self_indices
		neighbors = {idx: list(indices) for idx, indices in zip(ids, named_indices)}

		w = weights.W(neighbors, id_order=ids)
		w.transform = 'R'
		morans = esda.moran.Moran(log_ids, w)
		if(abs(morans.I) > abs(stats[1])):
			stats[1] = morans.I

	np.savetxt('experiments/stats/' + dataset.split('/')[-1] + '.part2', stats.reshape(1,2), delimiter=',', header = "R, MoransI")

