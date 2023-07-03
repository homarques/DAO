if (!require('RWeka')) install.packages('RWeka'); library('RWeka')
if (!require('dplyr')) install.packages('dplyr'); library('dplyr')
if (!require('raveio')) install.packages('raveio'); library('raveio')

#Delete raw datasets?
remove = TRUE

final_datasets = c()
pwd = 'datasets/real/raw/'
out = 'datasets/real/'


removingDupl <- function(name, data, label){
	dupl = which(duplicated(data))
	if(length(dupl) > 0){
		print(paste(name, ': duplicates removed', sep = ''))
		data  = data[-dupl,]
		label = label[-dupl]
	}
	return(list("X" = data, "y" = label))
}


categoricalAttr <- function(name, data){
	j = 0
	for(i in 1:ncol(data$X)){
		if(length(unique(data$X[,i])) <= nrow(data$X)*0.2){
			j = j + 1
		}
	}

	if(j == ncol(data$X)){
		print(paste(name, ' removed: All attributes with less than 20% unique values (likely categorical dataset)', sep = ''))
		return(TRUE)
	}else{
		return(FALSE)
	}
}


stillHaveOutliers <- function(name, data){
	if(length(unique(data$y)) != 2){
		print(paste(name, ' removed: no outlier in the dataset', sep = ''))
		return(FALSE)
	}else{
		return(TRUE)
	}
}



#On the Evaluation of Unsupervised Outlier Detection: Measures, Datasets, and an Empirical Study
#by G. O. Campos, A. Zimek, J. Sander, R. J. G. B. Campello, B. Micenková, E. Schubert, I. Assent and M. E. Houle

#Variants used by Marques et at. 2020
#https://github.com/homarques/ireos-extension/blob/master/data/datasets.txt
selected_variants = c ('ALOI_withoutdupl_norm.arff', 'KDDCup99_withoutdupl_norm_1ofn.arff', 'InternetAds_withoutdupl_norm_05_v10.arff', 'Waveform_withoutdupl_norm_v05.arff', 
						'PageBlocks_withoutdupl_norm_05_v10.arff', 'Annthyroid_withoutdupl_norm_05_v01.arff', 'SpamBase_withoutdupl_norm_05_v06.arff', 'Arrhythmia_withoutdupl_norm_05_v09.arff',
						'PenDigits_withoutdupl_norm_v09.arff', 'Cardiotocography_withoutdupl_norm_05_v06.arff', 'Wilt_withoutdupl_norm_05.arff', 'WDBC_withoutdupl_norm_v08.arff',
						'Shuttle_withoutdupl_norm_v01.arff', 'WPBC_withoutdupl_norm.arff', 'Ionosphere_withoutdupl_norm.arff', 'Pima_withoutdupl_norm_05_v03.arff', 'Stamps_withoutdupl_norm_05_v05.arff', 
						'Parkinson_withoutdupl_norm_05_v02.arff', 'WBC_withoutdupl_norm_v10.arff', 'HeartDisease_withoutdupl_norm_05_v07.arff', 'Lymphography_withoutdupl_norm_idf.arff', 
						'Glass_withoutdupl_norm.arff', 'Hepatitis_withoutdupl_norm_05_v04.arff')

#literature & semantic
datasets = list.files(paste(pwd, 'DAMI', sep = ''), recursive = T)
datasets = datasets[unlist(strsplit(datasets, '/'))[c(F,F,T)] %in% selected_variants]
dir.create(paste(out, 'DAMI/', sep = ''))
for(dataset in datasets){
	data = read.arff(paste(pwd, 'DAMI/', dataset, sep = '/'))
	name = paste('DAMI/', dataset, sep = '')

	#Retrieving data & label
	label = rep(0, nrow(data))
	label[data$outlier=='yes'] = 1
	data = select(data, -c('id', 'outlier'))
				
	#Removing duplicates
	data = removingDupl(name, data, label)
				
	#Verifying attributes
	if(!categoricalAttr(name, data)){
		#Still have outliers in the dataset?
		if(stillHaveOutliers(name, data)){
			final_datasets = c(final_datasets, name)
			dataset = strsplit(dataset, '/')[[1]][3]
			write.table(cbind(data$X, data$y), row.names = F, col.name = F, file = paste(out, 'DAMI/', strsplit(dataset, '.arff')[[1]], '.txt', sep = ''), sep = ' ')
		}
	}
}



#Internal Evaluation of Unsupervised Outlier Detection
#by H. O. Marques, R. J. G. B. Campello, J. Sander and A. Zimek
datasets = list.files(paste(pwd, 'IREOS', sep = ''))
dir.create(paste(out, 'IREOS/', sep = ''))
for(dataset in datasets){
	data = read.table(paste(pwd, 'IREOS/', dataset, sep = ''), sep =' ')
	name = paste('IREOS/', dataset, sep = '')
	
	#Retrieving data & label
	label = data[, ncol(data)]
	data = data[, -ncol(data)]

	#Removing duplicates
	data = removingDupl(name, data, label)

	#Verifying attributes
	if(!categoricalAttr(name, data)){
		#Still have outliers in the dataset?
		if(stillHaveOutliers(name, data)){
			final_datasets = c(final_datasets, name)
			write.table(cbind(data$X, data$y), row.names = F, col.name = F, file = paste(out, 'IREOS/', dataset, '.txt', sep = ''), sep = ' ')
		}
	}
}



#A Comparative Evaluation of Unsupervised Anomaly Detection Algorithms for Multivariate Data 
#by M. Goldstein and S. Uchida
datasets = list.files(paste(pwd, 'dataverse', sep = ''))
dir.create(paste(out, 'dataverse/', sep = ''))
for(dataset in datasets){
	data = read.table(paste(pwd, 'dataverse/', dataset, sep = ''), sep ='\t')
	name = paste('dataverse/', dataset, sep = '')
	
	#Retrieving data & label
	label = rep(0, nrow(data))
	label[data[, ncol(data)] == 'o'] = 1
	data = data[, -ncol(data)]

	#Removing duplicates
	data = removingDupl(name, data, label)

	#Verifying attributes
	if(!categoricalAttr(name, data)){
		#Still have outliers in the dataset?
		if(stillHaveOutliers(name, data)){
			final_datasets = c(final_datasets, name)
			write.table(cbind(data$X, data$y), row.names = F, col.name = F, file = paste(out, 'dataverse/', strsplit(dataset, '.tab')[[1]], '.txt', sep = ''), sep = ' ')
		}
	}
}



#A Meta-Analysis of the Anomaly Detection Problem 
#by A. Emmott, S. Das, T. Dietterich, A. Fern and W.-K. Wong
datasets = list.files(paste(pwd, 'META', sep = ''))
dir.create(paste(out, 'META/', sep = ''))
for(dataset in datasets){
	data = read.table(paste(pwd, 'META/', dataset, sep = ''), sep =',', header = T)
	name = paste('META/', dataset, sep = '')

	#Retrieving data & label
	label = rep(0, nrow(data))
	label[data$ground.truth=='anomaly'] = 1
	data = data[, 6:ncol(data)]
	
	#Removing duplicates
	data = removingDupl(name, data, label)

	#Verifying attributes
	if(!categoricalAttr(name, data)){
		#Still have outliers in the dataset?
		if(stillHaveOutliers(name, data)){
			final_datasets = c(final_datasets, name)
			write.table(cbind(data$X, data$y), row.names = F, col.name = F, file = paste(out, 'META/', strsplit(dataset, '.csv')[[1]], '.txt', sep = ''), sep = ' ')
		}
	}
}



#ODDS Library
#by S. Rayana
datasets = list.files(paste(pwd, 'ODDS', sep = ''))
dir.create(paste(out, 'ODDS/', sep = ''))
for(dataset in datasets){
	data = read_mat(paste(pwd, 'ODDS/', dataset, sep = ''))
	name = paste('ODDS/', dataset, sep = '')
	
	#Retrieving data & label
	label = data$y
	data = data$X

	#Removing duplicates
	data = removingDupl(name, data, label)

	#Verifying attributes
	if(!categoricalAttr(name, data)){
		#Still have outliers in the dataset?
		if(stillHaveOutliers(name, data)){
			final_datasets = c(final_datasets, name)
			write.table(cbind(data$X, data$y), row.names = F, col.name = F, file = paste(out, 'ODDS/', strsplit(dataset, '.mat')[[1]], '.txt', sep = ''), sep = ' ')
		}
	}
}



#On Normalization and Algorithm Selection for Unsupervised Outlier Detection
#by S. Kandanaarachchi, M. A. Muñoz, R. J. Hyndman and K. Smith-Miles
datasets = list.files(paste(pwd, 'Monash', sep = ''))
dir.create(paste(out, 'Monash/', sep = ''))

#Version 01 with 2% outliers
datasets = datasets[grepl('V01', datasets) & grepl('P02', datasets)]
#without categorical attributes
datasets = datasets[!grepl('CA1', datasets)]
for(dataset in datasets){
	data = read.arff(paste(pwd, 'Monash/', dataset, sep = ''))
	name = paste('Monash/', dataset, sep = '')

	#Retrieving data & label
	label = rep(0, nrow(data))
	label[data$outlier=='yes'] = 1
	data = select(data, -c('outlier'))
	
	#Removing duplicates
	data = removingDupl(name, data, label)
	
	#Verifying attributes
	if(!categoricalAttr(name, data)){
		#Still have outliers in the dataset?
		if(stillHaveOutliers(name, data)){
			final_datasets = c(final_datasets, name)
			write.table(cbind(data$X, data$y), row.names = F, col.name = F, file = paste(out, 'Monash/', strsplit(dataset, '.arff')[[1]], '.txt', sep = ''), sep = ' ')
		}
	}
}


cat('\n\nComplete list of datasets:\n')
for(i in final_datasets){
	cat(i, '\n')
}


if(remove)
	unlink(pwd, recursive = TRUE)
