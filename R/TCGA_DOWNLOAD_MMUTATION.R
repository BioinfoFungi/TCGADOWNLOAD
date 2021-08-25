library(TCGAbiolinks)
getwd()
filename <- gsub("-","_",paste0("result/TCGA_",project,"_mutation_varscan2.tsv"))
message(">>>>>>>>>>>>>>>>>>>>",filename)
maf <- GDCquery_Maf(cancer, pipelines = "varscan2")
readr::write_tsv(maf,file =filename )

cat("$update:true","\n")
cat("$absolutePath:",paste0(workDir,"/",filename,".gz"))