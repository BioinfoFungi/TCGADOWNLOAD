#!/usr/bin/Rscript
library(DESeq2)
library(tibble)
if(F){
  library(SummarizedExperiment)
  proj <- "TCGA-GBM"
  query <- GDCquery(
    project = proj,
    data.category = "Transcriptome Profiling", 
    data.type = "Gene Expression Quantification",
    workflow.type = "HTSeq - Counts"
  )
  GDCdownload(query,directory = "GDCdata/Counts")
  data <- GDCprepare(query,directory = "GDCdata/Counts")
  data <- data[,!is.na(data$paper_IDH.status)]
  data$paper_IDH.status
  colData(data)
  data$gender
}
getwd()
args=commandArgs(T)

gff_v22 <- readr::read_tsv("http://wangyang-bucket.oss-cn-beijing.aliyuncs.com/gencode.gene.info.v22.tsv")
id2symbol <- gff_v22 %>%
  dplyr::select(1,2)

PRJIECT="TCGA-LGG"
PRJIECT=args[1]
filename <- gsub("-","_",paste0("result/",PRJIECT,"_DESeq2.tsv"))
if(file.exists(filename)){
  message("#######################存在",filename)
}else{
  read_file <- gsub("-","_",paste0("result/",PRJIECT,"_Counts.tsv"))
  readr::read_tsv(read_file)%>%
    {.[1:(nrow(.)-5),]} %>%
    tibble::column_to_rownames("X1")%>%
    {.[id2symbol$gene_id,]}-> expr

  
  message(PRJIECT," ff_v22: ",nrow(id2symbol),
          " expr: ",nrow(expr)," 交集: ",
          length(intersect(rownames(expr),id2symbol$gene_id)),
          " identical: ",identical(rownames(expr),id2symbol$gene_id))
  
  expr%>%
    dplyr::mutate(symbol=gff_v22$gene_name)%>%
    {.[!duplicated(.$symbol),]}%>%
    remove_rownames()%>%
    tibble::column_to_rownames("symbol")-> expr
  
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
    message(">>>>>>>>>>>>>>>>",read_file,"开始分析>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
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
  }else{
    message("!!!!!!!!!!!!!!!!!!!!!",PRJIECT,"没有正常样本!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1")
  }
}



