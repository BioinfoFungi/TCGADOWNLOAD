#!/usr/bin/Rscript
library(TCGAbiolinks)
getwd()

project_df <- (function(){
  projects <- TCGAbiolinks:::getGDCprojects()$project_id
  projects_full <- projects[grepl('^TCGA',projects,perl=T)]
  projects_ID <- sapply(projects_full,function(x){stringi::stri_sub(x,6,10)})
  res <- data.frame(cancer=projects_ID,TCGA_ID=projects_full)
  return(res)
})()

for(project in  project_df[,1]){
	filename <- gsub("-","_",paste0("result/TCGA_",project,"_mutation_varscan2.tsv"))
	if(file.exists(filename)){

		message("###########",filename,"存在#########################")
		next
	}else{
		message(">>>>>>>>>>>>>>>>>>>>",filename)
	  maf <- GDCquery_Maf(project, pipelines = "varscan2")
		readr::write_tsv(maf,file =filename )
	}
}
