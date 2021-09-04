library(GEOquery)
library(tidyverse)

if(F){
    gse <- "GSE101124"
    absolutePath <- "/home/wangyang/Public/bioinfo/BRCA/data/GSE101123_series_matrix.txt.gz"
    workDir <- "."
}
gset <- getGEO(filename = absolutePath,getGPL = F)
expr <- gset@assayData[["exprs"]]
cat("$annotation:",gset@annotation,"\n")

gpl_url <- paste0("http://bioinfo.online:8082/data/GPL/",gset@annotation,".tsv.gz")
gpl <- read_tsv(gpl_url)
expr |>
    as.data.frame() |>
    rownames_to_column("probeId") |> 
    inner_join(gpl, by="probeId") |>
    dplyr::select(-probeId) %>%
    aggregate(. ~ symbol, data = ., mean) -> expr_symbol

if(!file.exists("GSE")){
     dir.create("GSE",recursive = T)
}
saveFile_expr <- paste0(workDir,"/GSE/",gse,"_expr.tsv")
saveFile_metadata <- paste0(workDir,"/GSE/",gse,"_metadata.tsv")
write_tsv(expr_symbol, file=saveFile_expr)
write_tsv(gset@phenoData@data, file=saveFile_metadata)

system(paste0("gzip -f ",saveFile_expr))
system(paste0("gzip -f ",saveFile_metadata))



cat("$expr:",saveFile_expr,".gz\n")
cat("$metadata:",saveFile_metadata,".gz\n")
cat("$update:true","\n")