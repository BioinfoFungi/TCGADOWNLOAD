library(GEOquery)
library(tidyverse)

if(F){
    gse <- "GSE10469"
    absolutePath <- "/home/wangyang/.bioinfo/data/GSE10469_series_matrix.txt.gz"
    workDir <- "."
}
gset <- getGEO(filename = absolutePath,getGPL = F)
expr <- gset@assayData[["exprs"]]


gpl_url <- paste0("http://localhost:8080/data/GPL/",gset@annotation,".tsv.gz")
gpl <- read_tsv(gpl_url)
# View(gpl)
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

gse_download <- paste0(saveFile_expr,".gz")
metadata <-  paste0(saveFile_metadata,".gz")
cat("$[0]analysisSoftware:","integrated_expression_matrix","\n")
cat("$[0]annotation:",gset@annotation,"\n")
cat("$[0]absolutePath:",saveFile_expr,".gz\n")

cat("$[1]absolutePath:",saveFile_metadata,".gz\n")
cat("$[1]analysisSoftware:","metadata","\n")

#cat("$update:true","\n")