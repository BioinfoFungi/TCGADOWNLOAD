library(GEOquery)
library(tidyverse)


probeId_ <- probeId
symbol_ <- symbol
cat(absolutePath,"\n")
gpl_obj <- getGEO(filename = absolutePath)
gpl <- gpl_obj@dataTable@table |> 
    dplyr::select(probeId=probeId_,symbol=symbol_) -> gpl_two


saveFile <- paste0(workDir,"/GPL/",gse,".tsv")
if(!file.exists("GPL")){
     dir.create("GPL",recursive = T)
}

write_tsv(gpl_two, file=saveFile)
system(paste0("gzip -f ",saveFile))

gpl_absolutePath <- paste0(saveFile,".gz")

# cat(symbol,"\n")
# cat(probeId,"\n")
cat("$[0]absolutePath:",paste0(saveFile,".gz"),"\n")
cat("$[0]analysisSoftware:","download","\n")
