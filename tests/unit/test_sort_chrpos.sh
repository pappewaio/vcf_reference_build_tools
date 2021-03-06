#!/usr/bin/env bash

set -euo pipefail

test_script="sort_chrpos"
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

_setup "Sort on chrpos"

cat <<EOF > ./input.tsv
8 10:106524737 . G A
9 10:101966771 . T C
10 10:102814179 . T C
11 10:104355789 . T C
12 10:10574522 . T C
13 10:105905360 . A G
14 10:106322887 . C T
15 10:106371703 . C A
16 10:100157763 . C T
EOF

cat <<EOF > ./expected-result1.tsv
16 10:100157763 . C T
9 10:101966771 . T C
10 10:102814179 . T C
11 10:104355789 . T C
12 10:10574522 . T C
13 10:105905360 . A G
14 10:106322887 . C T
15 10:106371703 . C A
8 10:106524737 . G A
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
