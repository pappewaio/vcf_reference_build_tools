# vcf_reference_build_tools
A tool to update or add reference build information such as position, rsid, etc


## Introduction
Right now this tool is built to add information to an in-house imputation project, but it is written to be used on any vcf file. For speed purposes, we use the dbsnp reference data from the cleansumstats pipeline. If necessary, I will add in this package how to create the used dbsnp reference data format from scratch.

## Example data
### Dbsnp reference data
The data is not only formatted, but also filtered to exclude indels and non unique positions. Location is : `data/dbsnp`

### Examle 1kg vcf file
For simplicity we use a set of variants from the 1kg data that also exists in the example dbsnp. Location is : `data/1kgp`

## Run the script
It is possible to submit a set of vcf files, each will be given a map file with all coordinates according to dbsnp151

```
# install nextflow using mamba (requires conda/mamba)
mamba create -n vcf_reference_build_tools_env nextflow==20.10.0 --channel bioconda

# Activate environment
conda activate vcf_reference_build_tools_env

# Run a single file
nextflow main.nf --input 'data/1kgp/1kg_example_data.vcf.gz'

# Run a multiple files (using *)
nextflow main.nf --input 'data/1kgp/1kg_example_data*.vcf.gz'

# Check output
zcat out/1kg_example_data.vcf.map.gz | head | column -t
```

The output looks like this:
```
CHR_GRCh38  POS_GRCh38  CHR_GRCh37  POS_GRCh37  RSID_dbsnp151  REF  ALT
10          100157763   NA          NA          NA             NA   NA
10          101966771   NA          NA          NA             NA   NA
10          102814179   10          104573936   rs284858       T    C
10          104355789   NA          NA          NA             NA   NA
10          10574522    10          10616485    rs2025468      T    C
10          105905360   NA          NA          NA             NA   NA
10          106322887   NA          NA          NA             NA   NA
10          106371703   10          108131461   rs1409409      C    A
10          106524737   NA          NA          NA             NA   NA

```


