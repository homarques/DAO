library(scmamp)
library(ggplot2)
library(RColorBrewer)
source('R/latex.r')


plotSynth <- function () {
	results = list.files('experiments/synthetic', full.names = T)
	names = c("KNN", "LOF", "SLOF", "DAO (LIDL RQSNF)", "DAO (LIDL MoG)", "DAO (MLE)", "DAO (TLE)", "DAO (TwoNN)")
	results_table = c()
	for(result in results){
		data = read.table(result, sep = ',')
		results_table = rbind(results_table, data)
	}

	results_mean = c()
	results_sd = c()
	for(i in 1:16){
		results_mean = rbind(results_mean, colMeans(results_table[seq(i, 16*24, 16),]))
		results_sd = rbind(results_sd, apply(results_table[seq(i, 16*24, 16),], 2, sd))
	}

	df <- data.frame(Algorithms=rep(names, each = 16), Dimensionality=rep(seq(2, 32, 2), 8), SD = c(results_sd), AUCROC = c(results_mean))
	df$Algorithms = factor(df$Algorithms, levels = c("DAO (MLE)", "DAO (TLE)", "DAO (TwoNN)", "LOF", "SLOF", "DAO (LIDL MoG)", "DAO (LIDL RQSNF)", "KNN"))

	pdf("synthetic.pdf", width=28, height = 18)
	ggplot(data=df, aes(x=Dimensionality, y=AUCROC, group=Algorithms, color=Algorithms, shape = Algorithms)) + geom_line() + geom_point(size = 8) + geom_segment(aes(x = 8, y = -Inf, xend = 8, yend = 1), linetype='C9',colour='black' ) +
	scale_color_manual(values = c("#B2DF8A", "#33A02C",  "#FB9A99", "#FDBF6F","#FF7F00", "#A6CEE3", "#1F78B4", "#E31A1C"), labels = c(bquote(DAO[MLE]), bquote(DAO[TLE]), bquote(DAO[TwoNN]), "LOF", "SLOF", bquote(DAO[LIDL(MoG)]), bquote(DAO[LIDL(RQ-NSF)]), "KNN")) +
	scale_shape_manual(values = c(15, 3, 7, 0 , 6,16, 17,8), labels = c(bquote(DAO[MLE]), bquote(DAO[TLE]), bquote(DAO[TwoNN]), "LOF", "SLOF", bquote(DAO[LIDL(MoG)]), bquote(DAO[LIDL(RQ-NSF)]), "KNN")) +
	theme_classic() + theme(plot.margin = unit(c(-0.1,0,-0.25,0.1), "cm"), axis.ticks.length=unit(.45, "cm"), axis.title.y = element_text(margin = margin(t = 0, r = 5, b = 0, l = 0)), axis.text.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)), axis.text.x = element_text(margin = margin(t = 10, r = 0, b = 0, l = 0)), axis.title.x = element_text(margin = margin(t = 30, r = 0, b = 0, l = 0)), legend.justification = "top", panel.grid.major = element_line(), axis.text=element_text(size=38), legend.key.size=unit(4, "line"), axis.title=element_text(size=56), legend.text=element_text(size=46), legend.title=element_text(size=50), panel.grid.minor = element_line() ) + 
	ylab("ROC AUC") + xlab(expression(paste("Intrinsic dimension of ", italic("c"[2])))) + scale_x_discrete(limits=c(2, 4, 8, 16, 24, 32)) + geom_errorbar(aes(ymin=AUCROC-SD, ymax=AUCROC+SD), width=0.3)
	dev.off()

}


summaryRealDatasets <- function () {
	repos = list.dirs('datasets/real', recursive = F, full.names = T)
	overall = c()
	repo_table = c()
	names = c('Repository', 'Features', 'Size', 'Outliers', 'Datasets')
	for(repo in repos){
		datasets = list.files(repo, full.names = T)
		stats = c()

		for(dataset in datasets){
			data = read.table(dataset)
			stats = rbind(stats, cbind(ncol(data) - 1, nrow(data), round(100*sum(data[, ncol(data)] == 1)/nrow(data))))
		}

		if(repo == 'datasets/real/DAMI'){
			repo_table = rbind(repo_table, cbind(paste("Campos", italic("et al."), cite("campos2016")), interval(stats[,1]), interval(stats[,2]), intervalPer(stats[,3]), nrow(stats)))
		}else if(repo == 'datasets/real/IREOS'){
			repo_table = rbind(repo_table, cbind(paste("Marques", italic("et al."), cite("marques2020")), interval(stats[,1]), interval(stats[,2]), intervalPer(stats[,3]), nrow(stats)))
		}else if(repo == 'datasets/real/ODDS'){
			repo_table = rbind(repo_table, cbind(paste("Rayana", cite("rayana2016")), interval(stats[,1]), interval(stats[,2]), intervalPer(stats[,3]), nrow(stats)))
		}else if(repo == 'datasets/real/dataverse'){
			repo_table = rbind(repo_table, cbind(paste("Goldstein \\& Uchida", cite("goldstein2016")), interval(stats[,1]), interval(stats[,2]), intervalPer(stats[,3]), nrow(stats)))
		}else if(repo == 'datasets/real/META'){
			repo_table = rbind(repo_table, cbind(paste("Emmott", italic("et al."), cite("emmott2016")), interval(stats[,1]), interval(stats[,2]), intervalPer(stats[,3]), nrow(stats)))
		}else if(repo == 'datasets/real/Monash'){
			repo_table = rbind(repo_table, cbind(paste("Kandanaarachchi", italic("et al."), cite("kandanaarachchi2020")), interval(stats[,1]), interval(stats[,2]), intervalPer(stats[,3]), nrow(stats)))
		}
		overall = rbind(overall, stats)
	}
	repo_table = rbind(repo_table, cbind("Overall", interval(overall[,1]), interval(overall[,2]), intervalPer(overall[,3]), nrow(overall)))
	colnames(repo_table) = names

	xtable(repo_table, caption("Summary of dataset statistics", label = "tab:datasets"), alignment = "lcccc")
}


summaryResultsRealDatasets <- function () {
	results = list.files('experiments/real', full.names = T)
	names = c('Dataset', 'KNN', 'LOF', 'SLOF', 'DAO')
	overall = c()
	results_table = c()
	for(result in results){
		data = read.table(result, sep = ',')
		overall = rbind(overall, data)
		data = round(data, 3)
		data[which(max(data)==data)] = bold(data[which(max(data)==data)])
		results_table = rbind(results_table, cbind(underline(strsplit(strsplit(result, '/')[[1]][3], '.txt')[[1]]), data))
	}
	colnames(overall) = c('KNN', 'LOF', 'SLOF', 'DAO')

	overall = colMeans(overall)
	overall = round(overall, 3)
	overall[which(max(overall) == overall)] = bold(overall[which(max(overall) == overall)])
	results_table = rbind(results_table, c('Overall', overall))
	colnames(results_table) = names

	xtable(results_table, caption("ROC AUC values of the methods on real datasets", label = "tab:res:datasets"), alignment = "lcccc")

}


summaryResultsSyntheticDatasets <- function () {
	results = list.files('experiments/synthetic', full.names = T)
	names = c("Dataset", "KNN", "LOF", "SLOF", "DAO (LIDL RQSNF)", "DAO (LIDL MoG)", "DAO (MLE)", "DAO (TLE)", "DAO (TwoNN)")
	results_table = c()
	for(result in results){
		data = read.table(result, sep = ',')
		results_table = rbind(results_table, data)
	}

	results_mean = c()
	results_sd = c()
	overall_mean = colMeans(results_table)
	overall_mean = round(overall_mean, 3)
	overall_sd = apply(results_table, 2, sd)
	overall_sd = round(overall_sd, 4)
	for(i in 1:16){
		results_mean = rbind(results_mean, colMeans(results_table[seq(i, 16*24, 16),]))
		results_sd = rbind(results_sd, apply(results_table[seq(i, 16*24, 16),], 2, sd))
	}
	results_mean = round(results_mean, 3)
	results_sd = round(results_sd, 4)

	results_table = matrix(0, ncol = 8, nrow = 17)
	for(i in 1:16){
		results_table[i, which(max(results_mean[i,])==results_mean[i,])] = bold(paste(results_mean[i, which(max(results_mean[i,]) == results_mean[i,])], ' $\\pm$ ', results_sd[i, which(max(results_mean[i,]) == results_mean[i,])]))
		results_table[i, which(max(results_mean[i,])!=results_mean[i,])] = paste(results_mean[i, which(max(results_mean[i,]) != results_mean[i,])], ' $\\pm$ ', results_sd[i, which(max(results_mean[i,]) == results_mean[i,])])
	}
	
	i = 17
	results_table[i, which(max(overall_mean)==overall_mean)] = bold(paste(overall_mean[which(max(overall_mean) == overall_mean)], ' $\\pm$ ', overall_sd[which(max(overall_mean) == overall_mean)]))
	results_table[i, which(max(overall_mean)!=overall_mean)] = paste(overall_mean[which(max(overall_mean) != overall_mean)], ' $\\pm$ ', overall_sd[which(max(overall_mean) != overall_mean)])

	results_table = cbind(c(paste('Dimensionality', seq(2,32,2)), 'Overall'), results_table)
	colnames(results_table) = names
	xtable(results_table, caption("ROC AUC values of the methods on real datasets", label = "tab:res:synth:datasets"), alignment = "lcccccccc")
}


plotRuntime <- function () {
	dao = c()
	lof = c()
	knno = c()
	slof = c()
	for(i in seq(2, 32, 2)){
		for(b in seq(1:30)){
			data = read.table(paste('experiments/runtime/', b, '/', i, '/dao.txt', sep =''), sep = ',')
			dao = c(rowSums(data), dao)

			data = read.table(paste('experiments/runtime/', b, '/', i, '/lof.txt', sep =''), sep = ',')
			lof = c(rowSums(data), lof)

			data = read.table(paste('experiments/runtime/', b, '/', i, '/slof.txt', sep =''), sep = ',')
			slof = c(rowSums(data), slof)

			data = read.table(paste('experiments/runtime/', b, '/', i, '/knn.txt', sep =''), sep = ',')
			knno = c(rowSums(data), knno)
		}
	}

	cat('DAO: ', round(mean(dao), 3), ' $\\pm$ ', round(sd(dao), 3),  '\n')
	cat('LOF: ', round(mean(lof), 3), ' $\\pm$ ', round(sd(lof), 3),  '\n')
	cat('SLOF: ', round(mean(slof), 3),' $\\pm$ ', round(sd(slof), 3), '\n')
	cat('kNN: ', round(mean(knno), 3), ' $\\pm$ ', round(sd(knno), 3), '\n')

}


plotCDRealDatasets <- function () {
	results = list.files('experiments/real', full.names = T)
	overall = c()
	for(result in results){
		data = read.table(result, sep = ',')
		overall = rbind(overall, data)
	}
	colnames(overall) = c('KNN', 'LOF', 'SLOF', 'DAO')

	pdf("plotCD.pdf", width=19, height=10)
	plotCD(overall, cex = 3.5, alpha=1e-16)
	dev.off()
}


plotLRSynthetic <- function () {
	results = list.files('experiments/synthetic', full.names = T)
	names = c("KNN", "LOF", "SLOF", "DAO (LIDL RQSNF)", "DAO (LIDL MoG)", "DAO", "DAO (TLE)", "DAO (TwoNN)")
	results_table = c()
	for(result in results){
		data = read.table(result, sep = ',')
		results_table = rbind(results_table, data)
	}

	results_mean = c()
	for(i in 1:16){
		results_mean = rbind(results_mean, colMeans(results_table[seq(i, 16*24, 16),]))
	}
	colnames(results_mean) = names

	diffscore = results_mean[, 'DAO'] - results_mean[,'SLOF']
	tb = as.data.frame(cbind(diffscore, abs(seq(2, 32, 2) - 8)))
	colnames(tb) = c('diff', 'diffIDs')

	lr = lm(tb$diff ~  tb$diffIDs)
	f = summary(lr)$fstatistic
	pvalue = pf(f[1], f[2], f[3], lower.tail = F)

	cat("$\\DAO$ - $\\SLOF$   & ",  round(lr$coefficients[2], 4), " & ", formatC(pvalue, format = "e"), " & ", round(cor(tb$diff, tb$diffIDs), 3), "\\\\\n")

	diffscore = results_mean[, 'DAO'] - results_mean[,'LOF']
	tb = as.data.frame(cbind(diffscore, abs(seq(2, 32, 2) - 8)))
	colnames(tb) = c('diff', 'diffIDs')

	lr = lm(tb$diff ~  tb$diffIDs)
	f = summary(lr)$fstatistic
	pvalue = pf(f[1], f[2], f[3], lower.tail = F)

	cat("$\\DAO$ - $\\LOF$   & ",  round(lr$coefficients[2], 4), " & ", formatC(pvalue, format = "e"), " & ", round(cor(tb$diff, tb$diffIDs), 3), "\\\\\n")

	diffscore = results_mean[, 'DAO'] - results_mean[,'KNN']
	tb = as.data.frame(cbind(diffscore, abs(seq(2, 32, 2) - 8)))
	colnames(tb) = c('diff', 'diffIDs')

	lr = lm(tb$diff ~  tb$diffIDs)
	f = summary(lr)$fstatistic
	pvalue = pf(f[1], f[2], f[3], lower.tail = F)

	cat("$\\DAO$ - $\\KNN$   & ",  round(lr$coefficients[2], 4), " & ", formatC(pvalue, format = "e"), " & ", round(cor(tb$diff, tb$diffIDs), 3), "\\\\\n")

}


plotLRReal <- function () {
	results = list.files('experiments/stats', full.names = F)
	overall = c()
	stats = c()
	for(result in results){
		data = read.table(paste0('experiments/real/', result), sep = ',')
		stat = read.table(paste0('experiments/stats/', result), sep = ',')

		overall = rbind(overall, data)
		stats = rbind(stats, stat)
	}
	colnames(overall) = c('KNN', 'LOF', 'SLOF', 'DAO')

	diffscore = overall[, 'DAO'] - overall[,'SLOF']
	tb = as.data.frame(cbind(diffscore, stats))
	colnames(tb) = c('diff', 'R', 'Moran')

	lrMoran = lm(tb$diff ~  tb$Moran)
	f = summary(lrMoran)$fstatistic
	pvalueMoran = pf(f[1], f[2], f[3], lower.tail = F)


	lrR = lm(tb$diff ~  tb$R)
	f = summary(lrR)$fstatistic
	pvalueR = pf(f[1], f[2], f[3], lower.tail = F)

	cat("$\\DAO$ - $\\SLOF$   & ",  round(lrR$coefficients[2], 3), " & ", formatC(pvalueR, format = "e"), " & ", round(cor(tb$diff, tb[,'R']), 2), " & ", round(lrMoran$coefficients[2], 3), " &", formatC(pvalueMoran, format = "e"), " & ", round(cor(tb$diff, tb[,'Moran']), 2), "\\\\\n")


	diffscore = overall[, 'DAO'] - overall[, 'KNN']
	tb = as.data.frame(cbind(diffscore, stats))
	colnames(tb) = c('diff', 'R', 'Moran')

	lrMoran = lm(tb$diff ~  tb$Moran)
	f = summary(lrMoran)$fstatistic
	pvalueMoran <- pf(f[1], f[2], f[3], lower.tail = F)

	lrR = lm(tb$diff ~  tb$R)
	f = summary(lrR)$fstatistic
	pvalueR = pf(f[1], f[2], f[3], lower.tail = F)

	cat("$\\DAO$ - $\\knn$   & ",  round(lrR$coefficients[2], 3), " & ", formatC(pvalueR, format = "e"), " & ", round(cor(tb$diff, tb[,'R']), 2), " & ", round(lrMoran$coefficients[2], 3), " &", formatC(pvalueMoran, format = "e"), " & ", round(cor(tb$diff, tb[,'Moran']), 2), "\\\\\n")


	diffscore = overall[, 'DAO'] - overall[, 'LOF']
	tb = as.data.frame(cbind(diffscore, stats))
	colnames(tb) = c('diff', 'R', 'Moran')

	lrMoran = lm(tb$diff ~  tb$Moran)
	f = summary(lrMoran)$fstatistic
	pvalueMoran = pf(f[1], f[2], f[3], lower.tail = F)


	lrR = lm(tb$diff ~  tb$R)
	f = summary(lrR)$fstatistic
	pvalueR = pf(f[1], f[2], f[3], lower.tail = F)

	cat("$\\DAO$ - $\\LOF$   & ",  round(lrR$coefficients[2], 3), " & ", formatC(pvalueR, format = "e"), " & ", round(cor(tb$diff, tb[,'R']), 2), " & ", round(lrMoran$coefficients[2], 3), " &", formatC(pvalueMoran, format = "e"), " & ", round(cor(tb$diff, tb[,'Moran']), 2), "\\\\\n")
}


plotRMoransI <- function () {
	results = list.files('experiments/stats', full.names = F)
	overall = c()
	stats = c()
	for(result in results){
		data = read.table(paste0('experiments/real/', result), sep = ',')
		stat = read.table(paste0('experiments/stats/', result), sep = ',')

		overall = rbind(overall, data)
		stats = rbind(stats, stat)
	}
	colnames(overall) = c('KNN', 'LOF', 'SLOF', 'DAO')

	morans_title <- expression("Moran's I")
	R_title <- expression("R")
	limit = c(-0.2, 0.2)

	pdf("slof.pdf", width=9)
	diffscore = overall[, 'DAO'] - overall[, 'SLOF']
	tb = as.data.frame(cbind(diffscore, stats))
	colnames(tb) = c('diff', 'R', 'Moran')

	tb[which(tb$diff > 0.2), 'diff'] = 0.2
	tb[which(tb$diff < - 0.2), 'diff'] = -0.2

	ggplot(tb, aes(x = Moran, y = R, color = diff)) + geom_point(cex = 3.5) + ylab(R_title) + xlab(morans_title) + 
	theme_classic() + theme(legend.margin=margin(0,0,0,10), legend.position="right", legend.box = "horizontal", axis.text=element_text(size=15), legend.key.size=unit(2, "line"), axis.title=element_text(size=19), legend.text=element_text(size=16), legend.title=element_text(size=19, margin = margin(l = -10, unit = "pt")) ) +
	scale_colour_gradientn(values=c(0, 0.25, 0.35, 0.4999, 0.5001, 0.65, 0.75, 1), colours = (brewer.pal(name='RdBu', n = 11)[c(1, 2, 3, 8, 9, 10, 11)]),limit = limit, name = "    ROC AUC\n(DAO - SLOF)")
	dev.off()


	pdf("knn.pdf", width=9)
	diffscore = overall[, 'DAO'] - overall[, 'KNN']
	tb = as.data.frame(cbind(diffscore, stats))
	colnames(tb) = c('diff', 'R', 'Moran')

	tb[which(tb$diff> 0.2), 'diff'] = 0.2
	tb[which(tb$diff< - 0.2), 'diff'] = -0.2

	ggplot(tb, aes(x = Moran, y = R, color = (diff))) + geom_point(cex = 3.5) + 
	ylab(R_title) + xlab(morans_title) + scale_colour_gradientn(values=c(0, 0.25, 0.35, 0.4999, 0.5001, 0.65, 0.75, 1), colours = (brewer.pal(name='RdBu', n = 11)[c(1, 2, 3, 8, 9, 10, 11)]),limit = limit, name = "   ROC AUC\n(DAO - KNN)") +
	theme_classic() + theme(legend.margin=margin(0,0,0,10), legend.position="right", legend.box = "horizontal", axis.text=element_text(size=15), legend.key.size=unit(2, "line"), axis.title=element_text(size=19), legend.text=element_text(size=16), legend.title=element_text(size=19, margin = margin(l = -10, unit = "pt")) )
	dev.off()


	pdf("lof.pdf", width=9)
	diffscore = overall[, 'DAO'] - overall[, 'LOF']
	tb = as.data.frame(cbind(diffscore, stats))
	colnames(tb) = c('diff', 'R', 'Moran')

	tb[which(tb$diff> 0.2), 'diff'] = 0.2
	tb[which(tb$diff< - 0.2), 'diff'] = -0.2

	ggplot(tb, aes(x = Moran, y = R, color = (diff))) + geom_point(cex = 3.5) + ylab(R_title) + xlab(morans_title) + 
	scale_colour_gradientn(values=c(0, 0.25, 0.35, 0.4999, 0.5001, 0.65, 0.75, 1), colours = (brewer.pal(name='RdBu', n = 11)[c(1, 2, 3, 8, 9, 10, 11)]),limit = limit, name = "  ROC AUC\n(DAO - LOF)") +
	theme_classic() + theme(legend.margin=margin(0,0,0,10), legend.position="right", legend.box = "horizontal", axis.text=element_text(size=15), legend.key.size=unit(2, "line"), axis.title=element_text(size=19), legend.text=element_text(size=16), legend.title=element_text(size=19, margin = margin(l = -10, unit = "pt")) )
	dev.off()


	pdf("oracle.pdf", width=9)
	orc = c()
	for(i in 1:nrow(overall)){
		j = sort.list(t(overall[i, c(1:3)]), dec = T)[1]
		orc = rbind(orc, c(overall[i, j], colnames(overall)[j]))
	}

	orc = as.data.frame(orc)
	names = c("Perf", "Algorithms")
	colnames(orc) = names

	diffscore = c(overall[, 'DAO'] - as.numeric(orc[,1]))
	tb = as.data.frame(cbind(diffscore, stats))
	colnames(tb) = c('diff', 'R', 'Moran')

	tb[which(tb$diff> 0.2), 'diff'] = 0.2
	tb[which(tb$diff< - 0.2), 'diff'] = -0.2


	ggplot(tb, aes(x = Moran, y = R, color = (diff), shape = orc$Algorithms)) + geom_point(cex = 3.5) + labs(shape="") + ylab(R_title) + xlab(morans_title) + 
	scale_colour_gradientn(values=c(0, 0.25, 0.35, 0.4999, 0.5001, 0.65, 0.75, 1), colours = (brewer.pal(name='RdBu', n = 11)[c(1, 2, 3, 8, 9, 10, 11)]),limit = limit, name = "    ROC AUC\n(DAO - Oracle)") +
	theme_classic() + theme(legend.margin=margin(0,0,0,10), legend.position="right", legend.justification = 'bottom', legend.box = "vertical", axis.text=element_text(size=15), legend.key.size=unit(2, "line"), axis.title=element_text(size=19), legend.text=element_text(size=16), legend.title=element_text(size=19, margin = margin(l = -10, unit = "pt")) )
	dev.off()

}