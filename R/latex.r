
italic <- function(x){
	paste0('\\textit{', x, '}')
}

underline <- function(x){
	paste(strsplit(x, '_')[[1]], collapse='\\_')
}

bold <- function(x){
	paste0('\\textbf{', x, '}')
}

cite <- function(x){
	paste0('\\cite{', x, '}')
}

interval <- function(x) {
	paste0('[', min(x), ', \\hfill ', max(x), ']')	
}

intervalPer <- function(x) {
	paste0('[', min(x), '\\%, \\hfill ', max(x), '\\%]')	
}

caption <- function(x, label = NULL) {
	if(!is.null(label))
		return(paste0('\\caption{\\label{', label, '}', x, '}'))
	else
		return(paste0('\\caption{', x, '}'))
}

xtable <- function(table, caption = NULL, alignment = NULL) {
	cat('\\begin{table}[tbp]\n')
	cat('\\centering\n')
	
	if(!is.null(caption))
		cat(paste0(caption, '\n'))

	if(is.null(alignment))
		alignment = paste0(rep('c', ncol(table)), collapse='')
	
	cat(paste0('\\begin{tabular}{@{}', alignment,'@{}}\n'))
	cat('\\toprule\n')
	cat(paste0(paste0(colnames(table), collapse=' & '), ' \\\\ \\midrule\n'))
	for(i in 1:(nrow(table)-1)){
		cat(paste0(paste0(table[i,], collapse=' & '), ' \\\\ \n'))
	}
	cat('\\midrule\n')
	cat(paste0(paste0(table[nrow(table),], collapse=' & '), ' \\\\ \\bottomrule\n'))
	cat('\\end{tabular}\n')
	cat('\\end{table}\n')
}
