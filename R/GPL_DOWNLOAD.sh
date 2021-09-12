GPL=${gse}
echo "sleep 1h"
downlaod="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?targ=self&acc=${GPL}&form=text&view=full -O  ${GPL}.soft"
echo $downlaod
wget $downlaod

echo "\$[0]absolutePath:${workDir}/${GPL}.soft"
#echo "\$[0]update:true"
echo "\$[0]analysisSoftware:download"
gpl_download=${workDir}/${GPL}.soft