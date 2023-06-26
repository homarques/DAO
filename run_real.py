import numpy as np
from sklearn.metrics import roc_auc_score
import multiprocessing as mp
from scipy.spatial import KDTree
from algorithms import lof, slof, knno, dao
from estimators import mle
from glob import iglob
from os import mkdir, path
import sys

def main(dataset):
	if(not path.isfile('experiments/real/' + dataset.split('/')[-1])):
		print(dataset)
		X = np.genfromtxt(dataset, delimiter=' ')

		groundTruth = X[:,-1]
		X = np.delete(X, -1, 1)

		n, d = X.shape
		nn = KDTree(X)
		kmax = min(n, 780)
		dists, idx = nn.query(X, kmax)
		par_estimator = np.asarray([5, 10, 15, 30, 50, 90, 150, 260, 320, 450, 560, 780])
		par_estimator = par_estimator[par_estimator <= kmax]
		
		aucs = np.zeros(4)
		for k in range(5, min(101, n)):
			print(k)
			sc_knno = knno(dists[:, :k+1])
			sc_lof  = lof(dists[:, :k+1], idx[:, :k+1])
			sc_slof = slof(dists[:, :k+1], idx[:, :k+1])

			auc = roc_auc_score(groundTruth, sc_knno)
			if(auc > aucs[0]):
				aucs[0] = auc

			auc = roc_auc_score(groundTruth, sc_lof)
			if(auc > aucs[1]):
				aucs[1] = auc

			auc = roc_auc_score(groundTruth, sc_slof)
			if(auc > aucs[2]):
				aucs[2] = auc

		for mpts in par_estimator:
			print(mpts)
			ids_mle  = mle(dists[:,1:mpts+1])
			for k in range(5, min(101, n)):
				print(k)
				sc_dao   = dao(dists[:, :k+1], idx[:, :k+1], ids_mle)
				
				if(np.any(np.isinf(sc_dao))):
					sc_dao[np.isinf(sc_dao)] = sys.maxsize
				
				auc = roc_auc_score(groundTruth, sc_dao)
				if(auc > aucs[3]):
					aucs[3] = auc
					np.savetxt('experiments/lids/' + dataset.split('/')[-1], ids_mle, delimiter=',')

		np.savetxt('experiments/real/' + dataset.split('/')[-1], aucs.reshape(1,4), delimiter=',', fmt='%f', header = "KNN, LOF, SLOF, DAO")
	return 

if __name__ == '__main__':
	if(not path.exists('experiments')):
		mkdir('experiments')

	if(not path.exists('experiments/real')):
		mkdir('experiments/real')

	if(not path.exists('experiments/lids')):
		mkdir('experiments/lids')

	datasets = list(iglob('datasets/real/**/*.txt', recursive=True))
	pool = mp.Pool()
	run = pool.map(main, datasets, chunksize = 1)

	pool.close()
