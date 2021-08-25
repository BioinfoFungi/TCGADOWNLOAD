#!/usr/bin/Rscript
library(DESeq2)
library(tidyverse)

if(F){
  absolutePath <- "/home/wangyang/.bioinfo/data/result/TCGA_PRAD_miRNA_COUNTS.tsv.gz"
  cancer <- "PRAD"
}

project <- paste0("TCGA-",cancer)
message(project)

filename <- gsub("-","_",paste0("result/",project,"_miRNA_DESeq2.tsv"))
save_path <- paste0(workDir,"/",filename,".gz")
cat("\n")
cat(filename,"\n")
cat(save_path,"\n")
cat(absolutePath,"\n")

read_tsv(absolutePath)%>%
  dplyr::select("miRNA_ID",starts_with("read_count"))%>%
  rename_at(vars(contains("read_count")), ~ substr(.,12,length(.)))%>%
  column_to_rownames("miRNA_ID")->expr

tibble::tibble(
  TCGA_id_full=colnames(expr),
  TCGA_id = stringr::str_sub(TCGA_id_full, 1, 16),
  patient_id = stringr::str_sub(TCGA_id, 1, 12),
  tissue_type_id = stringr::str_sub(TCGA_id, 14, 15),
  tissue_type = sapply(tissue_type_id, function(x) {
    switch(x,
           "01" = "Primary Solid Tumor",
           "02" = "Recurrent Solid Tumor",
           "03" = "Primary Blood Derived Cancer - Peripheral Blood",
           "05" = "Additional - New Primary",
           "06" = "Metastatic",
           "07" = "Additional Metastatic",
           "11" = "Solid Tissue Normal")}),
  group = ifelse(tissue_type_id == "11", "Normal", "Tumor")
)->metadata

statistic <-table(metadata$group)
message("Normal: ",statistic[1] ," Tumor: ",statistic[2])

if(length(statistic)==2){
  message(">>>>>>>>>>>>>>>>",project,"开始分析>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
  metadata$group <- factor(metadata$group)
  dds <- DESeqDataSetFromMatrix(countData = expr,
                                colData = metadata,
                                design = ~ group)

  keep <- rowSums(counts(dds) > 0) >= min(table(metadata$group))
  dds_filt <- dds[keep, ]
  dds2 <- DESeq(dds_filt, parallel = T)
  message(resultsNames(dds2))
  res <- results(dds2)
  deg <- as.data.frame(res)%>%
    rownames_to_column("symbol")
  readr::write_tsv(deg,file = filename)
  system(paste0("gzip ",filename))
  cat("$absolutePath:",save_path)
}else{
  message("!!!!!!!!!!!!!!!!!!!!!",project,"没有正常样本!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1")
}
# read_tsv(absolutePath)%>%
#   dplyr::select("miRNA_ID",starts_with("read_count"))%>%
#   rename_at(vars(contains("read_count")), ~ substr(.,12,length(.)))%>%
#   column_to_rownames("miRNA_ID")->expr
# 
# tibble::tibble(
#   TCGA_id_full=colnames(expr),
#   TCGA_id = stringr::str_sub(TCGA_id_full, 1, 16),
#   patient_id = stringr::str_sub(TCGA_id, 1, 12),
#   tissue_type_id = stringr::str_sub(TCGA_id, 14, 15),
#   tissue_type = sapply(tissue_type_id, function(x) {
#     switch(x,
#            "01" = "Primary Solid Tumor",
#            "02" = "Recurrent Solid Tumor",
#            "03" = "Primary Blood Derived Cancer - Peripheral Blood",
#            "05" = "Additional - New Primary",
#            "06" = "Metastatic",
#            "07" = "Additional Metastatic",
#            "11" = "Solid Tissue Normal")}),
#   group = ifelse(tissue_type_id == "11", "Normal", "Tumor")
# )->metadata
# 
# statistic <-table(metadata$group)
# message("Normal: ",statistic[1] ," Tumor: ",statistic[2])
# 
# if(length(statistic)==2){
#   message(">>>>>>>>>>>>>>>>",project,"开始分析>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
#   metadata$group <- factor(metadata$group)
#   dds <- DESeqDataSetFromMatrix(countData = expr,
#                                 colData = metadata,
#                                 design = ~ group)
# 
#   keep <- rowSums(counts(dds) > 0) >= min(table(metadata$group))
#   dds_filt <- dds[keep, ]
#   dds2 <- DESeq(dds_filt, parallel = T)
#   message(resultsNames(dds2))
#   res <- results(dds2)
#   deg <- as.data.frame(res)%>%
#     rownames_to_column("symbol")
#   readr::write_tsv(deg,file = filename)
#   cat("$absolutePath:",save_path)
# }else{
#   message("!!!!!!!!!!!!!!!!!!!!!",project,"没有正常样本!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1")
# }


