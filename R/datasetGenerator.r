if (!require('MASS')) install.packages('MASS'); library('MASS')
if (!require('pracma')) install.packages('pracma'); library('pracma')

#Path to save the datasets
path = "/path/to/save/datasets"

#Number of points in each cluster
n = 800

#Number of batches
for(b in 1:30){
	#Starting dimensionality
	j = 2
	dir.create(paste(path, "batch", b, sep = ""))
	while(j <= 32){
		#Generating first cluster in 8d
		c1 = mvrnorm(n, rep(0, 8), diag(8))
		c1 = cbind(c1, matrix(0, ncol = 24, nrow = n))
		
		#Translation
		m1 = runif(32, -10, 10)
		trans = do.call("rbind", replicate(n, m1, simplify = FALSE))
		c1 = c1 + trans

		#Rotation
		rot_mat = matrix(2*(runif(32*32)-0.5), nrow = 32, ncol = 32)
		ort = orth(rot_mat)
		rot_c1 = c1 %*% ort
		rot_m1 = m1 %*% ort
		rot_cov1 = t(ort)%*%diag(32)%*%ort

		#Mahalanobis distances to the cluster center
		maha1 = mahalanobis(rot_c1, center = rot_m1, cov = rot_cov1)
		
		#Outliers points with p-value lower than 0.05
		p = pchisq(maha1, df = 8, lower.tail = FALSE)
		y1 = rep('inlier', n)
		y1[which(p < 0.05)] = 'outlier'

		#Generating second cluster in jd
		c2 = mvrnorm(n, rep(0, j), diag(j))
		c2 = cbind(c2, matrix(0, ncol = (32-j), nrow = n))
		m2 = runif(32, -10, 10)

		#Translation
		trans = do.call("rbind", replicate(n, m2, simplify = FALSE))
		c2 = c2 + trans

		#Rotation
		rot_mat = matrix(2*(runif(32*32)-0.5), nrow = 32, ncol = 32)
		ort = orth(rot_mat)
		rot_c2 = c2 %*% ort
		rot_m2 = m2 %*% ort
		rot_cov2 = t(ort)%*%diag(32)%*%ort

		#Mahalanobis distances to the cluster center
		maha2 = mahalanobis(rot_c2, center = rot_m2, cov = rot_cov2)

		#Outliers points with p-value lower than 0.05
		p = pchisq(maha2, df = j, lower.tail = FALSE)
		y2 = rep('inlier', n)
		y2[which(p < 0.05)] = 'outlier'

		data = rbind(cbind(rot_c1, y1, paste('mahaDist=', maha1, sep=''), 'cluster1', 'intDim=8'), cbind(rot_c2, y2, paste('mahaDist=', maha2, sep=''), 'cluster2', paste('intDim=', j, sep='')))

		#Computing the Mahalanobis distance to the cluster center where it does not belong
		maha12 = mahalanobis(rot_c1, center = rot_m2, cov = rot_cov2)
		p1 = pchisq(maha12, df = j, lower.tail = FALSE)
		
		#Computing the Mahalanobis distance to the cluster center where it does not belong
		maha21 = mahalanobis(rot_c2, center = rot_m1, cov = rot_cov1)
		p2 = pchisq(maha21, df = 8, lower.tail = FALSE)
		
		
		#If no point has a p-value higher than 10^-10 to belong to both clusters at same time, save the dataset
		if(sum(c(p1, p2) > 10^-5) == 0){
			write.table(data, paste(path, "batch", b, "/", j, ".csv", sep=''), col.names = F, row.names = F, quote = F)
			#increasing dimensionality by 2
			j = j + 2
		}
	}
}

