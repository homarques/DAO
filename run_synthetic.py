import numpy as np
from sklearn.metrics import roc_auc_score
import multiprocessing as mp
from scipy.spatial import KDTree
from algorithms import lof, slof, knno, dao
from estimators import mle, tle
from skdim.id import TwoNN
from os import path, mkdir
#https://github.com/opium-sh/lidl
#from dim_estimators import LIDL
#from sklearn.preprocessing import StandardScaler


def main(batch):
	print(batch)
	i = 0
	aucs = np.zeros((16, 8))
	for dataset in range(2, 33, 2):
		X = np.genfromtxt('datasets/synthetic/batch' + str(batch) + "/" + str(dataset) + ".csv", delimiter=' ', dtype='str')

		groundTruth = np.zeros(X.shape[0])
		groundTruth[X[:,-4] == 'outlier'] = 1

		X = np.delete(X, range(-4, 0), 1)
		X = X.astype('float')

		n, d = X.shape

		nn = KDTree(X)
		dists, idx = nn.query(X, 781)

		# scaler = StandardScaler()
		# X_scaled = scaler.fit_transform(X)

		#deltas = np.geomspace(0.025, 0.1, 11)
		#gm = LIDL(model_type = "gm", runs = 50, covariance_type = "diag", max_components = 30)
		#gm_LID = gm(deltas = deltas, train_dataset = X_scaled, test = X_scaled)

		#rqnsf = LIDL(model_type = "rqnsf", device = "cpu", num_layers = 4, lr = 0.0001, hidden = 5, epochs = 10000, batch_size = 256, num_blocks = 5)
		#rqnsf_LID = rqnsf(deltas = deltas, train_dataset = X_scaled, test = X_scaled)
		ids_rqnsf = np.zeros(n)
		ids_gm = np.zeros(n)

		for k in range(5, 101):
			sc_knno = knno(dists[:, :k+1])
			sc_lof  = lof(dists[:, :k+1], idx[:, :k+1])
			sc_slof = slof(dists[:, :k+1], idx[:, :k+1])
			sc_dao_rqnsf = dao(dists[:, :k+1], idx[:, :k+1], ids_rqnsf)
			sc_dao_gm = dao(dists[:, :k+1], idx[:, :k+1], ids_gm)

			auc = roc_auc_score(groundTruth, sc_knno)
			if(auc > aucs[i, 0]):
				aucs[i, 0] = auc

			auc = roc_auc_score(groundTruth, sc_lof)
			if(auc > aucs[i, 1]):
				aucs[i, 1] = auc

			auc = roc_auc_score(groundTruth, sc_slof)
			if(auc > aucs[i, 2]):
				aucs[i, 2] = auc

			auc = roc_auc_score(groundTruth, sc_dao_rqnsf)
			if(auc > aucs[i, 3]):
				aucs[i, 3] = auc

			auc = roc_auc_score(groundTruth, sc_dao_gm)
			if(auc > aucs[i, 4]):
				aucs[i, 4] = auc

		for mpts in [5, 10, 15, 30, 50, 90, 150, 260, 320, 450, 560, 780]:
			ids_mle   = mle(dists[:,1:mpts+1])
			ids_tle = tle(dists[:,1:mpts+1], X[idx[:,1:mpts+1]])
			ids_twoNN = TwoNN().fit_transform_pw(X, precomputed_knn = idx[:,1:mpts+1])
			for k in range(5, 101):
				sc_dao_mle   = dao(dists[:, :k+1], idx[:, :k+1], ids_mle)
				sc_dao_tle   = dao(dists[:, :k+1], idx[:, :k+1], ids_tle)
				sc_dao_twoNN = dao(dists[:, :k+1], idx[:, :k+1], ids_twoNN)

				auc = roc_auc_score(groundTruth, sc_dao_mle)
				if(auc > aucs[i, 5]):
					aucs[i, 5] = auc

				auc = roc_auc_score(groundTruth, sc_dao_tle)
				if(auc > aucs[i, 6]):
					aucs[i, 6] = auc

				auc = roc_auc_score(groundTruth, sc_dao_twoNN)
				if(auc > aucs[i, 7]):
					aucs[i, 7] = auc
		i += 1
		print(i)

	np.savetxt('experiments/synthetic/batch' + str(batch) + '.txt', aucs, delimiter=',', fmt='%f', header = "KNN, LOF, SLOF, DAO_RQNSF, DAO_MoG, DAO_MLE, DAO_TLE, DAO_TwoNN")

	return 

if __name__ == '__main__':
	if(not path.exists('experiments')):
		mkdir('experiments')

	if(not path.exists('experiments/synthetic')):
		mkdir('experiments/synthetic')

	pool = mp.Pool()
	run = pool.map(main, range(1, 31), chunksize = 1)

	pool.close()
