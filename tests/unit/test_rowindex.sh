#!/usr/bin/env bash

set -euo pipefail

test_script="sort_rowindex"
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

  "${test_script}.sh" ./input.tsv ./observed-result1.tsv

  _check_results ./observed-result1.tsv ./expected-result1.tsv

  echo "- [OK] ${curr_case}"

  cd "${initial_dir}"
}

echo ">> Test ${test_script}"

#=================================================================================
# Cases
#=================================================================================

#---------------------------------------------------------------------------------
# Check that the final output is what we think it is

_setup "Sort on rowindex"

cat <<EOF > ./input.tsv
16 NA . C T 10:100157763 NA NA NA
9 NA . T C 10:101966771 NA NA NA
11 NA . T C 10:104355789 NA NA NA
10 10:104573936 . T C 10:104573936 rs284858 T C
13 NA . A G 10:105905360 NA NA NA
12 10:10616485 . T C 10:10616485 rs2025468 T C
14 NA . C T 10:106322887 NA NA NA
8 NA . G A 10:106524737 NA NA NA
15 10:108131461 . C A 10:108131461 rs1409409 C A
EOF

cat <<EOF > ./expected-result1.tsv
8 NA . G A 10:106524737 NA NA NA
9 NA . T C 10:101966771 NA NA NA
10 10:104573936 . T C 10:104573936 rs284858 T C
11 NA . T C 10:104355789 NA NA NA
12 10:10616485 . T C 10:10616485 rs2025468 T C
13 NA . A G 10:105905360 NA NA NA
14 NA . C T 10:106322887 NA NA NA
15 10:108131461 . C A 10:108131461 rs1409409 C A
16 NA . C T 10:100157763 NA NA NA
EOF

_run_script

#---------------------------------------------------------------------------------
# Next case

#_setup "valid_rows_missing_afreq"
#
#cat <<EOF > ./acor.tsv
#0	A1	A2	CHRPOS	RSID	EffectAllele	OtherAllele	EMOD
#1	A	G	12:126406434	rs1000000	G	A	-1
#EOF
#
#cat <<EOF > ./stat.tsv
#0	B	SE	Z	P
#1	-0.0143	0.0156	-0.916667	0.3604
#EOF
#
#_run_script
