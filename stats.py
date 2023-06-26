import numpy as np
import multiprocessing as mp
from glob import iglob
from os import mkdir, path
from pysal.lib import weights
from pysal.explore import esda

import os

def main(dataset):
	stats = np.zeros(2)
	X = np.genfromtxt(dataset, delimiter=' ')
	X = np.delete(X, -1, 1)

	ids = np.genfromtxt('experiments/lids/' + dataset.split('/')[-1], delimiter = ',')
	n, d = X.shape

	r = np.abs(np.log(ids[:, None] / ids[None, :]))
	stats[0] = np.mean(r[np.triu_indices(n, k=1)])

	log_ids = np.log(ids)
	for k in range(5, min(101, n)):
		w = weights.KNN(X, k = k)
		w.transform = 'R'
		morans = esda.moran.Moran(log_ids, w)
		if(abs(morans.I) > abs(stats[1])):
			stats[1] = morans.I

	np.savetxt('experiments/stats/' + dataset.split('/')[-1], stats.reshape(1,2), delimiter=',', header = "R, MoransI")
	return 

if __name__ == '__main__':

	if(not path.exists('experiments/stats')):
		mkdir('experiments/stats')

	datasets = list(iglob('datasets/real/**/*.txt', recursive=True))
	pool = mp.Pool()
	run = pool.map(main, datasets, chunksize = 1)

	pool.close()
