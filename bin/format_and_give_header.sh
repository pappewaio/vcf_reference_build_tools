infile=$1
outfile=$2
build=$3

# Add header and cut off rownindex
if [ "${build}" == "GRCh38" ]; then
  echo -e "ROWINDEX CHR POS ID REF ALT CHROM_GRCh37 POS_GRCh37 ID_dbSNP151 REF_dbSNP151 ALT_dbSNP151" > ${outfile}
else
  echo -e "ROWINDEX CHR POS ID REF ALT CHROM_GRCh38 POS_GRCh38 ID_dbSNP151 REF_dbSNP151 ALT_dbSNP151" > ${outfile}
fi

awk '
{
  if($2=="NA"){pos1="NA"; pos2="NA"
  }else{split($2,gr,":"); pos1=gr[1]; pos2=gr[2]};
  if($6=="NA"){pos3="NA"; pos4="NA"
  }else{split($6,gr,":"); pos3=gr[1]; pos4=gr[2]};

  print $1, pos1, pos2, $3, $4, $5, pos3, pos4, $7, $8, $9
}' ${infile} >> ${outfile}

