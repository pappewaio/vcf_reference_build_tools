#!/usr/bin/env bash

set -euo pipefail

test_script="convert_map_to_vcf"
initial_dir=$(pwd)"/${test_script}"
curr_case=""

mkdir "${initial_dir}"
cd "${initial_dir}"

#=================================================================================
# Helpers
#=================================================================================

function _setup {
  mkdir "${1}"
  cd "${1}"
  curr_case="${1}"
}

function _check_results {
  obs=$1
  exp=$2
  if ! diff ${obs} ${exp} &> ./difference; then
    echo "- [FAIL] ${curr_case}"
    cat ./difference 
    exit 1
  fi

}

function _run_script {

  "${test_script}.sh" ./input1.txt.gz ./input2.txt ./observed-result1.vcf.gz 

  _check_results <(gunzip -c ./observed-result1.vcf.gz) ./expected-result1.vcf

  if [ ! -f  ./observed-result1.vcf.gz.tbi ]; then
    echo "no tabix index genereated"
    exit 1;
  fi

  echo "- [OK] ${curr_case}"

  cd "${initial_dir}"
}

echo ">> Test ${test_script}"

#=================================================================================
# Cases
#=================================================================================

#---------------------------------------------------------------------------------
# Check that the final output is what we think it is

_setup "Simple test"

cat <<EOF | gzip -c > ./input1.txt.gz
ROWINDEX CHR POS ID REF ALT CHROM_GRCh38 POS_GRCh38 ID_dbSNP151 REF_dbSNP151 ALT_dbSNP151
7 1 7845695 rs428749 T C 1 7785635 rs228729 T C
8 1 8473813 rs42754538 C T 1 8413753 rs12754538 C T
9 1 10593296 rs4480782 G T 1 10533239 rs2480782 G T
EOF

cat <<EOF > ./input2.txt
ROWINDEX NEWRSID
1 rs228729
1 rs12754538
1 rs2480782
EOF

cat <<EOF > ./expected-result1.vcf
##fileformat=VCFv4.3
##FILTER=<ID=PASS,Description="All filters passed">
##fileDate=20210505
##source=exampleTestData
##INFO=<ID=AN,Number=1,Type=Integer,Description="Total number of alleles in called genotypes">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
1	7845695	rs228729	T	C	.	PASS	AN=5096
1	8473813	rs12754538	C	T	.	PASS	AN=5096
1	10593296	rs2480782	G	T	.	PASS	AN=5096
EOF

_run_script

#---------------------------------------------------------------------------------
# Next case

