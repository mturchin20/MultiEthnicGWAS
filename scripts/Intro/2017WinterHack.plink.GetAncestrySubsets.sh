#!/bin/sh

ancestry="$1"
ancestry2="$2"
keep="$3"
chr="$4"

plink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr${chr}_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr${chr}_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --make-bed --keep $keep --out /users/mturchin/data/ukbiobank_jun17/2017WinterHack/$ancestry/ukb_chr${chr}_v2.${ancestry2} --noweb


