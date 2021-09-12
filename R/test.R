library(tidyverse)
library(GEOquery)

read_tsv("GPL6480.txt") |>
    separate(col = name, into = c("name", "GSE"), sep = "=") |> 
    dplyr::filter(name == "!Platform_series_id ") -> gse_df
 
gse <- str_trim(gse_df$GSE, side="both")

tibble(
    gse= "GPL6480",
    dataOrigin="GEO",
    dataCategory="GPL",
    analysisSoftware="add_manully",
    param="{probeId:'ID',symbol:'GENE_SYMBOL'}"
) -> gpl_df 

tibble(
    gse= gse,
    dataOrigin="GEO",
    dataCategory="GSE",
    analysisSoftware="add_manully",
    param=""
) -> gse_df
rbind(gpl_df,gse_df) |> #View()
    write_tsv(file="data/CancerStudy.tsv")
