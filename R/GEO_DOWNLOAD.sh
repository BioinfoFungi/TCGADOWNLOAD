# GEO="GSE161784"
GEO=${gse}
GEO_END=${GEO:(-3)}
#https://ftp.ncbi.nlm.nih.gov/geo/series/GSE101nnn/GSE101123/matrix/GSE101123_series_matrix.txt.gz

download="https://ftp.ncbi.nlm.nih.gov/geo/series/${GEO/${GEO_END}/nnn}/${GEO}/matrix/${GEO}_series_matrix.txt.gz"
echo "$download"
wget "${download}"
echo "\$absolutePath:${workDir}/${GEO}_series_matrix.txt.gz"
echo "\$update:true"





