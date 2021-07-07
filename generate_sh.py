#!/usr/bin/env python
import pandas as pd
df = pd.read_csv("TCGA_PROJECT.csv")
for item in df['TCGA_ID']:
  print("./DownloadExpre.R FPKM {0}".format(item))
  print("./DownloadExpre.R Counts {0}".format(item))
  print("./DownloadExpre.R miRNA {0}".format(item))
  print("./DownloadExpre.R miRNA_ISO {0}".format(item))

