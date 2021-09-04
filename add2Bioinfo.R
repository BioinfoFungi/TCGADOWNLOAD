# private static String[] filenames = new String[]{"Cancer","Study","DataOrigin","DataCategory","AnalysisSoftware","CancerStudy"};


library(BioinfoR)
library(tidyverse)

source("generate_proj.R")
initParam(authorization = "wangwang1749748955",host="http://8.140.164.151:8080")
showParam()
addOrganizeFile(enName = "132456",
                absolutePath = "/home/wy/Downloads/TCGA_ESCA_clinical.tsv",
                relativePath = "Downloads/TCGA_ACC_Counts.tsv")
proejct_df <- readr::read_csv("TCGA_PROJECT.csv")
global <- globalConfig()

proejct_df |>
  select(name=cancer,enName=cancer) |>
  write_tsv(file="Cancer.tsv")

data.frame(name=c("Cancer"),
            enName=c("Cancer")) |>
  write_tsv(file="data/Cancer.tsv")

data.frame(name=c("Study"),
            enName=c("Study")) |>
  write_tsv(file="data/Study.tsv")


data.frame(name=c("DataOrigin"),
            enName=c("DataOrigin")) |>
  write_tsv(file="data/DataOrigin.tsv")


data.frame(name=c("DataOrigin"),
            enName=c("DataOrigin")) |>
  write_tsv(file="data/DataCategory.tsv")


data.frame(name=c("AnalysisSoftware"),
            enName=c("AnalysisSoftware")) |>
  write_tsv(file="data/AnalysisSoftware.tsv")



result_df <- NULL
for(project in project_df[,1]){
  type = "FPKM"
  filename <- paste0(global$cancerStudy,"/TCGA_",project,"_",type,".tsv")
  result_df <- rbind(result_df,data.frame(filename,type,status =file.exists(filename),proj=project,file=paste0("TCGA_",project,"_",type,".tsv")))
  
  type = "Counts"
  filename <- paste0(global$cancerStudy,"/TCGA_",project,"_",type,".tsv")
  result_df <- rbind(result_df,data.frame(filename,type,status =file.exists(filename),proj=project,file=paste0("TCGA_",project,"_",type,".tsv")))
  
  type = "miRNA"
  filename <- paste0(global$cancerStudy,"/TCGA_",project,"_",type,".tsv")
  result_df <- rbind(result_df,data.frame(filename,type,status =file.exists(filename),proj=project,file=paste0("TCGA_",project,"_",type,".tsv")))
  
  type = "clinical"
  filename <- paste0(global$cancerStudy,"/TCGA_",project,"_",type,".tsv")
  result_df <- rbind(result_df,data.frame(filename,type,status =file.exists(filename),proj=project,file=paste0("TCGA_",project,"_",type,".tsv")))
 
   type = "mutation_varscan2"
  filename <- paste0(global$cancerStudy,"/TCGA_",project,"_",type,".tsv")
  result_df <- rbind(result_df,data.frame(filename,type,status =file.exists(filename),proj=project,file=paste0("TCGA_",project,"_",type,".tsv")))
  
  type = "miRNA_ISO"
  filename <- paste0(global$cancerStudy,"/TCGA_",project,"_",type,".tsv")
  result_df <- rbind(result_df,data.frame(filename,type,status =file.exists(filename),proj=project,file=paste0("TCGA_",project,"_",type,".tsv")))
  
}
addStudy(name = "varscan2突变数据",enName = "mutation_varscan2")
addStudy(name = "miRNA成熟体",enName = "miRNA_ISO")

apply(result_df, 1, function(x){
  message(x[1],"----",x[2],"---",x[3],"---",x[4],"---",x[5])
  addCancerStudy(cancer = x[4] ,study = x[2],dataOrigin = "TCGA",path = x[5])
})



