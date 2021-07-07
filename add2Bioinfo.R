library(BioinfoR)
source("generate_proj.R")
initParam(authorization = "")
showParam()
proejct_df <- readr::read_tsv("TCGA_PROJECT.csv")
global <- globalConfig()


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



