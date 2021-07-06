#!/usr/bin/Rscript
library(TCGAbiolinks)
getwd()

args=commandArgs(T)
print(args[1])
#type="FPKM"
#project = "TCGA-CHOL"
type=args[1]
project = args[2]

#####下载FPKM
(function(){
	 if(!file.exists("GDCdata/FPKM")){
		 dir.create("GDCdata/FPKM",recursive = T)
	 }
	 if(!file.exists("GDCdata/Counts")){
		 dir.create("GDCdata/Counts",recursive = T)
	 }
	 if(!file.exists("result")){
		 dir.create("result")
	 }

	 if(!file.exists("GDCdata/miRNA")){
		 dir.create("GDCdata/miRNA",recursive = T)
	 }
	 #	 match.file.cases.all <- NULL
	 #  for(project in  project_df[,2]){
	 filename <- gsub("-","_",paste0("result/",project,"_",type,".tsv"))
	 if(file.exists(filename)){
		 message("###########",filename,"存在#######################################################")
	 }else{

		 message("###########创建",filename,"#######################################################")
		 if(type=="FPKM"){
			 query<- GDCquery(project = project,
					  data.category = "Transcriptome Profiling",
					  data.type = "Gene Expression Quantification",
					  workflow.type = "HTSeq - FPKM")

			 GDCdownload(query,directory = "GDCdata/FPKM",method = "api")
			 data <- GDCprepare(query,
					    directory = "GDCdata/FPKM",
					    summarizedExperiment = F,
					    save = F)
			 readr::write_tsv(data,file =filename )
		 }else if(type=="Counts"){

			 query<- GDCquery(project = project,
					  data.category = "Transcriptome Profiling",
					  data.type = "Gene Expression Quantification",
					  workflow.type = "HTSeq - Counts")

			 GDCdownload(query,directory = "GDCdata/Counts",method = "api")
			 data <- GDCprepare(query,
					    directory = "GDCdata/Counts",
					    summarizedExperiment = F,
					    save = F)
			 readr::write_tsv(data,file =filename )
		 }else if(type=="miRNA"){

			 query<- GDCquery(project = project,
					  data.category = "Transcriptome Profiling",
					  data.type = "miRNA Expression Quantification",
					  workflow.type = "BCGSC miRNA Profiling")

			 GDCdownload(query,directory = "GDCdata/miRNA",method = "api")
			 data <- GDCprepare(query,
					    directory = "GDCdata/miRNA",
					    summarizedExperiment = F,
					    save = F)
			 readr::write_tsv(data,file =filename )
		 }


	 }
})()
