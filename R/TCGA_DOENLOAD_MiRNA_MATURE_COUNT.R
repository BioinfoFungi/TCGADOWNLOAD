library(TCGAbiolinks)
getwd()
#####下载COUNT
if(!file.exists("GDCdata/Counts")){
    dir.create("GDCdata/Counts",recursive = T)
}
if(!file.exists("result")){
    dir.create("result")
}

project <- paste0("TCGA-",cancer)
message(project)
match.file.cases.all <- NULL
filename <- gsub("-","_",paste0("result/",project,"_miRNA_MATURE_COUNTS.tsv"))
query<- GDCquery(project = project,
                 data.category = "Transcriptome Profiling",
                 data.type = "Isoform Expression Quantification",
                 workflow.type = "BCGSC miRNA Profiling")

GDCdownload(query,directory = "GDCdata/miRNA_ISO",method = "api")
data <- GDCprepare(query,
        directory = "GDCdata/miRNA_ISO",
        summarizedExperiment = F,
        save = F)
readr::write_tsv(data,file =filename )
system(paste0("gzip ",filename))

cat("$update:true","\n")
cat("$absolutePath:",paste0(workDir,"/",filename,".gz"))
