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

#####下载FPKM
(function(){
  if(!file.exists("GDCdata/FPKM")){
    dir.create("GDCdata/FPKM",recursive = T)
  }
  if(!file.exists("result")){
    dir.create("result")
  }
  match.file.cases.all <- NULL
  for(project in  project_df[,2]){
    filename <- gsub("-","_",paste0("result/",project,"_FPKM.tsv"))
    if(file.exists(filename)){
      message("###########",filename,"存在#######################################################")
      next
    }else{
      query<- GDCquery(project = project,
                       data.category = "Transcriptome Profiling",
                       data.type = "Gene Expression Quantification",
                       workflow.type = "HTSeq - FPKM")




      match.file.cases <- getResults(query,cols=c("cases","file_name"))
      match.file.cases$project <- project
      match.file.cases.all <- rbind(match.file.cases.all,match.file.cases)

      GDCdownload(query,directory = "GDCdata/FPKM",method = "api")

      table(match.file.cases.all$project)
      data <- GDCprepare(query,
                         directory = "GDCdata/FPKM",
                         summarizedExperiment = F,
                         save = F)
      readr::write_tsv(data,file =filename )
    }
  }
  readr::write_tsv(match.file.cases.all, path =  "TCGA_FPKM.tsv")
})()

#####下载COUNT
(function(){
  if(!file.exists("GDCdata/Counts")){
    dir.create("GDCdata/Counts",recursive = T)
  }
  if(!file.exists("result")){
    dir.create("result")
  }
  match.file.cases.all <- NULL
  for(project in  project_df[,2]){
    filename <- gsub("-","_",paste0("result/",project,"_Counts.tsv"))
    if(file.exists(filename)){

      message("###########",filename,"存在#######################################################")
      next
    }else{
      query<- GDCquery(project = project,
                       data.category = "Transcriptome Profiling",
                       data.type = "Gene Expression Quantification",
                       workflow.type = "HTSeq - Counts")




      match.file.cases <- getResults(query,cols=c("cases","file_name"))
      match.file.cases$project <- project
      match.file.cases.all <- rbind(match.file.cases.all,match.file.cases)

      GDCdownload(query,directory = "GDCdata/Counts",method = "api")

      table(match.file.cases.all$project)

      data <- GDCprepare(query,
                         directory = "GDCdata/Counts",
                         summarizedExperiment = F,
                         save = F)
      readr::write_tsv(data,file =filename )
    }
  #  project <- "TCGA-BRCA"

  }
  readr::write_tsv(match.file.cases.all, path =  "TCGA_Counts.tsv")
})()
#####下载miRNA
(function(){
  if(!file.exists("GDCdata/miRNA")){
    dir.create("GDCdata/miRNA",recursive = T)
  }
  if(!file.exists("result")){
    dir.create("result")
  }
  match.file.cases.all <- NULL
  for(project in  project_df[,2]){
    filename <- gsub("-","_",paste0("result/",project,"_miRNA.tsv"))
    if(file.exists(filename)){

      message("###########",filename,"存在#######################################################")
      next
    }else{
      #project <- "TCGA-BRCA"
      query<- GDCquery(project = project,
                       data.category = "Transcriptome Profiling",
                       data.type = "miRNA Expression Quantification",
                       workflow.type = "BCGSC miRNA Profiling")

      match.file.cases <- getResults(query,cols=c("cases","file_name"))
      match.file.cases$project <- project
      match.file.cases.all <- rbind(match.file.cases.all,match.file.cases)

      GDCdownload(query,directory = "GDCdata/miRNA",method = "api")

      table(match.file.cases.all$project)


      data <- GDCprepare(query,
                         directory = "GDCdata/miRNA",
                         summarizedExperiment = F,
                         save = F)
      readr::write_tsv(data,file =filename )
    }

  }
  readr::write_tsv(match.file.cases.all, path =  "TCGA_miRNA.tsv")
})()
