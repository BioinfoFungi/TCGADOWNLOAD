#!/usr/bin/env python
import pandas as pd
df = pd.read_csv("TCGA_PROJECT.csv")
for item in df['TCGA_ID']:
  print("./Deseq2.R {0}".format(item))

