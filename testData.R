###############################################
# private static String[] filenames = new String[]{"Cancer","Study","DataOrigin","DataCategory","AnalysisSoftware","CancerStudy"};
# private String cancer;
# private String study;
# private String dataOrigin;
# private String dataCategory;
# private String gse;
# private String analysisSoftware;
# private String processedAbsolutePath;
# private String processedRelativePath;
# private Integer processedId;
# private String absolutePath;
# private String relativePath;
###############################################

library(tidyverse)

data.frame(name=c("Cancer"),
            enName=c("Cancer")) |>
  write_tsv(file="data/Cancer.tsv")

data.frame(name=c("Study"),
            enName=c("Study")) |>
  write_tsv(file="data/Study.tsv")

data.frame(name=c("DataOrigin"),
            enName=c("DataOrigin")) |>
  write_tsv(file="data/DataOrigin.tsv")

data.frame(name=c("DataCategory"),
            enName=c("DataCategory")) |>
  write_tsv(file="data/DataCategory.tsv")

data.frame(name=c("AnalysisSoftware"),
            enName=c("AnalysisSoftware")) |>
  write_tsv(file="data/AnalysisSoftware.tsv")

data.frame(cancer=c("Cancer"),
            study=c("Study"),
            dataOrigin=c("DataOrigin"),
            dataCategory=("DataCategory"),
            analysisSoftware=("AnalysisSoftware"),
            absolutePath=c("/home/wangyang/workspace/TCGADOWNLOAD/data/AnalysisSoftware.tsv")) |>
  write_tsv(file="data/CancerStudy.tsv")



project_df <- readr::read_csv("TCGA_PROJECT.csv")
project_df |>
  select(name=cancer,enName=cancer) |>
  write_tsv(file="data/Cancer.tsv")

data.frame(name=c("mRNA_lncRNA","mRNA","lncRNA","miRNA","circRNA","clinical","mutation"),
            enName=c("mRNA_lncRNA","mRNA","lncRNA","miRNA","circRNA","clinical","mutation")) |>
  write_tsv(file="data/Study.tsv")


data.frame(name=c("TCGA","ICGC","GEO"),
            enName=c("TCGA","ICGC","GEO")) |>
  write_tsv(file="data/DataOrigin.tsv")

data.frame(name=c("SOURCE_COUNT","SOURCE_FPKM","SOURCE_CLINICAL","SOURCE_PRE_MIRNA","SOURCE_MATURE_MIRNA","SOURCE_MUTATION",
                    "PRE_MIRNA","MATURE_MIRNA","COUNTS","FPKM","DEG","MUTATION"),
            enName=c("SOURCE_COUNT","SOURCE_FPKM","SOURCE_CLINICAL","SOURCE_PRE_MIRNA","SOURCE_MATURE_MIRNA","SOURCE_MUTATION",
                    "PRE_MIRNA","MATURE_MIRNA","COUNTS","FPKM","DEG","MUTATION")) |>
  write_tsv(file="data/DataCategory.tsv")

data.frame(name=c("limma","DESeq2","VarScan2"),
            enName=c("limma","DESeq2","VarScan2")) |>
  write_tsv(file="data/AnalysisSoftware.tsv")

data.frame(cancer= c("UCEC","UCEC"),
            study= c("mRNA_lncRNA","mRNA"),
            dataOrigin= c("TCGA","TCGA"),
            dataCategory= c("FPKM","FPKM"),
            analysisSoftware=c("DESeq2",""),
            absolutePath=c("/home/wangyang/workspace/TCGADOWNLOAD/data/AnalysisSoftware.tsv",
                          "/home/wangyang/workspace/TCGADOWNLOAD/data/AnalysisSoftware.tsv")) |> 
  write_tsv(file="data/CancerStudy.tsv")
  


result_df <- NULL
base_path <- "data"
for(project in project_df[,1]){
  type = "SOURCE_FPKM"
  filename <- paste0(base_path,"/TCGA_",project,"_",type,".tsv")
  result_df <- rbind(result_df,data.frame(cancer=project,study="mRNA_lncRNA",dataOrigin="TCGA",dataCategory=type,status =file.exists(filename),absolutePath=filename))
  
  type = "SOURCE_COUNT"
  filename <- paste0(base_path,"/TCGA_",project,"_",type,".tsv")
  result_df <- rbind(result_df,data.frame(cancer=project,study="mRNA_lncRNA",dataOrigin="TCGA",dataCategory=type,status =file.exists(filename),absolutePath=filename))
  
  type = "SOURCE_PRE_MIRNA"
  filename <- paste0(base_path,"/TCGA_",project,"_",type,".tsv")
  result_df <- rbind(result_df,data.frame(cancer=project,study="miRNA",dataOrigin="TCGA",dataCategory=type,status =file.exists(filename),absolutePath=filename))

  type = "SOURCE_MATURE_MIRNA"
  filename <- paste0(base_path,"/TCGA_",project,"_",type,".tsv")
  result_df <- rbind(result_df,data.frame(cancer=project,study="miRNA",dataOrigin="TCGA",dataCategory=type,status =file.exists(filename),absolutePath=filename))
  

  type = "SOURCE_CLINICAL"
  filename <- paste0(base_path,"/TCGA_",project,"_",type,".tsv")
  result_df <- rbind(result_df,data.frame(cancer=project,study="clinical",dataOrigin="TCGA",dataCategory=type,status =file.exists(filename),absolutePath=filename))
 

  type = "SOURCE_MUTATION"
  filename <- paste0(base_path,"/TCGA_",project,"_",type,".tsv")
  result_df <- rbind(result_df,data.frame(cancer=project,study="mutation",dataOrigin="TCGA",dataCategory=type,status =file.exists(filename),absolutePath=filename))
  
}

result_df |> 
  mutate(absolutePath=paste0(base_path,"/",paste(dataOrigin,cancer,study,dataCategory,sep="_"),".tsv")) |>
  mutate(name=paste0(cancer,"_")) |>
  mutate(absolutePath= "/home/wangyang/workspace/TCGADOWNLOAD/code.R") |>
    write_tsv(file="data/Code.tsv") #View()

