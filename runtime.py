import numpy as np
from algorithms import slof, lof, knno, dao
import time
from scipy.spatial import KDTree
from estimators import mle

if(not path.exists('experiments')):
    mkdir('experiments')

if(not path.exists('experiments/runtime')):
    mkdir('experiments/runtime')

for batch in range(1, 31):
    if(not path.exists('experiments/runtime/batch' + str(batch))):
        mkdir('experiments/runtime/batch' + str(batch))
    for dataset in range(2, 33, 2):
        if(not path.exists('experiments/runtime/batch' + str(batch) + '/' + str(dataset))):
            mkdir('experiments/runtime/batch' + str(batch) + '/' + str(dataset))


setMPts = [5, 10, 15, 30, 50, 90, 150, 260, 320, 450, 560, 780]
for batch in range(1, 31):
    for dataset in range(2, 33, 2):
        knn_time = np.zeros((96, 2))
        slof_time = np.zeros((96, 2))
        lof_time = np.zeros((96, 2))
        dao_time = np.zeros((96*12, 3))
        
        X = np.genfromtxt('datasets/synthetic/batch' + str(batch) + "/" + str(dataset) + '.csv', delimiter=' ', dtype='str')
        X = np.delete(X, range(-4, 0), 1)
        X = X.astype('float')
        
        start = time.time()        
        nn = KDTree(X)
        dists, idx = nn.query(X, 101)
        end = time.time()
        knn_time[:,0] = slof_time[:,0] = lof_time[:,0] = dao_time[0:576,0] = end - start

        start = time.time()        
        nn = KDTree(X)
        dists, idx = nn.query(X, 151)
        end = time.time()
        dao_time[576:672,0] = end - start

        start = time.time()        
        nn = KDTree(X)
        dists, idx = nn.query(X, 261)
        end = time.time()
        dao_time[672:768,0] = end - start

        start = time.time()        
        nn = KDTree(X)
        dists, idx = nn.query(X, 321)
        end = time.time()
        dao_time[768:864,0] = end - start

        start = time.time()        
        nn = KDTree(X)
        dists, idx = nn.query(X, 451)
        end = time.time()
        dao_time[864:960,0] = end - start

        start = time.time()        
        nn = KDTree(X)
        dists, idx = nn.query(X, 561)
        end = time.time()
        dao_time[960:1056,0] = end - start

        start = time.time()        
        nn = KDTree(X)
        dists, idx = nn.query(X, 781)
        end = time.time()
        dao_time[1056:1152,0] = end - start

        j = 0
        for mpts in setMPts:
            start = time.time()
            lids = mle(dists[:,1:mpts+1])
            end = time.time()
            dao_time[(j*96):(j*96+96),1] = end - start
            i = 0
            for k in range(5, 101):
                start = time.time()
                dao_scorings = dao(dists[:, :k+1], idx[:, :k+1], lids)
                end = time.time()
                dao_time[(j*96+i), 2] = end - start
                i = i + 1
            j = j + 1
        np.savetxt('experiments/runtime/batch' + str(batch) + '/' + str(dataset) + '/dao.txt', dao_time, delimiter=',', fmt='%f')

        i = 0
        for k in range(5, 101):
            start = time.time() 
            knno_scorings = knno(dists[:, :k+1])
            end = time.time()
            knn_time[i,1] = end - start

            start = time.time() 
            slof_scorings = slof(dists[:, :k+1], idx[:, :k+1])
            end = time.time()
            slof_time[i,1] = end - start

            start = time.time()                
            lof_scorings = lof(dists[:, :k+1], idx[:, :k+1])
            end = time.time()
            lof_time[i,1] = end - start

            i = i + 1
        np.savetxt('experiments/runtime/batch' + str(batch) + '/' + str(dataset) + '/knn.txt', knn_time, delimiter=',', fmt='%f')
        np.savetxt('experiments/runtime/batch' + str(batch) + '/' + str(dataset) + '/slof.txt', slof_time, delimiter=',', fmt='%f')
        np.savetxt('experiments/runtime/batch' + str(batch) + '/' + str(dataset) + '/lof.txt', lof_time, delimiter=',', fmt='%f')

