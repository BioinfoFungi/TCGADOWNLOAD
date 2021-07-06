#!/usr/bin/env python
import pandas as pd
df = pd.read_csv("TCGA_PROJECT.csv")
for item in df['TCGA_ID']:
  print("./DownloadFPKM.R FPKM {0}".format(item))
  print("./DownloadFPKM.R Counts {0}".format(item))
  print("./DownloadFPKM.R miRNA {0}".format(item))

