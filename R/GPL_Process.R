library(GEOquery)
library(tidyverse)

if(!exists(absolutePath)){
    absolutePath <- "/home/wangyang/Public/bioinfo/BRCA/data/GPL19978.soft.gz"
    probeId <- "ID"
    symbol<- "circRNA"
    workDir <- "."
    enName <- "GPL19978"
}
probeId_ <- probeId
symbol_ <- symbol
cat(absolutePath,"\n")
gpl_obj <- getGEO(filename = absolutePath)
gpl <- gpl_obj@dataTable@table |> 
    dplyr::select(probeId=probeId_,symbol=symbol_) -> gpl_two


saveFile <- paste0(workDir,"/GPL/",enName,".tsv")
if(!file.exists("GPL")){
     dir.create("GPL",recursive = T)
}

write_tsv(gpl_two, file=saveFile)
system(paste0("gzip -f ",saveFile))
# cat(symbol,"\n")
# cat(probeId,"\n")
cat("$absolutePath:",paste0(saveFile,".gz"),"\n")

