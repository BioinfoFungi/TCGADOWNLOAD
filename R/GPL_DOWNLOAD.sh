GPL=${enName}

downlaod="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?targ=self&acc=${GPL}&form=text&view=full -O  ${GPL}.soft"
echo $downlaod
# wget $downlaod
echo "\$absolutePath:${workDir}/${GPL}.soft"
echo "\$update:true"

