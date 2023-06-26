import numpy as np
from scipy.spatial.distance import pdist, squareform

def tleminus(dists, nn):
    epsilon = 0.00001
    r = dists[-1]
    
    # Boundary case 1: If $r = 0$, this is fatal, since the neighborhood would be degenerate.
    if r == 0:
        raise ValueError('All k-NN distances are zero!')
    
    # Main computation
    k = dists.shape[0]
    V = squareform(pdist(nn))
    Dj = np.tile(np.array(dists.T), (k, 1))
    Di = Dj.T
    Z2 = 2*Di**2 + 2*Dj**2 - V**2
    S = r * (((Di**2 + V**2 - Dj**2)**2 + 4*V**2 * (r**2 - Di**2))**0.5 - (Di**2 + V**2 - Dj**2)) / (2*(r**2 - Di**2))
    T = r * (((Di**2 + Z2  - Dj**2)**2 + 4*Z2  * (r**2 - Di**2))**0.5 - (Di**2 + Z2  - Dj**2)) / (2*(r**2 - Di**2))
    
    # handle case of repeating k-NN distances
    Dr = (dists == r).squeeze()
    S[Dr,:] = r * V[Dr,:]**2 / (r**2 + V[Dr,:]**2 - Dj[Dr,:]**2)
    T[Dr,:] = r * Z2[Dr,:]  / (r**2 + Z2[Dr,:]  - Dj[Dr,:]**2)
    
    # Boundary case 2: If $u_i = 0$, then for all $1\leq j\leq k$ the measurements $s_{ij}$ and $t_{ij}$ reduce to $u_j$.
    Di0 = (Di == 0).squeeze()
    S[Di0] = Dj[Di0]
    T[Di0] = Dj[Di0]
    
    # Boundary case 3: If $u_j = 0$, then for all $1\leq j\leq k$ the measurements $s_{ij}$ and $t_{ij}$ reduce to $\frac{r v_{ij}}{r + v_{ij}}$.
    Dj0 = (Dj == 0).squeeze()
    S[Dj0] = r * V[Dj0] / (r + V[Dj0]);
    T[Dj0] = r * V[Dj0] / (r + V[Dj0]);
    
    # Boundary case 4: If $v_{ij} = 0$, then the measurement $s_{ij}$ is zero and must be dropped. The measurement $t_{ij}$ should be dropped as well.
    V0 = (V == 0).squeeze()
    np.fill_diagonal(V0, False)
    
    # by setting to r, $s_{ij}$ will not contribute to the sum s1s
    S[V0] = r
    
    # by setting to r, $t_{ij}$ will not contribute to the sum s1t 
    T[V0] = r
    
    # will subtract twice this number during ID computation below
    nV0 = np.sum(V0)
    
    # Drop S & T measurements below epsilon: If $s_{ij}$ is thrown out, then for the sake of balance, $t_{ij}$ should be thrown out as well (or vice versa).
    STeps = (S < epsilon) | (T < epsilon) | np.isnan(S) | np.isnan(T) # also drop NaN measurements, "legitemately" obtained as 0/0
    np.fill_diagonal(STeps, False)
    nSTeps = np.sum(STeps)
    S[STeps] = r
    S = np.log(S/r)
    T[STeps] = r;
    T = np.log(T/r);
    
    # delete diagonal elements
    np.fill_diagonal(S, False)
    np.fill_diagonal(T, False)
    
    # Sum over the whole matrices
    s1s = np.sum(S);
    s1t = np.sum(T);
    
    # Compute ID, subtracting numbers of dropped measurements
    s1sum = s1s+s1t;
    
    # Boundary case 5: (almost) all kNN distances are equal
    if s1sum > -epsilon:
        return 0
    else:
        return -2*(k*(k-1)-nSTeps-nV0) / s1sum


#Intrinsic Dimensionality Estimation within Tight Localities
#by L. Amsaleg, O. Chelly, M. E. Houle, K. Kawarabayashi, M. Radovanovic and W. Treeratanajaru
def tle(dists, nn):
    n, k = dists.shape
    ids = np.zeros(n)
    for p in range(0, n):
        ids[p] = tleminus(dists[p,:], nn[p])

    return ids


#Maximum Likelihood Estimation of Intrinsic Dimension
#by E. Levina and P. J. Bickel
def mle(dists):
    n, k = dists.shape
    k -= 1
    
    return k / np.sum(np.log(dists[:,k].reshape(n,1) / dists), axis = 1)

