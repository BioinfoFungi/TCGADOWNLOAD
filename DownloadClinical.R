#!/usr/bin/Rscript
library(TCGAbiolinks)
getwd()

args=commandArgs(T)
project= args[1]
filename <- gsub("-","_",paste0("result/",project,"_clinical.tsv"))
if(file.exists(filename)){

	message("###########",filename,"存在#########################")
}else{
	message(">>>>>>>>>>>>>>>>>>>>",filename)
	clinical <- GDCquery_clinic(project = project, type = "clinical")
	readr::write_tsv(clinical,file =filename )
}

