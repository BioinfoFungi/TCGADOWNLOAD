library(tidyverse)
TCGA_GTEX_category <- read_tsv("UCSCdata/TCGA_GTEX_category.txt")
summ_TcgaGtex_category <- TCGA_GTEX_category %>% 
  add_count(TCGA_GTEX_main_category) %>% 
  mutate(project = str_sub(TCGA_GTEX_main_category, 1, 4),
         tissue_type = str_sub(TCGA_GTEX_main_category, 6),
         n_sample = n) %>% 
  arrange(tissue_type) %>% 
  select(TCGA_GTEX_main_category, project, tissue_type, n_sample) %>% 
  distinct()

gencode_v23 <- read_tsv("UCSCdata/probeMap%2Fgencode.v23.annotation.gene.probemap")
id2symbol <- gencode_v23 %>% select(id = id, symbol = gene)
TTG_raw_counts <- read_tsv("UCSCdata/TcgaTargetGtex_gene_expected_count.gz")


TCGA_GTEX_category%>%
  filter(str_detect(TCGA_GTEX_main_category, pattern = "GTEX")) -> sample
table(sample$TCGA_GTEX_main_category)
PROJECT <- c("Adipose","Adrenal","Bladder","Blood","Vessel","Brain","Breast",
             "Cervix","Colon","Esophagus","Fallopian","Heart","Kidney","Liver","Lung",
             "Muscle","Nerve","Ovary","Pancreas","Pituitary","Prostate","Salivary",
             "Skin","Intestine","Spleen","Stomach","Testis","Thyroid","Uterus","Vagina")

length(PROJECT)
 
## liver noraml & cancer
# GTEx Liver
# TCGA LIHC
TcgaGtex_liver_sample <- TCGA_GTEX_category %>% 
  dplyr::filter(str_detect(TCGA_GTEX_main_category, pattern = "Tissue")) %>% 
  mutate(group = ifelse(str_detect(TCGA_GTEX_main_category, pattern = "GTEX"),
                        "normal",
                        ifelse(str_sub(sample, 14, 15) == "11", 
                               "para_tumor", "tumor")))
table(TcgaGtex_liver_sample$group)


table(TCGA_GTEX_category$TCGA_GTEX_main_category)
