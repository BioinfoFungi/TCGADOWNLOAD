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
filename <- gsub("-","_",paste0("result/",project,"_Counts.tsv"))
query<- GDCquery(project = project,
                       data.category = "Transcriptome Profiling",
                       data.type = "Gene Expression Quantification",
                       workflow.type = "HTSeq - Counts")

# match.file.cases <- getResults(query,cols=c("cases","file_name"))
# match.file.cases$project <- project
GDCdownload(query,directory = "GDCdata/Counts",method = "api")
data <- GDCprepare(query,
                         directory = "GDCdata/Counts",
                         summarizedExperiment = F,
                         save = F)
readr::write_tsv(data,file =filename)
system(paste0("gzip ",filename))

cat("$update:true","\n")
cat("$absolutePath:",paste0(workDir,"/",filename,".gz"))
