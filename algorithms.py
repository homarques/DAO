import numpy as np

#Efficient Algorithms for Mining Outliers from Large Data Sets
#by S. Ramaswamy, R. Rastogi and K. Shim
def knno(dists):
	return dists[:, -1]

 
#LOF: Identifying Density-Based Local Outliers
#by M. M. Breunig, H.-P. Kriegel, R. Ng and J. Sander
def lof(dists, idx):
	n, k = dists.shape
	k -= 1

	kdist = dists[idx[:, 1:k+1], k]
	reachability_distance = np.maximum(dists[:, 1:k+1], kdist)
	local_reachability_density = 1 / (1e-10 + (np.mean(reachability_distance, axis = 1)))
	
	return np.mean(local_reachability_density[idx[:, 1:k+1]] / local_reachability_density.reshape(n, 1), axis = 1)


#Local Outlier Detection Reconsidered: A Generalized View on Locality with Applications to Spatial, Video, and Network Outlier Detection
#by E. Schubert, A. Zimek and H.-P. Kriegel
def slof(dists, idx):
	n, k = dists.shape
	k -= 1

	return np.mean(dists[:, k].reshape(n, 1)/dists[idx[:, 1:k+1], k], axis = 1)


#Dimensionality-Aware Outlier Detection
def dao(dists, idx, lids):
	n, k = dists.shape
	k -= 1

	return np.mean((dists[:, k].reshape(n, 1)/dists[idx[:, 1:k+1], k])**lids[idx[:, 1:k+1]], axis = 1)
