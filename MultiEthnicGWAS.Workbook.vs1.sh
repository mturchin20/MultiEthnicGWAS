#!/bin/sh

###20171108 -- MultiEthnicGWAS

#20171227
#TOC

 - 20171108: PCAEffects


#20171227
#Conda environment setup/details/etc
#See `/users/mturchin/RamachandranLab.CCV_General.Workbook.vs1.sh` for initial setup 

module load conda
conda config --add channels r
conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels bioconda
conda create -n MultiEthnicGWAS
source activate MultiEthnicGWAS
conda install R
#conda install python #already installed as part of base package I guess
conda install perl
conda install java
conda install plink
conda install bedtools
conda install vcftools
conda install bcftools
conda install bwa
conda install samtools
conda install picard
conda install gatk
conda install imagemagick
conda install gnuplot
conda install eigensoft
conda install r-base
conda install r-devtools
conda install r-knitr
conda install r-testthat
conda install r-cairo
conda install r-ashr
#20180311
#conda install flashpca -- failed
conda install eigen
#conda install spectra -- installed a Python package called spectra, not what was intended
conda install boost
#conda install libgomp -- failed
conda install gcc
#20180315
conda install r-essentials
conda install -c anaconda fonts-anaconda
conda install -c bioconda r-extrafont
#NOTE -- needed to run `conda update --all` to correct the 'missing/boxed text' issue with the conda R verion's image plotting

#20171117
#Dealing with sockets/missing screen issue

#From https://superuser.com/questions/58525/how-do-i-reconnect-to-a-lost-screen-detached-missing-socket

# ps aux | grep mturchin
# kill -CHLD 16830 

#20171128 NOTE -- might be helpful here, shows the use of `autodetach on` at the end from this person's defaults, which I was not originally including in my `.screenrc` file, `https://remysharp.com/2015/04/27/screen`
#20171227 NOTE -- the end result of this, which was troubleshooted by the IT department (via e-mail correspondence), was that there are two login nodes, 001 and 002, and if I setup screens on on one they'll appear as `dead` when logged onto the other login node; the solution then is to ssh into the appropriate login node if I'm randomly logged into the wrong one initially (and therefore in general work off of one login in node in particular from here on out).


##20171108 -- PCAEffects

#20171128 -- git webpage TOC main .Rmd file setup here

#cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/MultiEthnicGWAS.Workbook.vs1.sh | perl -F" " -lane 'if ($. == 1) { $flag1 = 0; } my $line1 = join(" ", @F); if ($line1 =~ m/^-->.*/) { $flag1 = 0; close $fh1; } if ($flag1 == 1) { print $fh1 join(" ", @F); } if ($line1 =~ m/^<!-- (.*Rmd).*/) { $flag1 = 1; $file1 = "/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/website/" . $1; open($fh1, ">", $file1) }'
cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/MultiEthnicGWAS.Workbook.vs1.sh | sed 's/ /,/g' | perl -F, -lane 'if ($. == 1) { $flag1 = 0; } my $line1 = join(" ", @F); if ($line1 =~ m/^-->.*/) { $flag1 = 0; close $fh1; } if ($flag1 == 1) { print $fh1 join(" ", @F); } if ($line1 =~ m/^<!-- (.*Rmd).*/) { $flag1 = 1; $file1 = "/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/website/" . $1; open($fh1, ">", $file1) }'

<!-- index.Rmd
---
title: "Home"
output:
  html_document:
    toc: false
---

Homepage for the Ramachandran Lab project `MultiEthnic GWAS`.

* [Example 1][example1]
* [Example 2][example2]

Github [repo][gitrepo1] page

[example1]: https://mturchin20.github.io/MultiEthnicGWAS/Example1.html 
[example2]: https://mturchin20.github.io/MultiEthnicGWAS/Example2.html 
[gitrepo1]: https://github.com/mturchin20/MultiEthnicGWAS

-->

#beginning Work

#/users/mturchin/data/ukbiobank , /users/mturchin/data/ukbiobank_jun17/mturchin

#mkdir /users/mturchin/LabMisc/RamachandranLab/IntroProjs
#mkdir /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS
#mkdir /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/PCAEffects
mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS
#mv /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/* /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/.; rm -r /users/mturchin/LabMisc/RamachandranLab/IntroProjs/ 

mkdir /users/mturchin/data/ukbiobank/mturchin

# interact -t 72:00:00 -m 8g
# (from MacBook Air) jupyter notebook /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/20171108_SS_Pipeline_Version_2.ipynb

##./gconv 
./gconv chrom21.cal mturchin/tempMisc/chrom21.basic.cal basic
#chrom18+ missing from *.int and *.con filetypes for some reason
./gconv chrom17.int mturchin/tempMisc/chrom17.basic.int basic
./gconv chrom17.con mturchin/tempMisc/chrom17.basic.con basic

#Retrieved from http://biobank.ctsu.ox.ac.uk/crystal/list.cgi and note the inclusion of `\` in front of each `&` in the URLs (manually did this after copy/pasting each URL)
#note -- don't actually need to include the `\` in front of the `&s` like I need to do from the command-line; interestingly enough including the `\s` produces the issue I was trying to avoid from the get-go, so kind of a reverse behavior going on here
urls1="http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=11 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=21 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=22 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=31 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=41 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=51 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=61 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=101" 

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.FieldCategories.Field_Name.vs.txt; for i in $urls1; do echo $i; GET $i | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*.a class="basic" href="field.cgi\?id=(\d+)"..*.a class="subtle" href="field.cgi\?id=\d+".(.*).\/a..\/td..*/) { print $1, "\t", $2 ; }' >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.FieldCategories.Field_Name.vs.txt; done

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt; for i in `cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.FieldCategories.Field_Name.vs.txt | perl -F"\t" -lane 'chomp(@F); print join(";", @F);' | sed 's/ /_/g'`; do 
#rm -f /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt; for i in `cat /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/UKBioBank.HTMLScraping.FieldCategories.Field_Name.vs.txt | sed 's/\t/;/g' | sed 's/\s/_/g'`; do 
#	echo $i; done
	Field1=`echo $i | perl -F\; -ane 'print $F[0];'`
	Name1=`echo $i | perl -F\; -ane 'print $F[1];'`
	
#	echo $i $Field1 $Name1; 
#	echo $Field1 $Name1; 

	GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=$Field1 | perl -slane 'my $line = join(" ", @F); if ($line =~ m/.* (\d+,\d+) participants.*/) { print $Field2, "\t", $Name2, "\t", $1; }' -- -Field2=$Field1 -Name2=$Name1 | sed 's/,//g' >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt;
done

cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | awk '{ print $3 }' | R -q -e "Data1 <- read.table(file('stdin'), header=F); png(\"/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/nana.png\", height=650, width=650, res=150); hist(Data1[,1], main=\"UKBioBank Number of \nParticipants per Phenotype\", xlab=\"Number of Participants\", breaks=50); dev.off();"
cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | awk '{ print $3 }' | R -q -e "Data1 <- read.table(file('stdin'), header=F); table(cut(Data1[,1], c(0,100000,200000,300000,400000,500000,600000)));"

#Getting .Rmd/.html/git directory stuff worked out by copying some base content from workflowr (https://github.com/jdblischak/workflowr) that I have stored in a previously temp workflowr test run at https://github.com/mturchin20/misc 
#cd /users/mturchin/LabMisc/RamachandranLab/
#clone https://github.com/mturchin20/misc

mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/docs
mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/website

cp -rp /users/mturchin/LabMisc/RamachandranLab/misc/docs/site_libs/* /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/docs/site_libs/.
cp -rp /users/mturchin/LabMisc/RamachandranLab/misc/analysis/* /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/website/.

#some helpful comments on Makefile misc -- https://stackoverflow.com/questions/3220277/what-do-the-makefile-symbols-and-mean, https://stackoverflow.com/questions/18136918/how-to-get-current-relative-directory-of-your-makefile, https://stackoverflow.com/questions/3707517/make-file-echo-displaying-path-string, https://www.gnu.org/software/make/manual/html_node/File-Name-Functions.html, https://www.gnu.org/software/make/manual/html_node/Text-Functions.html

#20171128 NOTE -- copy and pasted the correct `<img src =....` lines from files such as `https://github.com/mturchin20/misc/blob/master/docs/index.html` into `/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/docs/20171127.CorrectHTML.html` and then coming up with the `head`, `awk if (NR >...`, and `cat tmp1 CorrectHTML tmp2` commands found in the `Makefile` now  
#20171128 NOTE -- using perl in makefiles necessitates double `$`s, via `https://stackoverflow.com/questions/18083421/how-do-i-run-perl-command-from-a-makefile`

#some helpful comments from here re: knitr related commands https://stackoverflow.com/questions/10646665/how-to-convert-r-markdown-to-html-i-e-what-does-knit-html-do-in-rstudio-0-9
#R -e "library(\"knitr\"); knitr::knit2html(\"Example.Rmd\");"

#cat MainScript.IntroProjs.MultiEthnGWAS.vs1.sh | 
#cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/MultiEthnicGWAS.Workbook.vs1.sh | perl -lane 'if ($. == 1) { $flag1 = 0; } my $line1 = join(" ", @F); if ($line1 =~ m/^-->.*/) { $flag1 = 0; close $fh1; } if ($flag1 == 1) { print $fh1 join("\t", @F); } if ($line1 =~ m/^<!-- (.*Rmd).*/) { $flag1 = 1; $file1 = "/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/website/" . $1; open($fh1, ">", $file1) }'

<!-- Example1.Rmd
---
title: "Example 1"
output:
  html_document:
    toc: false
---

# Would
## You
### Look
#### At
#### That

-->

<!-- Example2.Rmd

# Let's
## Go
### Again
#### Round
#### Two

-->

mkdir /users/mturchin/data/ukbiobank_jun17/mturchin

ln -s /users/mturchin/data/ukbiobank/ukb9200.csv /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv 
ln -s /users/mturchin/data/ukbiobank/ukb11108.csv /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv

#Leftout fields being recollected
join -v 1 <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1) > /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.vs1.txt

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt; for i in `cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.vs1.txt`; do
	Field1=`echo $i | perl -F\; -ane 'print $F[0];'`

#	<tr><td>Description:</td><td>Average Y chromosome intensities for determining sex</td></tr>

	GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=$Field1 | perl -slane 'my $line = join(" ", @F); if ($line =~ m/.*Description:<\/td><td>(.*)<\/td><\/tr>/) { $description = $1; $description =~ tr/ /_/; } if ($line =~ m/.* (\d+) participants.*/) { $participants = $1; } if ($line =~ m/.* (\d+,\d+) participants.*/) { $participants = $1; } if (eof()) { print $Field2, "\t", $description, "\t", $participants; }' -- -Field2=$Field1 | sed 's/,//g' >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt;
done

cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1)) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | perl -lane 'if ($#F == 2) { print join("\t", @F); }' ) > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.Field_Name_Participants.vs1.txt

join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1) > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.Field_Name_Participants.vs1.txt

cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.Field_Name_Participants.vs1.txt /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.Field_Name_Participants.vs1.txt | sort -rg -k 3,3 | awk '{ print $3 }' | R -q -e "Data1 <- read.table(file('stdin'), header=F); table(cut(Data1[,1], c(0,100000,200000,300000,400000,500000,600000))); png(\"/users/mturchin/data/ukbiobank_jun17/mturchin/ukbFiles.Participants.hist.vs1.png\", height=650, width=650, res=150); hist(Data1[,1], main=\"ukb 9200 & 11108 Num. of \n Participants per Phenotype\", xlab=\"Num. of Participants\", breaks=50); dev.off();"

plink --bfile /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr21_v2 --recode --out /users/mturchin/data/ukbiobank_jun17/mturchin/ukb_snp_chr21_v2 --noweb

#20171218

##cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(21000|21001|21003|22000|22001|22006|22007|22008|22009|22011|22012|22013|31|34|48|49|50|)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt
##cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(21000\-|21001\-|21003\-|22000\-|22001\-|22006\-|22007\-|22008\-|22009\-|22011\-|22012\-|22013\-|31\-|34\-|48\-|49\-|50\-)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' | sed 's/"//g' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt
##cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(eid|"21000\-|"21001\-|"21003\-|"22000\-|"22001\-|"22006\-|"22007\-|"22008\-|"22009\-|"22011\-|"22012\-|"22013\-|"31\-|"34\-|"48\-|"49\-|"50\-)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' | sed 's/"//g' | sed 's/21000-/Ethnic_background-/g' | sed 's/21001-/Body_mass_index_(BMI)-/g' | sed 's/21003-/Age_when_attended_assessment_centre-/g' | sed 's/22000-/Genotype_measurement_batch-/g' | sed 's/22001-/Genetic_sex-/g' | sed 's/22006-/Genetic_ethnic_grouping-/g' | sed 's/22007-/Genotype_measurement_plate-/g' | sed 's/22008-/Genotype_measurement_well-/g' | sed 's/22009-/Genetic_principal_components-/g' | sed 's/22011-/Genetic_relatedness_pairing-/g' | sed 's/22012-/Genetic_relatedness_factor-/g' | sed 's/22013-/Genetic_relatedness_IBS0-/g' | sed 's/31-/Sex-/g' | sed 's/34-/Year_of_birth-/g' | sed 's/48-/Waist_circumference-/g' | sed 's/49-/Hip_circumference-/g' | sed 's/50-/Standing_height-/g' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(eid|"21000\-|"21001\-|"21003\-|"22000\-|"22001\-|"22006\-|"22007\-|"22008\-|"22009\-|"22011\-|"22012\-|"22013\-|"31\-|"34\-|"48\-|"49\-|"50\-)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' | sed 's/21000-/Ethnic_background-/g' | sed 's/21001-/Body_mass_index_(BMI)-/g' | sed 's/21003-/Age_when_attended_assessment_centre-/g' | sed 's/22000-/Genotype_measurement_batch-/g' | sed 's/22001-/Genetic_sex-/g' | sed 's/22006-/Genetic_ethnic_grouping-/g' | sed 's/22007-/Genotype_measurement_plate-/g' | sed 's/22008-/Genotype_measurement_well-/g' | sed 's/22009-/Genetic_principal_components-/g' | sed 's/22011-/Genetic_relatedness_pairing-/g' | sed 's/22012-/Genetic_relatedness_factor-/g' | sed 's/22013-/Genetic_relatedness_IBS0-/g' | sed 's/31-/Sex-/g' | sed 's/34-/Year_of_birth-/g' | sed 's/48-/Waist_circumference-/g' | sed 's/49-/Hip_circumference-/g' | sed 's/50-/Standing_height-/g' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt

#cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(^21000|^21001|^21003|^22000|^22001|^22006|^22007|^22008|^22009|^22011|^22012|^22013|^31|^34|^48|^49|^50)/) { push(@colsUse, $i); } } } print join(",", @colsUse);'
#cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(21000\-|21001\-|21003\-|22000\-|22001\-|22006\-|22007\-|22008\-|22009\-|22011\-|22012\-|22013\-|31\-|34\-|48\-|49\-|50\-)/) { push(@colsUse, $i); } } } print join(",", @colsUse), "\t", join(",", @F[@colsUse]);'

for i in {0..55}; do
	val1=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | head -n 1 | perl -F, -slane 'print $F[$iBash];' -- -iBash=$i`
	val2=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -slane 'if ($F[$iBash] !~ m/""/) { print $F[$iBash]; }' -- -iBash=$i | wc | awk '{ print $1 }'`

	echo $i $val1 $val2

done

##cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = "2018" - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | sed 's/"//g' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoies.txt 
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $year1 = $F[2]; $year1 =~ tr/"//d; print $F[0], ",", $F[1], ",", $F[12], ",", $F[2], ",", $F[18], ",", 2018 - $year1, ",", $F[9], ",", $F[15], ",", $F[3], ",", $F[6], ",", $F[21];' | sed 's/"//g' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt 

cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt | perl -F, -ane 'if ($F[2]) { $F[2] =~ s/^1$/White/g; $F[2] =~ s/^1001$/British/g; $F[2] =~ s/^2001$/White_and_Black_Caribbean/g; $F[2] =~ s/^3001$/Indian/g; $F[2] =~ s/^4001$/Caribbean/g; $F[2] =~ s/^2$/Mixed/g; $F[2] =~ s/^1002$/Irish/g; $F[2] =~ s/^2002$/White_and_Black_African/g; $F[2] =~ s/^3002$/Pakistani/g; $F[2] =~ s/^4002$/African/g; $F[2] =~ s/^3$/Asian_or_Asian_British/g; $F[2] =~ s/^1003$/Any_other_white_background/g; $F[2] =~ s/^2003$/White_and_Asian/g; $F[2] =~ s/^3003$/Bangladeshi/g; $F[2] =~ s/^4003$/Any_other_Black_background/g; $F[2] =~ s/^4$/Black_or_Black_British/g; $F[2] =~ s/^2004$/Any_other_mixed_background/g; $F[2] =~ s/^3004$/Any_other_Asian_background/g; $F[2] =~ s/^5$/Chinese/g; $F[2] =~ s/^6$/Other_ethnic_group/g; $F[2] =~ s/^-1$/Do_not_know/g; $F[2] =~ s/^-3$/Prefer_not_to_answer/g; print $F[0], "\t", $F[0], "\t", $F[1], "\t", $F[2], "\t", $F[4], "\n"; }' | grep -v eid | cat <(echo -e "FID\tIID\tSEX\tANCESTRY\tAGE") - > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt 

cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt | perl -F, -ane 'print $F[0], "\t", $F[0], "\t", $F[6], "\t", $F[7], "\t", $F[8], "\t", $F[9], "\n"; ' | grep -v eid | cat <(echo -e "FID\tIID\tHeight\tBMI\tWaist\tHip") - > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.txt
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.txt | perl -lane 'if ($#F == 5) { print join("\t", @F); }' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt

cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | awk '{ print $4 }' | sort | uniq -c | awk '{ print $2 }' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.Ancestries.txt

for i in `cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.Ancestries.txt`; do
	echo $i;
	cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | grep -w $i | awk '{ print $1 "\t" $2 }' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.${i}.FIDIIDs 

done

cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 4000 > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs

#/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.${ANCESTRY}.FIDIIDs
#/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs
#/users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam
#/users/mturchin/data/ukbiobank_jun17/calls/.
#/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.${ANCESTRY}.FIDIIDs
#/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt
#/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt

mkdir /users/mturchin/data/ukbiobank_jun17/2017WinterHack
mkdir /users/mturchin/data/ukbiobank_jun17/2017WinterHack/British
mkdir /users/mturchin/data/ukbiobank_jun17/2017WinterHack/African
mkdir /users/mturchin/data/ukbiobank_jun17/2017WinterHack/Caribbean

plink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr21_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr21_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --recode --keep /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs --out /users/mturchin/data/ukbiobank_jun17/2017WinterHack/ukb_chr21_v2.British.Ran4000
plink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr22_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr22_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --make-bed --keep /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs --out /users/mturchin/data/ukbiobank_jun17/2017WinterHack/ukb_chr22_v2.British.Ran4000

##plink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr21_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr21_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --covar /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt --covar-name SEX,AGE --keep /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs --linear --maf .01 --out /users/mturchin/data/ukbiobank_jun17/2017WinterHack/ukb_chr21_v2.British.Ran4000 
##plink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr1_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr1_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --keep /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs --assoc --out /users/mturchin/data/ukbiobank_jun17/2017WinterHack/British/ukb_chr1_v2.British.Ran4000 
plink --bfile /users/mturchin/data/ukbiobank_jun17/2017WinterHack/British/ukb_chr21_v2.British.Ran4000 --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --linear --covar /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt --covar-name AGE,SEX --out /users/mturchin/data/ukbiobank_jun17/2017WinterHack/British/ukb_chr21_v2.British.Ran4000.MikeOut

#NOTE -- changed/played around with a few permissions to help get other members of the retreat group access to some of the files that were created during this process; first used chmod 777 just to brute force fix things, then changed to be more specific (eg give just group users permission but not necessarily just anyone), and then afterwards cleaned things up be removing write-access to group users as well (some info for said steps from: https://en.wikipedia.org/wiki/Chmod)

#20171228 NOTE -- think I'm going to ditch this idea and just do the normal 'create file separately and edit/do things/etc in the file itself'; by uploading the file to the github space it should be made accessible for later downstream linking and reports/summaries/logs/etc...
#Saved the below code into a file via ':251,259w! /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.vs2.sh'; moved to the 'vs2' version after the retreat 
#!/bin/sh

ancestry1="$1"
ancestry2="$2"
keep="$3"
chr="$4"

plink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr${chr}_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr${chr}_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --make-bed --keep $keep --out /users/mturchin/data/ukbiobank_jun17/2017WinterHack/$ancestry1/ukb_chr${chr}_v2.${ancestry2} --noweb

##srun -e /users/mturchin/data/ukbiobank_jun17/2017WinterHack/error -o /users/mturchin/data/ukbiobank_jun17/2017WinterHack/out bash /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.sh British /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs 21
sbatch -e /users/mturchin/data/ukbiobank_jun17/2017WinterHack/British/ukb_chr${i}_v2.British.Ran4000.slurm.error /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.sh British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs 21

#Ran below for 'British.Ran4000', 'African', and 'Caribbean'; also ran the below during the retreat itself, and then moved to the next version of the for loop that includes the outer, per-ancestry for loop as well
#for i in {X..X}; do
#	
#	echo $i	
#	sbatch -t 1:00:00 --mem 8g -e /users/mturchin/data/ukbiobank_jun17/2017WinterHack/Caribbean/ukb_chr${i}_v2.Caribbean.slurm.error /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.sh Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.Caribbean.FIDIIDs $i
#
#done

#post-retreat extra work to clean things up/actually partially use/follow-up; just continuing on here with things I think

mkdir /users/mturchin/data/ukbiobank_jun17/subsets/
mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/scripts
mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/scripts/Intro

#Put in `/users/mturchin/.bashrc`, from sources such as `http://www.accre.vanderbilt.edu/?page_id=361`, etc...
##`alias sacct='sacct --format JobID,JobName,Partition,User,Account,Submit,CPUTime,AllocCPUS,State,ExitCode'`
#`alias sacct='sacct --format JobID,JobName,Partition,User,Account,Submit,CPUTime,AllocCPUS,State,ExitCode,Comment%50'`
#`alias squeue='squeue --Format=jobid,partition,name,username,statecompact,starttime,timeused,numnodes,nodelist'`
#sacct --starttime 2014-07-01 #From https://ubccr.freshdesk.com/support/solutions/articles/5000686909-how-to-retrieve-job-history-and-accounting

cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 10000 > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran10000.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 100000 > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran100000.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 200000 > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran200000.FIDIIDs

#val1hg19=`echo "HaemgenRBC2016;HaemgenRBC2016;8.31e-9;RBC,MCV,PCV,MCH,Hb,MCHC GEFOS2015;GEFOS2015;1.2e-8;FA,FN,LS SSGAC2016;SSGAC2016;5e-8;NEB_Pooled,AFB_Pooled EMERGE22015;EMERGE22015;7.1e-9;ICV,Accumbens,Amygdala,Caudate,Hippocampus,Pallidum,Putamen,Thalamus"`;
#                
#for i in `cat <(echo $val1hg19 | perl -lane 'print join("\n", @F);')`; do
#        Dir1=`echo $i | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
#        Dir2=`echo $i | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
#        pVal1=`echo $i | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[2];'`

#UKBioBankPops=`echo "African;African Any_other_Asian_background;Any_other_Asian_background Any_other_mixed_background;Any_other_mixed_background Any_other_white_background;Any_other_white_background British;British British;British.Ran4000 Caribbean;Caribbean Chinese;Chinese Indian;Indian Irish;Irish Pakistani;Pakistani"`;
#UKBioBankPops=`echo "African;African Any_other_Asian_background;Any_other_Asian_background Any_other_mixed_background;Any_other_mixed_background Any_other_white_background;Any_other_white_background British;British 
British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 Caribbean;Caribbean Chinese;Chinese Indian;Indian Irish;Irish Pakistani;Pakistani"`;
#UKBioBankPops=`echo "British;British British;British.Ran100000 British;British.Ran200000"`; 
UKBioBankPops=`echo "African;African Any_other_white_background;Any_other_white_background British;British British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 Caribbean;Caribbean Indian;Indian Irish;Irish"`; 
UKBioBankPops=`echo "British;British.Ran4000"`;

#African;African
#Any_other_Asian_background;Any_other_Asian_background
#Any_other_Black_background;Any_other_Black_background
#Any_other_mixed_background;Any_other_mixed_background
#Any_other_white_background;Any_other_white_background
#Asian_or_Asian_British;Asian_or_Asian_British
#Bangladeshi;Bangladeshi
#Black_or_Black_British;Black_or_Black_British
#British;British
#British;British.Ran4000
#British;British.Ran10000
#British;British.Ran100000
#British;British.Ran200000
#Caribbean;Caribbean
#Chinese;Chinese
#Do_not_know;Do_not_know
#Indian;Indian
#Irish;Irish
#Mixed;Mixed
#Other_ethnic_group;Other_ethnic_group
#Pakistani;Pakistani
#Prefer_not_to_answer;Prefer_not_to_answer
#White;White
#White_and_Asian;White_and_Asian
#White_and_Black_African;White_and_Black_African
#White_and_Black_Caribbean;White_and_Black_Caribbean

#cp -p /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.sh /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/scripts/Intro/2017WinterHack.plink.GetAncestrySubsets.sh
#cp -p /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.vs2.sh /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/scripts/Intro/2017WinterHack.plink.GetAncestrySubsets.vs2.sh

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	for chr in {1..22} X; do
	
		if [ ! -d /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1 ]; then
			mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1	
		fi
		if [ ! -d /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2 ]; then
			mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2
		fi
	
		echo $ancestry1 $ancestry2 $chr	
		sbatch -t 1:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${chr}_v2.$ancestry2.slurm.%j.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${chr}_v2.$ancestry2.slurm.%j.error /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/scripts/Intro/2017WinterHack.plink.GetAncestrySubsets.vs2.sh $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.$ancestry2.FIDIIDs $chr
	
	done
done

#From https://stackoverflow.com/questions/2920301/clear-a-file-without-changing-its-timestamp
##!/bin/sh
#TMPFILE=`mktemp`
##save the timestamp
#touch -r file-name $TMPFILE
#> file_name
##restore the timestamp after truncation
#touch -r $TMPFILE file-name
#rm $TMPFILE

for j in `echo "African Caribbean British"`; do
	for i in `ls -lrt /users/mturchin/data/ukbiobank_jun17/2017WinterHack/$j/. | awk '{ print $9 }' | grep -E 'bed|bim|fam'`; do
		echo /users/mturchin/data/ukbiobank_jun17/2017WinterHack/$j/$i
		
		TMPFILE=`mktemp`
		touch -r /users/mturchin/data/ukbiobank_jun17/2017WinterHack/$j/$i $TMPFILE
		cat /dev/null > /users/mturchin/data/ukbiobank_jun17/2017WinterHack/$j/$i
		touch -r $TMPFILE /users/mturchin/data/ukbiobank_jun17/2017WinterHack/$j/$i
		rm $TMPFILE
	done
done

for 

#for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
#	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
#	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
#
#	echo $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.MergeList.txt
#
#	cat /dev/null > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.MergeList.txt
#	
#	for chr in {2..22} X; do
#		echo "/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${chr}_v2.${ancestry2}.bed /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${chr}_v2.${ancestry2}.bim /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${chr}_v2.${ancestry2}.fam" >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.MergeList.txt
#	done
#
#done
#
#for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
#	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
#	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
#
#	echo $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.MergeList.txt
#
#	sbatch -t 1:00:00 --mem 100g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.slurm.%j.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.slurm.%j.error --comment "$ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr1_v2.${ancestry2} --merge-list /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.MergeList.txt --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}") 
#
##	rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.Height.bed /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.Height.bim /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.Height.fam
#
#done

#Below completed with help from `http://zzz.bwh.harvard.edu/plink/dataman.shtml#mergelist`, `https://stackoverflow.com/questions/6907531/generating-a-bash-script-with-echo-problem-with-shebang-line`, & `https://stackoverflow.com/questions/13799789/expansion-of-variable-inside-single-quotes-in-a-command-in-bash` 
#Note -- did not end up going with `--merge-list` route since it, apparently, creates the merged PLINK files automatically, and I couldn't immediately find an option to by-pass this; one possibly solution would have been to delete these files at the end of the script, but I also realized that running the regressions (and possibly more/later analyses) would take less time if I keep things in a parallelized, per-chromosome state
#20180104 NOTE -- do not use `SEX` as a covariate, the UKBioBank PLINK files (as witnessed in the human-readable .ped/.map formats) already contain this information; additionally, PLINK expects the coding to be 1/2 and the UKBioBank sex coding (currently) is as 1/0, which may cause additional problems (or treat it as some binary covariate called `SEX` but having nothing to do with the actual designation). See results in scratch section showing covariate file lining up with .ped sex column (aside from the 1/2 vs. 1/0 coding issue). 
	#From https://www.cog-genomics.org/plink2/formats: "This page describes specialized PLINK input and output file formats which are identifiable by file extension. ..... isn't in dataset); Within-family ID of mother ('0' if mother isn't in dataset); Sex code ('1' = male, '2' = female, '0' = unknown); Phenotype value ('1' = control, '2' = case, '-9'/'0'/non-numeric = missing data if case/control)."; from http://biobank.ctsu.ox.ac.uk/crystal/coding.cgi?id=9: "Coding	Meaning 0	Female 1	Male"
	#From http://zzz.bwh.harvard.edu/plink/faq.shtml#faq9:
~~~
		#How does PLINK handle the X chromosome in association tests?
		#By default, in the linear and logistic (--linear, --logistic) models, for alleles A and B, males are coded
		#     A   ->   0
		#     B   ->   1
		#and females are coded
		#     AA  ->   0
		#     AB  ->   1
		#     BB  ->   2
		#and additionally sex (0=male,1=female) is also automatically included as a covariate. It is therefore important not to include sex as a separate covariate in a covariate file ever, but rather to use the special --sex command that tells PLINK to add sex as coded in the PED/FAM file as the covariate (in this way, it is not double entered for X chromosome markers). If the sample is all female or all male, PLINK will know not to add sex as an additional covariate for X chromosome markers.
		#The basic association tests that are allelic (--assoc, --mh, etc) do not need any special changes for X chromosome markers: the above only applies to the linear and logistic models where the individual, not the allele, is the unit of analysis. Similarly, the TDT remains unchanged. For the --model test and Hardy-Weinberg calculations, male X chromosome genotypes are excluded.
		#Not all analyses currently handle X chromosomes markers (for example, LD pruning, epistasis, IBS calculations) but support will be added in future.
~~~

#for pheno1 in `echo "Height BMI Waist Hip"`; do
for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

		for i in {1..22} X; do
			echo $pheno1 $ancestry1 $ancestry2 $i

			sbatch -t 1:00:00 --mem 20g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.linear.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.linear.slurm.error --comment "$pheno1 $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2} --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name $pheno1 --linear --sex --covar /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt --covar-name AGE --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}")

		done
	done	
done

#		sbatch -t 1:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.linear.slurm.%j.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.linear.slurm.%j.error <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr1_v2.${ancestry2} --merge-list /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.MergeList.txt --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name $pheno1 --linear --covar /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt --covar-name AGE,SEX --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}")

#for pheno1 in `echo "Height"`; do
#	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
#		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
#		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
#		echo $pheno1 $ancestry1 $ancestry2
#
#		for i in {1..22} X; do
#			if [ ! -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.assoc.linear ]; then 
#				echo -e "\t" $i
#			fi
#		done
#	done	
#done

#20180104 NOTE -- for large `British` pops, I reran the clumping code with a more strict set of parameters, just since you would, more naturally for such large sample sizes, use such parameters for them (vs. parameters tuned on ~4k pop sizes); for largest sizes it's possible a p1 of 5-8 is even too liberal still
#UKBioBankPops=`echo "British;British British;British.Ran100000 British;British.Ran200000"`;

for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

		for i in {1..22} X; do
			echo $pheno1 $ancestry1 $ancestry2 $i

			cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.assoc.linear | grep -E 'NMISS|ADD' > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear
			sbatch -t 1:00:00 --mem 20g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.linear.clump.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.linear.clump.slurm.error --comment "clumping $pheno1 $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2} --clump /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear --clump-p1 .0001 --clump-p2 0.01 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear")

		done
	done	
done

#			sbatch -t 1:00:00 --mem 20g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.strict.linear.clump.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.strict.linear.clump.slurm.error --comment "clumping $pheno1 $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2} --clump /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear --clump-p1 5e-8 --clump-p2 0.0001 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.strict.assoc.linear")
#			plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2} --clump /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear --clump-p1 .0001 --clump-p2 0.01 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear
#cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background.Height.assoc.linear | grep -E 'NMISS|ADD' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background.Height.ADD.assoc.linear
#plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background --clump /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background.Height.ADD.assoc.linear --clump-p1 .0001 --clump-p2 0.01 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background.Height.ADD.assoc.linear
#plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African --clump /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.ADD.assoc.linear --clump-p1 .0001 --clump-p2 0.01 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.ADD.assoc.linear

for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped

		rm -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.gz
		rm -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.gz 
		for i in {1..22} X; do

			cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear | perl -lane 'if ($#F == 8) { print join("\t", @F); }' >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear 
			cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped 

		done
	
		cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear | sort -g -k 1,1 -k 4,4 | uniq | grep -v BETA | grep -v ^$ | cat <(echo "  CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P ") - > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.temp1
		mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.temp1 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear
		cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped | sort -g -k 1,1 -k 4,4 | uniq | grep -v NSIG | grep -v ^$ | cat <(echo " CHR    F           SNP         BP        P    TOTAL   NSIG    S05    S01   S001  S0001    SP2") - > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.temp1
		mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.temp1 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
		gzip /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear
		gzip /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped

	done	
done

UKBioBankPops=`echo "African;African Any_other_white_background;Any_other_white_background British;British British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 Caribbean;Caribbean Indian;Indian Irish;Irish"`;

cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped | wc
#cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.ADD.assoc.linear.clumped | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
#join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc

cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1))); png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear.hist.png\", height=1250, width=1250, res=300); hist(Data1[,1]); dev.off()"
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1))); png(\"/users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear.hist.png\", height=1250, width=1250, res=300); hist(Data1[,1]); dev.off()"
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));" 
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr6_v2.British.Ran4000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chr6_v2.British.Ran10000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chr6_v2.British.Ran100000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chr6_v2.British.Ran200000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));" 
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr6_v2.British.Ran4000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chr6_v2.British.Ran10000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chr6_v2.British.Ran100000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chr6_v2.British.Ran200000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"

mkdir /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.phenoColEdit.pedind | awk '{ print $1 "\t" $2 }' | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 4000 > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.phenoColEdit.Ran4kIndv.pedind
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background --keep /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.phenoColEdit.Ran4kIndv.pedind --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000 --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --linear --sex --covar /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt --covar-name AGE --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height 
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.bim | awk '{ if ($1 < 23) { print $0 } } ' | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 20000 > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran20k.bim
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran20k.bim | awk '{ print $2 }' >  /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran20k.bim.rsIDs
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000 --extract /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran20k.bim.rsIDs --recode --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran20k 
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran20k.ped | perl -lane '$F[5] = "1"; print join("\t", @F);' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran20k.phenoColEdit.ped
rm /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran20k.ped
ln -s /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran20k.bim /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.pedsnp
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran20k.phenoColEdit.ped | perl -lane 'print join("\t", @F[0..5]);' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.phenoColEdit.pedind
cp -p /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.parfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.parfile
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.bim | awk '{ if ($1 < 23) { print $0 } } ' | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 100000 > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran100k.bim
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran100k.bim | awk '{ print $2 }' >  /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran100k.bim.rsIDs
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000 --extract /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran100k.bim.rsIDs --recode --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran100k 
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran100k.ped | perl -lane '$F[5] = "1"; print join("\t", @F);' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran100k.phenoColEdit.ped
rm /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran100k.ped
ln -s /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran100k.bim /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.pedsnp
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran100k.phenoColEdit.ped | perl -lane 'print join("\t", @F[0..5]);' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.phenoColEdit.pedind
cp -p /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.parfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran100k.smartpca.parfile

#Got info for smartpca and .parfile input from HIV project work -- just copy/pasted the original code/sources and based new line/code on that

plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr1_v2.Any_other_white_background --merge-list /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.MergeList.txt --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.bim | awk '{ if ($1 < 23) { print $0 } } ' | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 200000 > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.bim 
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.bim | awk '{ print $2 }' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.bim.rsIDs
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background --extract /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.bim.rsIDs --recode --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.ped | perl -lane '$F[5] = "1"; print join("\t", @F);' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.phenoColEdit.ped
rm /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.ped
ln -s /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.bim /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.pedsnp 
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.phenoColEdit.ped | perl -lane 'print join("\t", @F[0..5]);' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.phenoColEdit.pedind
#Made `/users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.parfile` from HIV example

smartpca -p /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.parfile
smartpca -p /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.parfile
smartpca -p /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran100k.smartpca.parfile

ploteig -i /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca -c 1:2 -p Control -x -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca.plot.1vs2.xtxt
ps2pdf /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca.plot.1vs2.ps /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca.plot.1vs2.pdf
ploteig -i /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca -c 3:4 -p Control -x -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca.plot.3vs4.xtxt
ps2pdf /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca.plot.3vs4.ps /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca.plot.3vs4.pdf
ploteig -i /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca -c 1:2 -p Control -x -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca.plot.1vs2.xtxt
ps2pdf /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca.plot.1vs2.ps /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca.plot.1vs2.pdf
ploteig -i /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca -c 3:4 -p Control -x -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca.plot.3vs4.xtxt
ps2pdf /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca.plot.3vs4.ps /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca.plot.3vs4.pdf
ploteig -i /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca -c 1:2 -p Control -x -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca.plot.1vs2.xtxt
ps2pdf /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca.plot.1vs2.ps /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca.plot.1vs2.pdf
ploteig -i /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca -c 3:4 -p Control -x -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca.plot.3vs4.xtxt
ps2pdf /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca.plot.3vs4.ps /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca.plot.3vs4.pdf

#From MacBook Air
#mkdir /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran*.Results.pca.plot.*.pdf /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank/. 
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran*.Results.pca.plot.*.pdf /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank/.

join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | sed 's/:/ /g' | awk '{ print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 }' | sort -k 1,1) | cat <(echo -e "FID\tIID\tSEX\tANCESTRY\tAGE\tPC1\tPC2\tPC3\tPC4\tPC5\tPC6\tPC7\tPC8\tPC9\tPC10") - > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.wFullCovars.pca
join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca | sed 's/:/ /g' | awk '{ print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 }' | sort -k 1,1) | cat <(echo -e "FID\tIID\tSEX\tANCESTRY\tAGE\tPC1\tPC2\tPC3\tPC4\tPC5\tPC6\tPC7\tPC8\tPC9\tPC10") - > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.wFullCovars.pca

plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000 --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --linear sex --covar /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.wFullCovars.pca --covar-name AGE,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --linear sex --covar /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.wFullCovars.pca --covar-name AGE,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs

for i in {1..22} X; do
	
	echo $i
#	sbatch -t 1:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chr${i}_v2.Any_other_white_background.Ran4000.Height.w10PCs.linear.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chr${i}_v2.Any_other_white_background.Ran4000.Height.w10PCs.linear.slurm.error --comment "Height Any_other_white_background Any_other_white_background.Ran4000 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000 --chr $i --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --linear sex --covar /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.wFullCovars.pca --covar-name AGE,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chr${i}_v2.Any_other_white_background.Ran4000.Height.w10PCs")	
	sbatch -t 1:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr${i}_v2.Any_other_white_background.Height.w10PCs.linear.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr${i}_v2.Any_other_white_background.Height.w10PCs.linear.slurm.error --comment "Height Any_other_white_background Any_other_white_background $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background --chr $i --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --linear sex --covar /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.wFullCovars.pca --covar-name AGE,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr${i}_v2.Any_other_white_background.Height.w10PCs")	

done

#rm -f /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear
rm -f /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear
for i in {1..22} X; do

	echo $i
#	cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chr${i}_v2.Any_other_white_background.Ran4000.Height.w10PCs.assoc.linear | grep ADD >> /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear
	cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr${i}_v2.Any_other_white_background.Height.w10PCs.assoc.linear | grep ADD >> /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear

done 

cat <(echo " CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P") /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear.temp1
mv /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear.temp1 /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000 --clump /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear --clump-p1 .0001 --clump-p2 0.01 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear
cat <(echo " CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P") /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear.temp1
mv /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear.temp1 /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background --clump /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear --clump-p1 .0001 --clump-p2 0.01 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear

mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/
#From https://www.biostars.org/p/70795/
mkdir /users/mturchin/Software/UCSCGB
#cd /users/mturchin/Software/UCSCGB
#wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/fetchChromSizes
mkdir /users/mturchin/data2
mkdir /users/mturchin/data2/UCSCGB
##/users/mturchin/Software/UCSCGB/fetchChromSizes GRCh37 > /users/mturchin/data2/UCSCGB/GRCh37.chrom.sizes
/users/mturchin/Software/UCSCGB/fetchChromSizes hg19 > /users/mturchin/data2/UCSCGB/hg19.chrom.sizes
mkdir /users/mturchin/data2/GIANT
#cd /users/mturchin/data2/GIANT
#wget https://portals.broadinstitute.org/collaboration/giant/images/0/01/GIANT_HEIGHT_Wood_et_al_2014_publicrelease_HapMapCeuFreq.txt.gz https://portals.broadinstitute.org/collaboration/giant/images/1/15/SNP_gwas_mc_merge_nogc.tbl.uniq.gz https://portals.broadinstitute.org/collaboration/giant/images/e/eb/GIANT_2015_WHRadjBMI_COMBINED_EUR.txt.gz 
#gunzip *

#In R:
#library("ashr")
#Data1 <- read.table("/users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.gz", header=T)
#Data2 <- read.table("/users/mturchin/data2/GIANT/GIANT_HEIGHT_Wood_et_al_2014_publicrelease_HapMapCeuFreq.txt.gz", header=T)
#Data3 <- read.table("/users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.gz", header=T)
##Data3.Chr5 <- Data3[Data3$CHR==5,]
#Data3.Chr19 <- Data3[Data3$CHR==19,]
#Output3 <- ash(Data3.Chr19$BETA, abs(Data3.Chr19$BETA)/qnorm(Data3.Chr19$P/2, lower.tail=FALSE))
#png("nana2.png", height=1500, width=3000, res=300); par(mfrow=c(1,2)); plot(Output3$result$betahat, Output3$result$PosteriorMean); abline(0,1, col="RED"); plot(-log10(1/seq(1, length(sort(-log10(2*pnorm(abs(Output3$result$betahat)/Output3$result$sebetahat, lower.tail=FALSE)), decreasing=FALSE)))), sort(-log10(2*pnorm(abs(Output3$result$betahat)/Output3$result$sebetahat, lower.tail=FALSE)), decreasing=FALSE), col="BLUE"); points(-log10(1/seq(1, nrow(Data3.Chr19))), sort(-log10(2*pnorm(abs(Output3$result$PosteriorMean)/Output3$result$PosteriorSD, lower.tail=FALSE)), decreasing=FALSE), col="RED"); abline(0,1, col="BLACK"); dev.off();
#head(Data2)
#Output2 <- ash(Data2$b, Data2$SE)

for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.gz
		sbatch -t 24:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.ashr.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.ashr.slurm.error --comment "ashr $pheno1 $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.gz | R -q -e \"library(\\\"ashr\\\"); Data1 <- read.table(file('stdin'), header=TRUE); Results1 <- ash(Data1\\\$BETA, abs(Data1\\\$BETA)/qnorm(Data1\\\$P/2, lower.tail=FALSE)); write.table(Results1\\\$result, file=\\\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results\\\", quote=FALSE, row.names=FALSE);\"\ngzip -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results")
	done	
done

cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped | wc

cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed

#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.500kbPadding.bed
#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.500kbPadding.bed
#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.500kbPadding.bed
#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.500kbPadding.bed
#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.500kbPadding.bed
#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.500kbPadding.bed
#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.500kbPadding.bed
#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.500kbPadding.bed

bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.10kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.50kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.250kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.500kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.10kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.50kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.250kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.500kbPadding.bed

cat <(paste <(echo "Brit.Ran4k") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') ) \ 
<(paste <(echo "Brit.Ran10k") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') ) \
<(paste <(echo "Brit.Ran100k") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') ) \ 
<(paste <(echo "Brit.Ran200k") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') ) \ 
<(paste <(echo "African") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') ) \ 
<(paste <(echo "Caribbean") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') ) \ 
<(paste <(echo "Indian") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') ) \ 
<(paste <(echo "Irish") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') )  

paste <(echo "Afr_v_Caribbean") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') 

for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.AllPopComps 

		zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.gz | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.10kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.50kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.250kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.500kbPadding.bed

	done
done

#UKBioBankPops=`echo "African;African British;British British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 Caribbean;Caribbean Indian;Indian Irish;Irish"`; 
#UKBioBankPops=`echo "British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 African;African Caribbean;Caribbean Indian;Indian Irish;Irish"`;
UKBioBankPops=`echo "British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 British;British African;African Caribbean;Caribbean Indian;Indian Irish;Irish"`;
rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.clumped.AllPopComps
for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
#	rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.AllPopComps
	echo -e "$pheno1\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.clumped.AllPopComps
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.AllPopComps 

		paste <(echo $ancestry2) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.clumped.AllPopComps 

	done	

	echo -e "\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.clumped.AllPopComps

done

for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps 

		zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.gz | perl -lane 'if ($F[8] < 1e-4) { print join("\t", @F); }' | grep -v NA | awk '{ print "chr" $1 "\t" $3 "\t" $3 "\t" $2 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.10kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.50kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.250kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.500kbPadding.bed

	done
done

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps
for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	echo -e "$pheno1\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

#		if [ ! -d /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm ]; then
#			mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm
#		fi 
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps 
		paste <(echo "$ancestry2") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps 

	done	
	echo -e "\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps
done

#		sbatch -t 24:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.slurm.error --comment "bedIntersect $pheno1 $ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "paste <(echo \"$ancestry2\") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed | wc | awk '{ print \$1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.10kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.50kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.250kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.500kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') > /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps") 
#		sbatch -t 24:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.0kbPadding.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.0kbPadding.slurm.error --comment "0kb $pheno1 $ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }' > /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps.0kbPadding") 
#		sbatch -t 24:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.10kbPadding.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.10kbPadding.slurm.error --comment "10kb $pheno1 $ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.10kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }' > /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps.10kbPadding") 
#		sbatch -t 24:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.50kbPadding.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.50kbPadding.slurm.error --comment "50kb $pheno1 $ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.50kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') > /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps.50kbPadding")
#		sbatch -t 24:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.250kbPadding.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.250kbPadding.slurm.error --comment "250kb $pheno1 $ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.250kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') > /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps.250kbPadding")
#		sbatch -t 24:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.500kbPadding.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.500kbPadding.slurm.error --comment "500kb $pheno1 $ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.500kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') > /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps.500kbPadding")

#/users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.ashr.results.results.gz
for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.ashr.results.AllPopComps 

		paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.gz) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.gz)  | perl -lane 'print $F[0], "\t", $F[2], "\t", $F[1], "\t", $F[$#F-1], "\t", $F[$#F];' | R -q -e "Data1 <- read.table(file('stdin'), header=T); Data1 <- cbind(Data1, 2*pnorm(abs(Data1\$PosteriorMean) / Data1\$PosteriorSD, lower.tail=FALSE)); colnames(Data1) <- c(names(Data1)[-ncol(Data1)], \"pVal\"); write.table(Data1, quote=FALSE, row.names=FALSE);" | perl -lane 'if ($F[$#F] < 1e-4) { print join("\t", @F); }' | grep -v PosteriorSD | grep -v NA | grep -v ^\> | awk '{ print "chr" $1 "\t" $2 "\t" $2 "\t" $3 }' > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.10kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.50kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.250kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.500kbPadding.bed

	done
done

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.AllPopComps
for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	echo -e "$pheno1\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.AllPopComps
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.ashr.results.AllPopComps 
		paste <(echo "$ancestry2") 
		<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed | wc | awk '{ print $1 }') 
		<(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') 
		<(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') 
		<(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') 
		<(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') 
		<(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.AllPopComps 

	done	
	echo -e "\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.AllPopComps
done


#20180311

#From ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/, https://unix.stackexchange.com/questions/117988/wget-with-wildcards-in-http-downloads 

mkdir /users/mturchin/data/1000G
cd /users/mturchin/data/1000G
#wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/*txt 
wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL* 
#wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/README* 
#wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/*ALL* 
mkdir /users/mturchin/data/1000G/subsets
mkdir /users/mturchin/data/1000G/subsets/CEU
mkdir /users/mturchin/data/1000G/subsets/YRI
mkdir /users/mturchin/data/1000G/subsets/CHB
for i in `cat /users/mturchin/data/1000G/integrated_call_samples_v3.20130502.ALL.panel | awk '{ print $2 }' | sort | uniq`; do echo $i; cat /users/mturchin/data/1000G/integrated_call_samples_v3.20130502.ALL.panel | grep -w $i | awk '{ print $1 }' > /users/mturchin/data/1000G/subsets/integrated_call_samples_v3.20130502.ALL.panel.$i.IIDs; done
#for i in `echo "CEU YRI CHB"`; do
for i in `echo "GBR ESN JPT ACB ASW"`; do
	
	if [ ! -d /users/mturchin/data/1000G/subsets/$i/mturchin20 ]; then
		mkdir /users/mturchin/data/1000G/subsets/$i/mturchin20
	fi 
	
	for j in `echo {1..22}`; do 
		sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; \ 
		echo -e "\n echo $i $j; vcftools --gzvcf /users/mturchin/data/1000G/ALL.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz --keep /users/mturchin/data/1000G/subsets/integrated_call_samples_v3.20130502.ALL.panel.$i.IIDs --recode --recode-INFO-all --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes"; \ 
		echo -e "\ngzip -f /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.recode.vcf"; \
		echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.recode.vcf.gz --plink --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes"; \
		echo -e "\nplink --file /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes"; \
		echo -e "\nrm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.ped /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.map";)
	done

	j="X"; sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; echo -e "\necho $i $j"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/ALL.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz --keep /users/mturchin/data/1000G/subsets/integrated_call_samples_v3.20130502.ALL.panel.$i.IIDs --recode --recode-INFO-all --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes"; echo -e "\ngzip -f /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.recode.vcf"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.recode.vcf.gz --plink --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes"; echo -e "\nplink --bfile /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes"; echo -e "\nrm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.ped /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.map";)
	j="Y"; sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; echo -e "\necho $i $j"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/ALL.chr${j}.phase3_integrated_v2a.20130502.genotypes.vcf.gz --keep /users/mturchin/data/1000G/subsets/integrated_call_samples_v3.20130502.ALL.panel.$i.IIDs --recode --recode-INFO-all --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes"; echo -e "\ngzip -f /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.recode.vcf"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.recode.vcf.gz --plink --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes"; echo -e "\nplink --bfile /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes"; echo -e "\nrm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.ped /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.map";)

done

for i in `echo "CEU YRI CHB"`; do
	echo $i

        cat /dev/null > /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.MergeList.Vs1.txt 

        for chr in {2..22}; do
                echo "/users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bed /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bim /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.fam" >> /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.MergeList.Vs1.txt
        done
	echo "/users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.bed /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.bim /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.fam" >> /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.MergeList.Vs1.txt 
	echo "/users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.bed /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.bim /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.fam" >> /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.MergeList.Vs1.txt

done

for i in `echo "CEU YRI CHB"`; do
	echo $i /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.MergeList.Vs1.txt

        sbatch -t 72:00:00 --mem 100g -o /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.slurm.merge.output -e /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.slurm.merge.error --comment "MergeList $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/1000G/subsets/$i/$i.chr1.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes --merge-list /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.MergeList.Vs1.txt --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes") 

done
   



#From https://github.com/gabraham/flashpca
#See /users/mturchin/PackageInstallationLog.vs1.sh for information re: installing flashpca (done within Conda environment; recall note re: 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/users/mturchin/conda/MultiEthnicGWAS/lib')
```
.
.
.
Quick start
First thin the data by LD (highly recommend plink2 for this):

plink --bfile data --indep-pairwise 1000 50 0.05 --exclude range exclusion_regions_hg19.txt
plink --bfile data --extract plink.prune.in --make-bed --out data_pruned
where exclusion_regions_hg19.txt contains:

5 44000000 51500000 r1
6 25000000 33500000 r2
8 8000000 12000000 r3
11 45000000 57000000 r4
(You may need to change the --indep-pairwise parameters to get a suitable number of SNPs for you dataset, 10,000-50,000 is usually enough.)

To run on the pruned dataset:

./flashpca --bfile data_pruned
To append a custom suffix '_mysuffix.txt' to all output files:

./flashpca --suffix _mysuffix.txt ...
To see all options

./flashpca --help 
Output
By default, flashpca produces the following files:

eigenvectors.txt: the top k eigenvectors of the covariance X XT / p, same as matrix U from the SVD of the genotype matrix X/sqrt(p)=UDVT (where p is the number of SNPs).
pcs.txt: the top k principal components (the projection of the data on the eigenvectors, scaled by the eigenvalues, same as XV (or UD). This is the file you will want to plot the PCA plot from.
eigenvalues.txt: the top k eigenvalues of X XT / p. These are the square of the singular values D (square of sdev from prcomp).
pve.txt: the proportion of total variance explained by each of the top k eigenvectors (the total variance is given by the trace of the covariance matrix X XT / p, which is the same as the sum of all eigenvalues). To get the cumulative variance explained, simply do the cumulative sum of the variances (cumsum in R).
Warning
You must perform quality control using PLINK (at least filter using --geno, --mind, --maf, --hwe) before running flashpca on your data. You will likely get spurious results otherwise.
.
.
.
Checking accuracy of results
flashpca can check how accurate a decomposition is, where accuracy is defined as || X XT / p - U D2 ||F2 / (n × k).

This is done using

./flashpca --bfile data --check \
--outvec eigenvectors.txt --outval eigenvalues.txt
The final mean squared error should be low (e.g., <1e-8).

Outlier removal in PCA
Unlike EIGENSOFT/smartpca, flashpca does not remove outliers automatically (numoutlieriter in EIGENSOFT). We recommend inspecting the PCA plot manually, and if you wish to remove outliers and repeat PCA on the remaining samples, use plink --remove to create a new bed/bim/fam fileset and run flashpca on the new data.
.
.
.
```

#Some info on more recent QC procedures, from: https://www.biorxiv.org/content/biorxiv/early/2017/07/20/166298.full.pdf, https://www.biorxiv.org/content/biorxiv/suppl/2017/07/20/166298.DC1/166298-1.pdf & https://media-nature-com.revproxy.brown.edu/original/nature-assets/ng/journal/v46/n11/extref/ng.3097-S1.pdf
#Note -- the following article has a good, short description re: the concern of strand-mismatching, which moreso has to do with comparing a given dataset with a reference datasets (which shouldn't be a problem here when dealing with just within-UKBioBank data and not
#Note -- little unsure why they were concerned with 'unresolvable strand differences' since they knew the strand for UKBioBank (all '+' it looks like), and they should have been able to get some raw information for the stranded of the 1000G data too....unless for some reason that latter information wasn't available? Pretty sure you can determine even C/G and A/T ref/alt differences between two datasets if you can confirm that both datasets are on the same strand?...
#Note -- I think not using/including 1000G data to determine PCs within each ancestry subset is fine...but if wanting to create or use global PCs probably want to include 1000G data like UKBioBank 2017 publication did; in fact their PC data may even be available (probably/likely it is??) ('/users/mturchin/data/ukbiobank_jun17/ukb_snp_qc.txt' shows the PC loadings for some SNPs but not all SNPs...which probably means those are the SNPs that were used in the overlapping, pruned dataset to get the PCs...but currently don't have the individual QC file that would give us the individual PC loadings which should be dataset-wide, unlike only some of these SNPs having the PC-loadings information)
```
.
.
.
	In	order	to	
attenuate population	structure	effects we	applied	all	marker-based	QC	tests	using	a	
subset	of	463,844 individuals	with	estimated	European	ancestry.	We	identified these	
individuals	from	the genotype data	prior	to	conducting	any	QC by projecting all	the	
UK	Biobank	samples	on	to	the	two	major	principal	components of	four	1000	
Genomes	populations	(CEU,	YRI,	CHB	and	JPT) [28].	We	then	selected samples	with	
principal	component (PC) scores	falling	in	the	neighbourhood	of	the	CEU	cluster (see	
Supplementary	Material).	
Most	QC	metrics	require	a	threshold	beyond	which	to	consider	a	marker	‘not	
reliable’.	We	used thresholds such	that	only	strongly	deviating	markers	would	fail	QC	
tests (see Supplementary	Material),	therefore	allowing	researchers	to	further	refine	
the	QC	in	whichever	way	is	most	appropriate	for their	study	requirements. Table	3
summarises	the	amount	of	data	affected	by applying	these	tests.
.
.
.
```
```
.
.
.
We	first	downloaded	1000	Genomes	Project	Phase	1	data in Variant	Call	File	(VCF)	
format	[8] and	extracted	714,168	SNPs (no	Indels)	that	are	also on	the	UK	Biobank	
Axiom	array.		We	selected	355	unrelated	samples	from	the	populations	CEU,	CHB,	
JPT,	YRI,	and	then	chose	SNPs	for	principal	component	analysis	using	the	following	
criteria:
• MAF	≥	5%	and	HWE	p-value	>	10-6
,	in	each	of	the	populations	CEU,	CHB,	JPT	
and	YRI.		
• Pairwise	r
2 ≤	0.1	to	exclude	SNPs	in	high	LD.		(The	r
2 coefficient	was	
computed	using	plink [9] and	its ‘indep-pairwise’	function	with	a	moving	
window	of	size	1000	bp).
• Removed	C/G	and	A/T	SNPs	to	avoid	unresolvable	strand	mismatches.
• Excluded	SNPs	in	several	regions	with	high	PCA	loadings	(after	an	initial	PCA).
With	the	remaining	40,220 SNPs	we	computed	PCA loadings	from	the	355	1,000	
Genomes	samples,	then	projected	all	the UK	Biobank	samples	onto	the	1st and	2nd
principal	components.		All	computations	were	performed	with	Shellfish
(http://www.stats.ox.ac.uk/~davison/software/shellfish/shellfish.php).
.
.
.
```
```
.
.
.
1.1.5 Meta-analysis of GWA studies
A total of 2,550,858 autosomal SNPs were meta-analyzed across 174 input files (many of
the 79 cohorts had separate male-female and/or case-control files). We did not apply a
minor allele frequency cut-off, but we did apply an arbitrary cut-off of NxMAF > 3 (equivalent
Nature Genetics: doi:10.1038/ng.3097
Page 48 of 76
to a minor allele count of 6) to guard against extremely rare variants present in only one or
two samples (possible genotyping/imputation errors or private mutations), for which
regression coefficients are not estimated well using the standard statistical methods
employed in most GWA statistical programs
.
.
.
Supplementary Table 17. Study design, number of individuals and sample quality control for genome-wide association study cohorts
Study
Study design Total sample
size (N)
Sample QC Samples in
analyses(N)
Anthropometric
assessment
method
References Short name Full name Call rate* other exclusions
ACTG The AIDS Clinical
Trials Group
Population-based 2648 >95% 1) Non-Europeans (based on PCA);
2) High individual missingness
(>5%);
3) High heterozygosity (Inbreeding
coefficient > 0.1 or < -0.1);
4) Related individuals
5) duplicates
1055 measured International, H.I.V.C.S. et al. The major genetic
determinants of HIV-1 control affect HLA class I peptide
presentation. Science 330, 1551-7 (2010).
AE Athero-Express
Biobank Study
patient-cohort 2512 ≥ 97% 1) Heterozygosity (Ĥ) ± 3 standard
deviations of the mean;
2) Ethnic outliers through Principal
Component Analysis compared to
HapMap 2 (r22);
3) Related individuals and
duplicates, π>0.20;
4) Missing body weight and height.
686 measured 1) Verhoeven, B.A. et al. Athero-express: differential
atherosclerotic plaque expression of mRNA and protein
in relation to cardiovascular events and patient
characteristics. Rationale and design. Eur J Epidemiol 19,
1127-33 (2004).
2) Hurks, R. et al. Aneurysm-express: human abdominal
aortic aneurysm wall expression in relation to
heterogeneity and vascular events - rationale and
design. Eur Surg Res 45, 34-40 (2010).
ASCOT AngloScandinavian

Cardiac Outcome
Trial
Randomised control
clinical trial
3868 ≥ 95% 1) Sample cryptic duplicates
2) Sample outliers in ancestry
principle components analysis
3) First and second degree
relatives;
4) Missing body weight and height.
3802 measured
.
.
.
```
```
.
.
.
Strand alignment
Strand alignment between genotype data set and reference data set is crucial for GWA analysis and imputation. Generally, reference panels such as HapMap are given as ‘+’ strand but data might be genotyped with respect to negative strand. If two samples at a SNP are genotyped at different strands, it can be easily recognized except for C/G or A/T SNPs. PLINK has the option to detect opposite strand alignments between cases and controls (“--flip-scan”). fcGENE supports the comparison of strand information between genotyped SNP data and reference panels using this PLINK's “--flip-scan” feature in the following way:
.
.
.
```

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/users/mturchin/conda/MultiEthnicGWAS/lib

#cd /users/mturchin/Software/flashpca
#wget https://github.com/gabraham/flashpca/blob/master/exclusion_regions_hg19.txt
#Note -- this file is already provided with the flashpca install

#20180313 Note -- as of this date, the first version of this file downloaded appears to be the 'old' version in circulation (see 'http://www.ukbiobank.ac.uk/wp-content/uploads/2017/07/ukb_genetic_file_description.txt'); going to attempt to find/locate/access the most recent, up-to-date one soon
cd /users/mturchin/data/ukbiobank_jun17
ftp ftp.ega.ebi.ac.uk
#See Slack for login & PW
cd EGAD00010001226
ls
get ukb_sqc_v2.txt.gz.enc.cip
paste <(cat /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr17_v2_s488363.fam) <(zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.txt.gz) | gzip > /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz
zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz | awk '{ if ($29 == 1) { print $1 "\t" $2 } }' > /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs

#UKBioBankPops=`echo "African;African Any_other_Asian_background;Any_other_Asian_background Any_other_mixed_background;Any_other_mixed_background Any_other_white_background;Any_other_white_background British;British British;British.Ran4000 Caribbean;Caribbean Chinese;Chinese Indian;Indian Irish;Irish Pakistani;Pakistani"`;
#UKBioBankPops=`echo "African;African Any_other_white_background;Any_other_white_background British;British British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 Caribbean;Caribbean Indian;Indian Irish;Irish"`; 
UKBioBankPops=`echo "African;African Any_other_Asian_background;Any_other_Asian_background Any_other_mixed_background;Any_other_mixed_background Any_other_white_background;Any_other_white_background British;British British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 Caribbean;Caribbean Chinese;Chinese Indian;Indian Irish;Irish Pakistani;Pakistani"`; 
#UKBioBankPops=`echo "African;African"`;
#UKBioBankPops=`echo "British;British British;British.Ran100000 British;British.Ran200000"`;
UKBioBankPops=`echo "African;African Any_other_Asian_background;Any_other_Asian_background Any_other_mixed_background;Any_other_mixed_background Any_other_white_background;Any_other_white_background British;British.Ran4000 British;British.Ran10000 Caribbean;Caribbean Chinese;Chinese Indian;Indian Irish;Irish Pakistani;Pakistani"`;

mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1
mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/AncCmps
mv /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/PCAEffect /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/.
#/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/scripts/Intro/2017WinterHack.plink.GetAncestrySubsets.vs2.sh
#/users/mturchin/data/ukbiobank_jun17/subsets/

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
	echo $ancestry1 $ancestry2

	if [ ! -d /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20 ]; then
		mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20
		mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/Height
		mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/BMI
		mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/Waist
		mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/Hip
	fi

	mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/.
	mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr*_v2.$ancestry2.bed* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr*_v2.$ancestry2.fam* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr*_v2.$ancestry2.bim* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr*_v2.$ancestry2.log* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr*_v2.$ancestry2.nosex* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr*_v2.$ancestry2.slurm* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/.
	mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/*Height* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/Height/.
	mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/*BMI* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/BMI/.
	mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/*Waist* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/Waist/.
	mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/*Hip* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/Hip/.

done


#for pheno1 in `echo "Height BMI Waist Hip"`; do
for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

		for i in {1..22} X; do
			echo $pheno1 $ancestry1 $ancestry2 $i

			sbatch -t 72:00:00 --mem 20g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.fastpca.QC.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.fastpca.QC.slurm.error --comment "$ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; \ 
			echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2} --maf .01 --geno .05 --hwe 1e-6 --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed"; \ 
			echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed --indep-pairwise 1000 50 0.05 --exclude range /users/mturchin/Software/flashpca/exclusion_regions_hg19.txt --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed"; \
			echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed --extract /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.prune.in --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.pruned") 

		done
	done	
done

#			sbatch -t 72:00:00 --mem 20g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.fastpca.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.fastpca.slurm.error --comment "$ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2} --maf .01 --geno --mind .95
#			sbatch -t 1:00:00 --mem 20g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.linear.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.linear.slurm.error --comment "$pheno1 $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2} --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name $pheno1 --linear --sex --covar /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt --covar-name AGE --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}")

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.MergeList.Vs2.txt

	cat /dev/null > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.MergeList.Vs2.txt
	
	for chr in {2..22} X; do
		echo "/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${chr}_v2.${ancestry2}.QCed.pruned.bed /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${chr}_v2.${ancestry2}.QCed.pruned.bim /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${chr}_v2.${ancestry2}.QCed.pruned.fam" >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.MergeList.Vs2.txt
	done

done

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.MergeList.Vs2.txt

	sbatch -t 1:00:00 --mem 100g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.slurm.MergeList.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.slurm.MergeList.error --comment "$ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr1_v2.${ancestry2}.QCed.pruned --merge-list /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.MergeList.Vs2.txt --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned") 
done

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo $ancestry1 $ancestry2

	sbatch -t 72:00:00 --mem 200g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.fastpca.QC.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.fastpca.QC.slurm.error --comment "$ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; \ 
	echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned --mind .05 --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed"; \
	echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed --genome gz --min .05 --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed";) 

done	

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo $ancestry1 $ancestry2

#	cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.genome.drop.FIDIIDs | wc
#	zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.genome.gz | awk '{ if ($10 >= .2) { print $1 "\t" $2 "\t" $3 "\t" $4 } }' | grep -v PI_HAT |  R -q -e "set.seed(459721380); Data1 <- read.table(file('stdin'), header=F); names(Data1)[3] <- names(Data1)[1]; names(Data1)[4] <- names(Data1)[2]; Data2 <- c(); for (i in 1:nrow(Data1)) { if (runif(1) >= .5) { Data2 <- rbind(Data2, Data1[i,c(1:2)]); } else { Data2 <- rbind(Data2, Data1[i,c(3:4)]) } }; write.table(Data2, quote=FALSE, col.names=FALSE, row.names=FALSE);" | grep -v \> | grep -v FID | sort | uniq > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.genome.drop.FIDIIDs 
#	cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.genome.drop.FIDIIDs /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.genome.drop.wukbDrops.FIDIIDs
#	plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed --remove /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.genome.drop.wukbDrops.FIDIIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs
	plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed --keep /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.genome.drop.wukbDrops.FIDIIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.onlyRltvs

done	

#R -q -e "set.seed(459721380); Data1 <- read.table(file('stdin'), header=F); Data2 <- c(); for (i in 1:nrow(Data1)) { if (runif(1) >= .5) { Data2 <- rbind(Data2, c(Data1[i,c(1:2)])); } else { Data2 <- rbind(Data2, c(Data1[i,
#R -q -e "set.seed(459721380); Data1 <- read.table(file('stdin'), header=F); names(Data1)[3] <- names(Data1)[1]; names(Data1)[4] <- names(Data1)[2]; Data2 <- c(); for (i in 1:nrow(Data1)) { if ((! Data1[i,2] %in% Data2[,2]) && (! Data1[i,4] %in% Data2[,2])) { if (runif(1) >= .5) { Data2 <- rbind(Data2, Data1[i,c(1:2)]); } else { Data2 <- rbind(Data2, Data1[i,c(3:4)]) } } }; write.table(Data2, quote=FALSE, col.names=FALSE, row.names=FALSE);" | grep -v \> > 

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);' | head -n 1)`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo $ancestry1 $ancestry2

	sbatch -t 72:00:00 --mem 20g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.fastpca.run.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.fastpca.run.slurm.error --comment "$ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; \ 
	echo -e "\n/users/mturchin/Software/flashpca/flashpca --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs -d 20 --outpc /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.flashpca.pcs.txt --outload /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.flashpca.loads.txt --outvec /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.flashpca.vecs.txt --outval /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.flashpca.vals.txt --outpve /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.flashpca.pve.txt --outmeansd /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.flashpca.meansd.txt"; \
	echo -e "\n/users/mturchin/Software/flashpca/flashpca --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.onlyRltvs --project --inmeansd /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.flashpca.meansd.txt --outproj /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.flashpca.projRltvs.txt --inload /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.flashpca.loads.txt"; \
	echo -e "\nR -q -e \"Data1 <- read.table(\\\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.flashpca.pcs.txt\\\", header=T); Data2 <- read.table(\\\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.flashpca.projRltvs.txt\\\", header=T); Data1 <- cbind(Data1, rep(\\\"BLACK\\\", nrow(Data1))); Data2 <- cbind(Data2, rep(\\\"RED\\\", nrow(Data2))); names(Data2)[ncol(Data2)] <- names(Data1)[ncol(Data1)]; Data3 <- rbind(Data1, Data2); png(\\\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.flashpca.wRltvs.PCplots.vs1.png\\\", height=8000, width=4000, res=300); par(mfrow=c(4,2)); plot(Data3[,3], Data3[,4], xlab=\\\"PC1\\\", ylab=\\\"PC2\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data3[,5], Data3[,6], xlab=\\\"PC3\\\", ylab=\\\"PC4\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data3[,7], Data3[,8], xlab=\\\"PC5\\\", ylab=\\\"PC6\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data3[,9], Data3[,10], xlab=\\\"PC7\\\", ylab=\\\"PC8\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data3[,11], Data3[,12], xlab=\\\"PC9\\\", ylab=\\\"PC10\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data3[,13], Data3[,14], xlab=\\\"PC11\\\", ylab=\\\"PC12\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data3[,15], Data3[,16], xlab=\\\"PC13\\\", ylab=\\\"PC14\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data3[,17], Data3[,18], xlab=\\\"PC15\\\", ylab=\\\"PC16\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); dev.off();\"";)

done	

#legend(\"bottomright\", c(\"GWAS Thresh\"), lty=2, lwd=2, col=\"RED\", cex=1.5);

#From MacBook Air
#mkdir /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1
#mv /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/.
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/*/*/mturchin20/*PCplots.vs1.png /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/UKBioBank/.

#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran*.Results.pca.plot.*.pdf /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank/.




cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(234324); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 50 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(234724); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 100 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(234444); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 500 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran500.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(434322); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 1000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran1000.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(564374); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 5000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran5000.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(254329); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran10000.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(274384); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 5000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50000.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(737321); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 100000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100000.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(931284); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran250000.FIDIIDs

plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran500.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran500
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran1000.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran1000
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran5000.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran5000
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran10000.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran10000
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50000.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50000
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100000.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100000
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran250000.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran250000
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2

paste <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran500.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran1000.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran5000.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran10000.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50000.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100000.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran250000.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.hwe | sort -rg -k 9,9 | awk '{ print $9 }') | vi -

#R -q -e "png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.hweComps.vs1.png\", height=2000, width=2000, res=300); plot(0, xlim=c(0, 61966), ylim=c(0,-log10(9.881e-323))); for (i in c(50, 100, 500, 1000, 5000, 10000, 50000, 100000, 250000)) { Data1 <- read.table(paste(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran\", i, \".hwe\", sep=\"\"),  header=T); Data1 <- Data1[order(Data1[,9], decreasing=FALSE),]; points(seq(1, 61966), -log10(Data1[,9])); }; Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.hwe\", header=T); Data1 <- Data1[order(Data1[,9], decreasing=FALSE),]; points(seq(1, 61966), -log10(Data1[,9])); dev.off();"





#21000 Ethnic_background 501726
#21001 Body_mass_index_(BMI) 499579
#21003 Age_when_attended_assessment_centre 502620
#22000 Genotype_measurement_batch 488366
#22001 Genetic_sex 488366
#22006 Genetic_ethnic_grouping 409694
#22007 Genotype_measurement_plate 488366
#22008 Genotype_measurement_well 488366
#22009 Genetic_principal_components 488366
#22011 Genetic_relatedness_pairing 17306
#22012 Genetic_relatedness_factor 17306
#22013 Genetic_relatedness_IBS0 17306
#31 Sex 502620
#34 Year_of_birth 502620
#48 Waist_circumference 500500
#49 Hip_circumference 500438
#50 Standing_height 500130

#21000 Ethnic_background 501726
#21001 Body_mass_index_(BMI) 499579
#21003 Age_when_attended_assessment_centre 502620
#22000 Genotype_measurement_batch 488366
#22001 Genetic_sex 488366
#22003 Heterozygosity 488366
#22004 Heterozygosity_PCA_corrected 488366
#22005 Missingness 488366
#22006 Genetic_ethnic_grouping 409694
#22007 Genotype_measurement_plate 488366
#22008 Genotype_measurement_well 488366
#22009 Genetic_principal_components 488366
#22011 Genetic_relatedness_pairing 17306
#22012 Genetic_relatedness_factor 17306
#22013 Genetic_relatedness_IBS0 17306
#22018 Genetic_relatedness_exclusions 1532
#22051 UKBiLEVE_genotype_quality_control_for_samples 50002
#22052 UKBiLEVE_unrelatedness_indicator 50002
#22182 HLA_imputation_values 488366
#2443 Diabetes_diagnosed_by_doctor 501697
#2453 Cancer_diagnosed_by_doctor 501697
#2463 Fractured/broken_bones_in_last_5_years 501697
#2473 Other_serious_medical_condition/disability_diagnosed_by_doctor 501697
#2966 Age_high_blood_pressure_diagnosed 137429
#2976 Age_diabetes_diagnosed 26002
#2986 Started_insulin_within_one_year_diagnosis_of_diabetes 26027
#3005 Fracture_resulting_from_simple_fall 49691
#31 Sex 502620
#3140 Pregnant 272635
#34 Year_of_birth 502620
#48 Waist_circumference 500500
#49 Hip_circumference 500438
#50 Standing_height 500130
#52 Month_of_birth 502620

#=~ s/1/White/g
#=~ s/1001/British/g
#=~ s/2001/White_and_Black_Caribbean/g
#=~ s/3001/Indian/g
#=~ s/4001/Caribbean/g
#=~ s/2/Mixed/g
#=~ s/1002/Irish/g
#=~ s/2002/White_and_Black_African/g
#=~ s/3002/Pakistani/g
#=~ s/4002/African/g	
#=~ s/3/Asian_or_Asian_British/g
#=~ s/1003/Any_other_white_background/g
#=~ s/2003/White_and_Asian/g
#=~ s/3003/Bangladeshi/g
#=~ s/4003/Any_other_Black_background/g
#=~ s/4/Black_or_Black_British/g
#=~ s/2004/Any_other_mixed_background/g
#=~ s/3004/Any_other_Asian_background/g
#=~ s/5/Chinese/g
#=~ s/6/Other_ethnic_group/g
#=~ s/-1/Do_not_know/g
#=~ s/-3/Prefer_not_to_answer/g

#From http://biobank.ctsu.ox.ac.uk/crystal/coding.cgi?id=1001
#Coding	Meaning	Node	Parent
#1	White	1	Top
#1001	British	1001	1
#2001	White and Black Caribbean	2001	2
#3001	Indian	3001	3
#4001	Caribbean	4001	4
#2	Mixed	2	Top
#1002	Irish	1002	1
#2002	White and Black African	2002	2
#3002	Pakistani	3002	3
#4002	African	4002	4
#3	Asian or Asian British	3	Top
#1003	Any other white background	1003	1
#2003	White and Asian	2003	2
#3003	Bangladeshi	3003	3
#4003	Any other Black background	4003	4
#4	Black or Black British	4	Top
#2004	Any other mixed background	2004	2
#3004	Any other Asian background	3004	3
#5	Chinese	5	Top
#6	Other ethnic group	6	Top
#-1	Do not know	-1	Top
#-3	Prefer not to answer	-3	Top

#   3396 African
#   1815 Any_other_Asian_background
#    123 Any_other_Black_background
#   1033 Any_other_mixed_background
#  16340 Any_other_white_background
#     43 Asian_or_Asian_British
#    236 Bangladeshi
#     27 Black_or_Black_British
# 442688 British
#   4519 Caribbean
#   1574 Chinese
#    217 Do_not_know
#      1 Ethnic_background-0.0
#   5951 Indian
#  13213 Irish
#     49 Mixed
#   4560 Other_ethnic_group
#   1837 Pakistani
#   1662 Prefer_not_to_answer
#    571 White
#    831 White_and_Asian
#    425 White_and_Black_African
#    620 White_and_Black_Caribbean

~~~
[  mturchin@login002  ~]$GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=53 | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*(\d+,\d+ participants).*/) { print $line; }'
540,184 items of data are available, covering 502,620 participants.<br>Defined-instances run from 0 to 2, labelled using Instancing <a class="basic" href="instance.cgi?id=2">2</a>.
502,620 participants, 502,620 items
20,348 participants, 20,348 items
17,216 participants, 17,216 items
[  mturchin@login002  ~]$GET http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0\&vt=11 | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*.a class="basic" href="field.cgi\?id=(\d+)"..*.a class="subtle" href="field.cgi\?id=\d+".(.*).\/a..\/td..*/) { print $1, "\t", $2 ; }' | head -n 10
5111    3mm asymmetry angle (left)
5108    3mm asymmetry angle (right)
5112    3mm cylindrical power angle (left)
5115    3mm cylindrical power angle (right)
5292    3mm index of best keratometry results (left)
5237    3mm index of best keratometry results (right)
5104    3mm strong meridian angle (left)
5107    3mm strong meridian angle (right)
5103    3mm weak meridian angle (left)
5100    3mm weak meridian angle (right)
[  mturchin@login002  ~]$echo $urls1
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=11 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=21 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=22 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=31 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=41 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=51 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=61 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=101
[  mturchin@login002  ~]$for i in urls1; do echo $i; done
urls1
[  mturchin@login002  ~]$for i in $urls1; do echo $i; done
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=11
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=21
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=22
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=31
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=41
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=51
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=61
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=101
[  mturchin@login002  ~]$for i in `echo "http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0\&vt=11"`; do echo $i; GET "$i" | wc; done
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0\&vt=11
     74     279    3872
[  mturchin@login002  ~]$for i in `echo "http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=11"`; do echo $i; GET "$i" | wc; done
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=11
    398    6529  107322
[  mturchin@login002  ~]$for i in $urls1; do echo $i; GET $i | wc; done
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=11
    398    6529  107322
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=21
    943   15794  273946
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=22
    166    2241   37668
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=31
   1444   29862  452672
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=41
     86     781   12146
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=51
     80     699   10641
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=61
     66     437    6288
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=101
     63     366    5296
[  mturchin@login002  ~]$cat /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/UKBioBank.HTMLScraping.Field_Name.vs.txt | wc
   2821   19813  132241
[  mturchin@login002  ~]$GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=20434 | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*(\d+,\d+ participants).*/) { print $line; }'
89,048 items of data are available, covering 89,048 participants.<br>Some values have special meanings defined by Data-Coding <a class="basic" href="coding.cgi?id=513">513</a>.
[  mturchin@login002  ~]$GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=20434 | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*(\d+,\d+ participants).*/) { print $1; }'
9,048 participants
[  mturchin@login002  ~]$GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=20434 | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*(\d*,\d+ participants).*/) { print $1; }'
,048 participants
[  mturchin@login002  ~]$GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=20434 | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*(\d+,\d+ participants).*/) { print $1; }'
9,048 participants
[  mturchin@login002  ~]$GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=20434 | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.* (\d+,\d+ participants).*/) { print $1; }'
89,048 participants
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | awk '{ print $3 }' | R -q -e "Data1 <- read.table(file('stdin'), header=F); table(cut(Data1[,1], c(0,100000,200000,300000,400000,500000,600000)));"
> Data1 <- read.table(file('stdin'), header=F); table(cut(Data1[,1], c(0,100000,200000,300000,400000,500000,600000)));

    (0,1e+05] (1e+05,2e+05] (2e+05,3e+05] (3e+05,4e+05] (4e+05,5e+05] 
         1730           519           110            52           203 
(5e+05,6e+05] 
          122 
> 
> 
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | wc
 502630 7134350 3172553836
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | wc
 502617  502617 33818880
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'print $#F;' | sort | uniq -c
 501809 1929
    548 1930
    181 1931
     63 1932
     19 1933
      7 1934
      2 1935
      1 1938
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | perl -F, -lane 'print $#F;' | sort | uniq -c
 502617 12
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | wc
   1930    1930   24295
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | head -n 10
"eid"
"31-0.0"
"34-0.0"
"48-0.0"
"48-1.0"
"48-2.0"
"49-0.0"
"49-1.0"
"49-2.0"
"50-0.0"
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | head -n 10
eid
31-0.0
34-0.0
48-0.0
48-1.0
48-2.0
49-0.0
49-1.0
49-2.0
50-0.0
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | head -n 10
eid
31 0.0
34 0.0
48 0.0
48 1.0
48 2.0
49 0.0
49 1.0
49 2.0
50 0.0
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq | wc
    222     222    1232
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | head -n 10
eid
31 0.0
34 0.0
48 0.0
48 1.0
48 2.0
49 0.0
49 1.0
49 2.0
50 0.0
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq -c | sort -rg -k 1,1 | head -n 10
    435 41204
    380 41202
     87 87
     87 20013
     87 20009
     87 20008
     87 20002
     42 40002
     32 41201
     30 41205
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq -c | sort -rg -k 1,1 | awk '{ print $1 }' | sort | uniq -c | sort -rg -k 1,1
    121 1
     71 3
      6 18
      5 87
      5 5
      3 2
      2 15
      2 12
      1 435
      1 42
      1 380
      1 32
      1 30
      1 28
      1 21
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq | head -n 10
10721
10844
129
130
134
135
189
1920
1930
1940
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | head -n 10
5111    3mm_asymmetry_angle_(left)      121723
5108    3mm_asymmetry_angle_(right)     121954
5112    3mm_cylindrical_power_angle_(left)      124554
5115    3mm_cylindrical_power_angle_(right)     124540
5292    3mm_index_of_best_keratometry_results_(left)    124573
5237    3mm_index_of_best_keratometry_results_(right)   124552
5104    3mm_strong_meridian_angle_(left)        124573
5107    3mm_strong_meridian_angle_(right)       124552
5103    3mm_weak_meridian_angle_(left)  124573
5100    3mm_weak_meridian_angle_(right) 124552
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq -c | sort -rg -k 1,1 | awk '{ print $1 }' | sort | uniq -c | sort -rg -k 2,2 | R -q -e "Data1 <- read.table(file('stdin'), header=F); sum(Data1[,1]);"
> Data1 <- read.table(file('stdin'), header=F); sum(Data1[,1]);
[1] 222
> 
> 
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | wc
   2736    8208  142895
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq | wc
    222     222    1232
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1) | wc
    122     366    5411
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$join -v 1 <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1) | head -n 10
10844
22010
22014
22015
22050
22101
22102
22103
22104
22105
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | grep 22015
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | wc
    100     278    4754
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | head -n 10
10844   Gestational_diabetes_only_(pilot)       63
22010   Recommended_genomic_analysis_exclusions 480
22014   
22015   Average_Y_chromosome_intensities_for_determining_sex    152720
22050   
22101   Chromosome_1_genotype_results   488366
22102   Chromosome_2_genotype_results   488366
22103   
22104   
22105   Chromosome_5_genotype_results   488366
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | perl -lane 'print $#F;' | sort | uniq -c
     11 0
     89 2
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1)) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | perl -lane 'if ($#F == 2) { print join("\t", @F); }' ) | wc
    211     633   10079
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1)) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | perl -lane 'if ($#F == 2) { print join("\t", @F); }' ) | head -n 10
10721 Illness_injury_bereavement_stress_in_last_2_years_(pilot) 3776
129 Place_of_birth_in_UK_-_north_co-ordinate 452391
130 Place_of_birth_in_UK_-_east_co-ordinate 452391
134 Number_of_self-reported_cancers 501765
135 Number_of_self-reported_non-cancer_illnesses 501765
189 Townsend_deprivation_index_at_recruitment 501993
1920 Mood_swings 501724
1930 Miserableness 501724
1940 Irritability 501724
1950 Sensitivity_/_hurt_feelings 501723
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1)) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | perl -lane 'if ($#F == 2) { print join("\t", @F); }' ) | tail -n 10
41104   Episodes_containing_&quot;External_cause_-_ICD10&quot;_data     66352
41105   Episodes_containing_&quot;External_cause_-_ICD10_addendum&quot;_data    176
41142   Episodes_containing_&quot;Diagnoses_-_main_ICD10&quot;_data     392294
41143   Episodes_containing_&quot;Diagnoses_-_main_ICD10_-_addendum&quot;_data  2734
41144   Episodes_containing_&quot;Diagnoses_-_main_ICD9&quot;_data      20309
41145   Episodes_containing_&quot;Diagnoses_-_main_ICD9_-_addendum&quot;_data   0
41148   Episodes_containing_&quot;Date_of_operation&quot;_data  377744
41216   Legal_statuses  38
41217   Mental_categories       59
41252   Episodes_containing_&quot;Source_of_inpatient_record&quot;_data 395938
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1)) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | perl -lane 'if ($#F == 2) { print join("\t", @F); }' ) | perl -lane 'print $#F;' | sort | uniq -c
    211 2
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | wc
     13      13      76
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq | wc
      5       5      28
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1) | wc
      4      12     157
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$join -v 1 <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1)     
eid
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1)  
30040 Mean_corpuscular_volume 479453
30080 Platelet_count 479450
30100 Mean_platelet_(thrombocyte)_volume 479445
30170 Nucleated_red_blood_cell_count 478360
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.Field_Name_Participants.vs1.txt /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.Field_Name_Participants.vs1.txt | sort -rg -k 3,3 | awk '{ print $3 }' | R -q -e "Data1 <- read.table(file('stdin'), header=F); table(cut(Data1[,1], c(0,100000,200000,300000,400000,500000,600000)));"
> Data1 <- read.table(file('stdin'), header=F); table(cut(Data1[,1], c(0,100000,200000,300000,400000,500000,600000)));

    (0,1e+05] (1e+05,2e+05] (2e+05,3e+05] (3e+05,4e+05] (4e+05,5e+05] 
           54            66             1            18            36 
(5e+05,6e+05] 
           38 
> 
> 
#20171218
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'my @vals1 = (4,7,11,211); print join("\t", @F[@vals1]);'
"48-1.0"        "49-1.0"        "50-2.0"        "2976-2.0"
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | head -n 5
eid,Sex-0.0,Year_of_birth-0.0,Waist_circumference-0.0,Waist_circumference-1.0,Waist_circumference-2.0,Hip_circumference-0.0,Hip_circumference-1.0,Hip_circumference-2.0,Standing_height-0.0,Standing_height-1.0,Standing_height-2.0,Ethnic_background-0.0,Ethnic_background-1.0,Ethnic_background-2.0,Body_mass_index_(BMI)-0.0,Body_mass_index_(BMI)-1.0,Body_mass_index_(BMI)-2.0,Age_when_attended_assessment_centre-0.0,Age_when_attended_assessment_centre-1.0,Age_when_attended_assessment_centre-2.0,Genotype_measurement_batch-0.0,Genetic_sex-0.0,Genetic_ethnic_grouping-0.0,Genotype_measurement_plate-0.0,Genotype_measurement_well-0.0,Genetic_principal_components-0.1,Genetic_principal_components-0.2,Genetic_principal_components-0.3,Genetic_principal_components-0.4,Genetic_principal_components-0.5,Genetic_principal_components-0.6,Genetic_principal_components-0.7,Genetic_principal_components-0.8,Genetic_principal_components-0.9,Genetic_principal_components-0.10,Genetic_principal_components-0.11,Genetic_principal_components-0.12,Genetic_principal_components-0.13,Genetic_principal_components-0.14,Genetic_principal_components-0.15,Genetic_relatedness_pairing-0.0,Genetic_relatedness_pairing-0.1,Genetic_relatedness_pairing-0.2,Genetic_relatedness_pairing-0.3,Genetic_relatedness_pairing-0.4,Genetic_relatedness_factor-0.0,Genetic_relatedness_factor-0.1,Genetic_relatedness_factor-0.2,Genetic_relatedness_factor-0.3,Genetic_relatedness_factor-0.4,Genetic_relatedness_IBS0-0.0,Genetic_relatedness_IBS0-0.1,Genetic_relatedness_IBS0-0.2,Genetic_relatedness_IBS0-0.3,Genetic_relatedness_IBS0-0.4
1251407,1,1961,92,94,,107,108,,180.5,180,,1001,1001,,27.9924,29.5988,,46,51,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
5176998,1,1954,121,,,112,,,172,,,1001,,,37.1485,,,54,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
5303357,1,1960,102,,,109,,,171,,,1001,,,32.7964,,,48,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
1501525,0,1952,95,,,114,,,157,,,1001,,,34.8087,,,58,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | wc       
 502630  502630 68394916
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'print $#F;' | sort | uniq -c                                                   501809 1929
    548 1930
    181 1931
     63 1932
     19 1933
      7 1934
      2 1935
      1 1938
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(eid|"21000\-|"21001\-|"21003\-|"22000\-|"22001\-|"22006\-|"22007\-|"22008\-|"22009\-|"22011\-|"22012\-|"22013\-|"31\-|"34\-|"48\-|"49\-|"50\-)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' | sed 's/"//g' | head -n 10
eid,31-0.0,34-0.0,48-0.0,48-1.0,48-2.0,49-0.0,49-1.0,49-2.0,50-0.0,50-1.0,50-2.0,21000-0.0,21000-1.0,21000-2.0,21001-0.0,21001-1.0,21001-2.0,21003-0.0,21003-1.0,21003-2.0,22000-0.0,22001-0.0,22006-0.0,22007-0.0,22008-0.0,22009-0.1,22009-0.2,22009-0.3,22009-0.4,22009-0.5,22009-0.6,22009-0.7,22009-0.8,22009-0.9,22009-0.10,22009-0.11,22009-0.12,22009-0.13,22009-0.14,22009-0.15,22011-0.0,22011-0.1,22011-0.2,22011-0.3,22011-0.4,22012-0.0,22012-0.1,22012-0.2,22012-0.3,22012-0.4,22013-0.0,22013-0.1,22013-0.2,22013-0.3,22013-0.4
1251407,1,1961,92,94,,107,108,,180.5,180,,1001,1001,,27.9924,29.5988,,46,51,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
5176998,1,1954,121,,,112,,,172,,,1001,,,37.1485,,,54,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
5303357,1,1960,102,,,109,,,171,,,1001,,,32.7964,,,48,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
1501525,0,1952,95,,,114,,,157,,,1001,,,34.8087,,,58,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
5849213,1,1940,107,,,104.5,,,163,,,1001,,,31.9922,,,67,,,-11,1,1,SMP4_0012187,H02,-5.15936,-3.58885,1.53065,-6.66753,11.8696,2.91714,-0.932745,-2.22673,3.03368,-3.45926,-1.19595,-2.97451,-2.48113,2.79418,0.664615,,,,,,,,,,,,,,,
4326944,0,1956,85,,,106,,,167,,,1001,,,29.1513,,,53,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
4579899,1,1966,102,,,102,,,174,,,1001,,,30.5523,,,43,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
3671144,0,1947,84,,,108,,,165,,,1001,,,26.0422,,,60,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
5606710,0,1959,72,,,87,,,165,,,1001,,,22.6263,,,49,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(eid|"21000\-|"21001\-|"21003\-|"22000\-|"22001\-|"22006\-|"22007\-|"22008\-|"22009\-|"22011\-|"22012\-|"22013\-|"31\-|"34\-|"48\-|"49\-|"50\-)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' | head -n 10
"eid","31-0.0","34-0.0","48-0.0","48-1.0","48-2.0","49-0.0","49-1.0","49-2.0","50-0.0","50-1.0","50-2.0","21000-0.0","21000-1.0","21000-2.0","21001-0.0","21001-1.0","21001-2.0","21003-0.0","21003-1.0","21003-2.0","22000-0.0","22001-0.0","22006-0.0","22007-0.0","22008-0.0","22009-0.1","22009-0.2","22009-0.3","22009-0.4","22009-0.5","22009-0.6","22009-0.7","22009-0.8","22009-0.9","22009-0.10","22009-0.11","22009-0.12","22009-0.13","22009-0.14","22009-0.15","22011-0.0","22011-0.1","22011-0.2","22011-0.3","22011-0.4","22012-0.0","22012-0.1","22012-0.2","22012-0.3","22012-0.4","22013-0.0","22013-0.1","22013-0.2","22013-0.3","22013-0.4"
"1251407","1","1961","92","94","","107","108","","180.5","180","","1001","1001","","27.9924","29.5988","","46","51","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
"5176998","1","1954","121","","","112","","","172","","","1001","","","37.1485","","","54","","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
"5303357","1","1960","102","","","109","","","171","","","1001","","","32.7964","","","48","","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
"1501525","0","1952","95","","","114","","","157","","","1001","","","34.8087","","","58","","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
"5849213","1","1940","107","","","104.5","","","163","","","1001","","","31.9922","","","67","","","-11","1","1","SMP4_0012187","H02","-5.15936","-3.58885","1.53065","-6.66753","11.8696","2.91714","-0.932745","-2.22673","3.03368","-3.45926","-1.19595","-2.97451","-2.48113","2.79418","0.664615","","","","","","","","","","","","","","",""
"4326944","0","1956","85","","","106","","","167","","","1001","","","29.1513","","","53","","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
"4579899","1","1966","102","","","102","","","174","","","1001","","","30.5523","","","43","","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
"3671144","0","1947","84","","","108","","","165","","","1001","","","26.0422","","","60","","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
"5606710","0","1959","72","","","87","","","165","","","1001","","","22.6263","","","49","","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(eid|"21000\-|"21001\-|"21003\-|"22000\-|"22001\-|"22006\-|"22007\-|"22008\-|"22009\-|"22011\-|"22012\-|"22013\-|"31\-|"34\-|"48\-|"49\-|"50\-)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' | head -n 20 | perl -F, -lane 'print $#F;' | sort | uniq -c
     20 55
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(eid|"21000\-|"21001\-|"21003\-|"22000\-|"22001\-|"22006\-|"22007\-|"22008\-|"22009\-|"22011\-|"22012\-|"22013\-|"31\-|"34\-|"48\-|"49\-|"50\-)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' | sed 's/"//g' | head -n 20 | perl -F, -lane 'print $#F;' | sort | uniq -c
     17 21
      2 40
      1 55
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'print $#F;' | sort | uniq -c
 502630 55
[  mturchin@login002  ~]$for i in {1..2}; do
>         val1=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | head -n 1 | perl -F, -slane 'print $F[$iBash];' -- -iBash=$i`
>         val2=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -slane 'if ($F[$iBash] !~ m/""/) { print $F[$iBash]; }' -- -iBash=$i | wc | awk '{ print $1 }'`
>
>         echo $i $val1 $val2
>
> done
1 "Sex-0.0" 502630
2 "Year_of_birth-0.0" 502630
[  mturchin@login002  ~]$for i in {37..39}; do
>         val1=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | head -n 1 | perl -F, -slane 'print $F[$iBash];' -- -iBash=$i`
>         val2=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -slane 'if ($F[$iBash] !~ m/""/) { print $F[$iBash]; }' -- -iBash=$i | wc | awk '{ print $1 }'`
>
>         echo $i $val1 $val2
>
> done
37 "Genetic_principal_components-0.12" 152725
38 "Genetic_principal_components-0.13" 152725
39 "Genetic_principal_components-0.14" 152725
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'print $F[1];' | sort | uniq -c
 273460 "0"
 229169 "1"
      1 "Sex-0.0"
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'print $F[12];' | sort | uniq -c
    899 ""
    217 "-1"
   1662 "-3"
    571 "1"
 442688 "1001"
  13213 "1002"
  16340 "1003"
     49 "2"
    620 "2001"
    425 "2002"
    831 "2003"
   1033 "2004"
     43 "3"
   5951 "3001"
   1837 "3002"
    236 "3003"
   1815 "3004"
     27 "4"
   4519 "4001"
   3396 "4002"
    123 "4003"
   1574 "5"
   4560 "6"
      1 "Ethnic_background-0.0"
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$for i in {0..55}; do
>         val1=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | head -n 1 | perl -F, -slane 'print $F[$iBash];' -- -iBash=$i`
>         val2=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -slane 'if ($F[$iBash] !~ m/""/) { print $F[$iBash]; }' -- -iBash=$i | wc | awk '{ print $1 }'`
>
>         echo $i $val1 $val2
>
> done
0 "eid" 502630
1 "Sex-0.0" 502630
2 "Year_of_birth-0.0" 502630
3 "Waist_circumference-0.0" 500470
4 "Waist_circumference-1.0" 20326
5 "Waist_circumference-2.0" 13206
6 "Hip_circumference-0.0" 500411
7 "Hip_circumference-1.0" 20321
8 "Hip_circumference-2.0" 13207
9 "Standing_height-0.0" 500091
10 "Standing_height-1.0" 20317
11 "Standing_height-2.0" 13205
12 "Ethnic_background-0.0" 501731
13 "Ethnic_background-1.0" 20340
14 "Ethnic_background-2.0" 11672
15 "Body_mass_index_(BMI)-0.0" 499525
16 "Body_mass_index_(BMI)-1.0" 20303
17 "Body_mass_index_(BMI)-2.0" 11886
18 "Age_when_attended_assessment_centre-0.0" 502630
19 "Age_when_attended_assessment_centre-1.0" 20003
20 "Age_when_attended_assessment_centre-2.0" 12552
21 "Genotype_measurement_batch-0.0" 502589
22 "Genetic_sex-0.0" 152725
23 "Genetic_ethnic_grouping-0.0" 120284
24 "Genotype_measurement_plate-0.0" 152725
25 "Genotype_measurement_well-0.0" 152725
26 "Genetic_principal_components-0.1" 152725
27 "Genetic_principal_components-0.2" 152725
28 "Genetic_principal_components-0.3" 152725
29 "Genetic_principal_components-0.4" 152725
30 "Genetic_principal_components-0.5" 152725
31 "Genetic_principal_components-0.6" 152725
32 "Genetic_principal_components-0.7" 152725
33 "Genetic_principal_components-0.8" 152725
34 "Genetic_principal_components-0.9" 152725
35 "Genetic_principal_components-0.10" 152725
36 "Genetic_principal_components-0.11" 152725
37 "Genetic_principal_components-0.12" 152725
38 "Genetic_principal_components-0.13" 152725
39 "Genetic_principal_components-0.14" 152725
40 "Genetic_principal_components-0.15" 152725
41 "Genetic_relatedness_pairing-0.0" 17308
42 "Genetic_relatedness_pairing-0.1" 1857
43 "Genetic_relatedness_pairing-0.2" 190
44 "Genetic_relatedness_pairing-0.3" 29
45 "Genetic_relatedness_pairing-0.4" 3
46 "Genetic_relatedness_factor-0.0" 17308
47 "Genetic_relatedness_factor-0.1" 1857
48 "Genetic_relatedness_factor-0.2" 190
49 "Genetic_relatedness_factor-0.3" 29
50 "Genetic_relatedness_factor-0.4" 3
51 "Genetic_relatedness_IBS0-0.0" 17308
52 "Genetic_relatedness_IBS0-0.1" 1857
53 "Genetic_relatedness_IBS0-0.2" 190
54 "Genetic_relatedness_IBS0-0.3" 29
55 "Genetic_relatedness_IBS0-0.4" 3
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], "\t", $F[1], "\t", $F[2], "\t", $age, "\t", $F[3], "\t", $F[6], "\t", $F[9], "\t", $F[12], "\t", $F[15], "\t", $F[18], "\t", $F[21];' | head -n 5
"eid"   "Sex-0.0"       "Year_of_birth-0.0"     2018    "Waist_circumference-0.0"       "Hip_circumference-0.0" "Standing_height-0.0"   "Ethnic_background-0.0" "Body_mass_index_(BMI)-0.0"     "Age_when_attended_assessment_centre-0.0"      "Genotype_measurement_batch-0.0"
"1251407"       "1"     "1961"  2018    "92"    "107"   "180.5" "1001"  "27.9924"       "46"    "2000"
"5176998"       "1"     "1954"  2018    "121"   "112"   "172"   "1001"  "37.1485"       "54"    "2000"
"5303357"       "1"     "1960"  2018    "102"   "109"   "171"   "1001"  "32.7964"       "48"    "2000"
"1501525"       "0"     "1952"  2018    "95"    "114"   "157"   "1001"  "34.8087"       "58"    "2000"
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], "\t", $F[1], "\t", $F[2], "\t", $age, "\t", $F[3], "\t", $F[6], "\t", $F[9], "\t", $F[12], "\t", $F[15], "\t", $F[18], "\t", $F[21];' | sed 's/"//g' | head -n 5
eid     Sex-0.0 Year_of_birth-0.0       2018    Waist_circumference-0.0 Hip_circumference-0.0   Standing_height-0.0     Ethnic_background-0.0   Body_mass_index_(BMI)-0.0       Age_when_attended_assessment_centre-0.0 Genotype_measurement_batch-0.0
1251407 1       1961    2018    92      107     180.5   1001    27.9924 46      2000
5176998 1       1954    2018    121     112     172     1001    37.1485 54      2000
5303357 1       1960    2018    102     109     171     1001    32.7964 48      2000
1501525 0       1952    2018    95      114     157     1001    34.8087 58      2000
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], "\t", $F[1], "\t", $F[2], "\t", $age, "\t", $F[3], "\t", $F[6], "\t", $F[9], "\t", $F[12], "\t", $F[15], "\t", $F[18], "\t", $F[21];' | sed 's/"//g' | perl -lane 'print $#F;' | sort | uniq -c
 498814 10
    365 5
   1655 6
     98 7
    526 8
   1172 9
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], "\t", $F[1], "\t", $F[2], "\t", $age, "\t", $F[3], "\t", $F[6], "\t", $F[9], "\t", $F[12], "\t", $F[15], "\t", $F[18], "\t", $F[21];' | perl -lane 'print $#F;' | sort | uniq -c
 502630 10
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], "\t", $F[1], "\t", $F[2], "\t", $age, "\t", $F[3], "\t", $F[6], "\t", $F[9], "\t", $F[12], "\t", $F[15], "\t", $F[18], "\t", $F[21];' | sed 's/"//g' | perl -lane 'if ($#F == 5) { print join("\t", @F); }' | head -n 5
1771417 1       1963    2018    46      2000
5949522 1       1948    2018    59      2000
3099432 0       1954    2018    54      2000
2349616 0       1947    2018    61      2000
4754372 1       1956    2018    52      2000
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], "\t", $F[1], "\t", $F[2], "\t", $age, "\t", $F[3], "\t", $F[6], "\t", $F[9], "\t", $F[12], "\t", $F[15], "\t", $F[18], "\t", $F[21];' | sed 's/"//g' | grep -E '1771417|5949522|3099432|2349616|4754372'
1771417 1       1963    2018                                            46      2000
5949522 1       1948    2018                                            59      2000
3099432 0       1954    2018                                            54      2000
2349616 0       1947    2018                                            61      2000
4754372 1       1956    2018                                            52      2000
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | head -n 5
"eid","Sex-0.0","Year_of_birth-0.0",2018,"Waist_circumference-0.0","Hip_circumference-0.0","Standing_height-0.0","Ethnic_background-0.0","Body_mass_index_(BMI)-0.0","Age_when_attended_assessment_centre-0.0","Genotype_measurement_batch-0.0"
"1251407","1","1961",2018,"92","107","180.5","1001","27.9924","46","2000"
"5176998","1","1954",2018,"121","112","172","1001","37.1485","54","2000"
"5303357","1","1960",2018,"102","109","171","1001","32.7964","48","2000"
"1501525","0","1952",2018,"95","114","157","1001","34.8087","58","2000"
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | sed 's/"//g' | head -n 5
eid,Sex-0.0,Year_of_birth-0.0,2018,Waist_circumference-0.0,Hip_circumference-0.0,Standing_height-0.0,Ethnic_background-0.0,Body_mass_index_(BMI)-0.0,Age_when_attended_assessment_centre-0.0,Genotype_measurement_batch-0.0
1251407,1,1961,2018,92,107,180.5,1001,27.9924,46,2000
5176998,1,1954,2018,121,112,172,1001,37.1485,54,2000
5303357,1,1960,2018,102,109,171,1001,32.7964,48,2000
1501525,0,1952,2018,95,114,157,1001,34.8087,58,2000
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | perl -F, -lane 'print $#F; | sort | uniq -c
> ^C
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | perl -F, -lane 'print $#F;' | sort | uniq -c
 502630 10
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | sed 's/"//g' | perl -F, -lane 'print $#F;' | sort | uniq -c
 502589 10
     41 9
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | sed 's/"//g' | perl -F, -lane 'if ($#F == 41) { print join(",", @F); }' | head -n 5
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | sed 's/"//g' | perl -F, -lane 'if ($#F == 9) { print join(",", @F); }' | head -n 5
4098943,0,1961,2018,86,105,168,1001,26.0771,47
2920100,0,1940,2018,93,100,158,1001,25.3966,68
5920959,1,1945,2018,96,105,167,1001,30.1553,63
3403302,0,1966,2018,94,108,170,1001,28.0623,42
1672299,0,1948,2018,75,95,161,1001,24.0346,61
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | sed 's/"//g' | perl -F, -lane 'if ($#F == 10) { print join(",", @F); }' | head -n 5
eid,Sex-0.0,Year_of_birth-0.0,2018,Waist_circumference-0.0,Hip_circumference-0.0,Standing_height-0.0,Ethnic_background-0.0,Body_mass_index_(BMI)-0.0,Age_when_attended_assessment_centre-0.0,Genotype_measurement_batch-0.0
1251407,1,1961,2018,92,107,180.5,1001,27.9924,46,2000
5176998,1,1954,2018,121,112,172,1001,37.1485,54,2000
5303357,1,1960,2018,102,109,171,1001,32.7964,48,2000
1501525,0,1952,2018,95,114,157,1001,34.8087,58,2000
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | grep -E '4098943|2920100|5920959|3403302|1672299'
"4098943","0","1961",2018,"86","105","168","1001","26.0771","47",""
"2920100","0","1940",2018,"93","100","158","1001","25.3966","68",""
"5920959","1","1945",2018,"96","105","167","1001","30.1553","63",""
"3403302","0","1966",2018,"94","108","170","1001","28.0623","42",""
"1672299","0","1948",2018,"75","95","161","1001","24.0346","61",""
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | grep -E '4098943|2920100|5920959|3403302|1672299' | sed 's/"//g'
4098943,0,1961,2018,86,105,168,1001,26.0771,47,
2920100,0,1940,2018,93,100,158,1001,25.3966,68,
5920959,1,1945,2018,96,105,167,1001,30.1553,63,
3403302,0,1966,2018,94,108,170,1001,28.0623,42,
1672299,0,1948,2018,75,95,161,1001,24.0346,61,
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | sed 's/"//g' | perl -F, -ane 'print $#F, "\n";' | sort | uniq -c
 502630 10
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $year1 = $F[2]; $year1 =~ tr/"//d; print $F[0], ",", $F[1], ",", $F[12], ",", $F[2], ",", $F[18], ",", 2018 - $year1, ",", $F[9], ",", $F[15], ",", $F[3], ",", $F[6], ",", $F[21];' | sed 's/"//g' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt 
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt | head -n 5 
eid,Sex-0.0,Ethnic_background-0.0,Year_of_birth-0.0,Age_when_attended_assessment_centre-0.0,2018,Standing_height-0.0,Body_mass_index_(BMI)-0.0,Waist_circumference-0.0,Hip_circumference-0.0,Genotype_measurement_batch-0.0
1251407,1,1001,1961,46,57,180.5,27.9924,92,107,2000
5176998,1,1001,1954,54,64,172,37.1485,121,112,2000
5303357,1,1001,1960,48,58,171,32.7964,102,109,2000
1501525,0,1001,1952,58,66,157,34.8087,95,114,2000
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | head -n 5
eid     eid     Sex-0.0 Ethnic_background-0.0   Age_when_attended_assessment_centre-0.0
1251407 1251407 1       British 46
5176998 5176998 1       British 54
5303357 5303357 1       British 48
1501525 1501525 0       British 58
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | awk '{ print $3 }' | sort | uniq -c
 273007 0
 228723 1
      1 Sex-0.0
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | awk '{ print $4 }' | sort | uniq -c
   3396 African
   1815 Any_other_Asian_background
    123 Any_other_Black_background
   1033 Any_other_mixed_background
  16340 Any_other_white_background
     43 Asian_or_Asian_British
    236 Bangladeshi
     27 Black_or_Black_British
 442688 British
   4519 Caribbean
   1574 Chinese
    217 Do_not_know
      1 Ethnic_background-0.0
   5951 Indian
  13213 Irish
     49 Mixed
   4560 Other_ethnic_group
   1837 Pakistani
   1662 Prefer_not_to_answer
    571 White
    831 White_and_Asian
    425 White_and_Black_African
    620 White_and_Black_Caribbean
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | head -n 5
FID     IID     SEX     ANCESTRY        AGE
1251407 1251407 1       British 46
5176998 5176998 1       British 54
5303357 5303357 1       British 48
1501525 1501525 0       British 58
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.txt | head -n 5
FID     IID     Height  BMI     Waist   Hip
1251407 1251407 180.5   27.9924 92      107
5176998 5176998 172     37.1485 121     112
5303357 5303357 171     32.7964 102     109
1501525 1501525 157     34.8087 95      114
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam | head -n 20
5482808 5482808 0 0 1 Batch_b001
1423779 1423779 0 0 2 Batch_b001
3069861 3069861 0 0 2 Batch_b001
3322840 3322840 0 0 2 Batch_b001
2016419 2016419 0 0 2 Batch_b001
3429631 3429631 0 0 1 Batch_b001
[  mturchin@login002  ~]$for i in `cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.Ancestries.txt`; do
>         echo $i;
>         cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | grep -w $i | awk '{ print $1 "\t" $2 }' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.${i}.FIDIIDs
> 
> done
ANCESTRY
African
Any_other_Asian_background
Any_other_Black_background
Any_other_mixed_background
Any_other_white_background
Asian_or_Asian_British
Bangladeshi
Black_or_Black_British
British
Caribbean
Chinese
Do_not_know
Indian
Irish
Mixed
Other_ethnic_group
Pakistani
Prefer_not_to_answer
White
White_and_Asian
White_and_Black_African
White_and_Black_Caribbean
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.
ukb9200.2017_8_WinterRetreat.Covars.ANCESTRY.FIDIIDs                    ukb9200.2017_8_WinterRetreat.Covars.Black_or_Black_British.FIDIIDs      ukb9200.2017_8_WinterRetreat.Covars.Pakistani.FIDIIDs
ukb9200.2017_8_WinterRetreat.Covars.African.FIDIIDs                     ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs                     ukb9200.2017_8_WinterRetreat.Covars.Prefer_not_to_answer.FIDIIDs
ukb9200.2017_8_WinterRetreat.Covars.Ancestries.txt                      ukb9200.2017_8_WinterRetreat.Covars.Caribbean.FIDIIDs                   ukb9200.2017_8_WinterRetreat.Covars.White.FIDIIDs
ukb9200.2017_8_WinterRetreat.Covars.Any_other_Asian_background.FIDIIDs  ukb9200.2017_8_WinterRetreat.Covars.Chinese.FIDIIDs                     ukb9200.2017_8_WinterRetreat.Covars.White_and_Asian.FIDIIDs
ukb9200.2017_8_WinterRetreat.Covars.Any_other_Black_background.FIDIIDs  ukb9200.2017_8_WinterRetreat.Covars.Do_not_know.FIDIIDs                 ukb9200.2017_8_WinterRetreat.Covars.White_and_Black_African.FIDIIDs
ukb9200.2017_8_WinterRetreat.Covars.Any_other_mixed_background.FIDIIDs  ukb9200.2017_8_WinterRetreat.Covars.Indian.FIDIIDs                      ukb9200.2017_8_WinterRetreat.Covars.White_and_Black_Caribbean.FIDIIDs
ukb9200.2017_8_WinterRetreat.Covars.Any_other_white_background.FIDIIDs  ukb9200.2017_8_WinterRetreat.Covars.Irish.FIDIIDs                       ukb9200.2017_8_WinterRetreat.Covars.txt
ukb9200.2017_8_WinterRetreat.Covars.Asian_or_Asian_British.FIDIIDs      ukb9200.2017_8_WinterRetreat.Covars.Mixed.FIDIIDs                       
ukb9200.2017_8_WinterRetreat.Covars.Bangladeshi.FIDIIDs                 ukb9200.2017_8_WinterRetreat.Covars.Other_ethnic_group.FIDIIDs          
#20171228
[  mturchin@node462  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$squeue --Format=jobid,partition,name,username,statecompact,starttime,timeused,numnodes,nodelist | head -n 10
JOBID               PARTITION           NAME                USER                ST                  START_TIME          TIME                NODES               NODELIST
18498392            batch                                   ssharm10            PD                  N/A                 0:00                4
18461427            batch               FRAGMENTS_100[16]   bsevilmi            PD                  N/A                 0:00                1
18461428            batch               FRAGMENTS_100[17]   bsevilmi            PD                  N/A                 0:00                1
18461429            batch               FRAGMENTS_100[18]   bsevilmi            PD                  N/A                 0:00                1
18461430            batch               FRAGMENTS_100[19]   bsevilmi            PD                  N/A                 0:00                1
18461431            batch               FRAGMENTS_100[20]   bsevilmi            PD                  N/A                 0:00                1
18461432            batch               FRAGMENTS_100[21]   bsevilmi            PD                  N/A                 0:00                1
18461433            batch               FRAGMENTS_100[22]   bsevilmi            PD                  N/A                 0:00                1
18461434            batch               FRAGMENTS_100[23]   bsevilmi            PD                  N/A                 0:00                1
[  mturchin@node463  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$for pheno1 in `echo "Height"`; do
>         for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>                 ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>                 ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
>                 echo $pheno1 $ancestry1 $ancestry2
> 
>                 for i in {1..22} X; do
>                         if [ ! -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.assoc.linear ]; then 
>                                 echo -e "\t" $i
>                         fi
>                 done
>         done
> done
Height African African
Height Any_other_white_background Any_other_white_background
Height British British
Height British British.Ran10000
Height British British.Ran100000
Height British British.Ran200000
Height Caribbean Caribbean
Height Indian Indian
Height Irish Irish
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/2017WinterHack/ukb_chr21_v2.British.Ran4000.ped | perl -lane 'print join("\t", @F[0..9]);' | head -n 10
5306119 5306119 0       0       2       -9      A       A       T       T
5459215 5459215 0       0       1       -9      A       A       T       T
2723077 2723077 0       0       2       -9      A       A       T       T
4357190 4357190 0       0       1       -9      A       A       T       T
2796634 2796634 0       0       1       -9      A       A       T       T
3270017 3270017 0       0       2       -9      A       A       T       T
3327488 3327488 0       0       1       -9      A       A       T       T
2001488 2001488 0       0       2       -9      A       A       T       T
2459402 2459402 0       0       1       -9      A       A       T       T
5523857 5523857 0       0       2       -9      A       A       T       T
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | grep 5459215
5459215 5459215 1       British 66
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | grep 2001488
2001488 2001488 0       British 56
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/2017WinterHack/ukb_chr21_v2.British.Ran4000.ped | awk '{ print $1 "\t" $5 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | awk '{ print $1 "\t" $3 }' | sort -k 1,1) | wc
   3907   11721   46884
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/2017WinterHack/ukb_chr21_v2.British.Ran4000.ped | wc
   3907 88649830 180126025
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/2017WinterHack/ukb_chr21_v2.British.Ran4000.ped | awk '{ print $1 "\t" $5 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | awk '{ print $1 "\t" $3 }' | sort -k 1,1) | head -n 10
1000254 1 1
1003024 1 1
1003681 2 0
1006073 2 0
1007485 1 1
1007736 1 1
1009728 2 0
1011305 1 1
1015310 2 0
1018866 1 1
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam | head -n 5
5482808 5482808 0 0 1 Batch_b001
1423779 1423779 0 0 2 Batch_b001
3069861 3069861 0 0 2 Batch_b001
3322840 3322840 0 0 2 Batch_b001
2016419 2016419 0 0 2 Batch_b001
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam | grep 1000254
1000254 1000254 0 0 1 UKBiLEVEAX_b1
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam | grep 1003681
1003681 1003681 0 0 2 Batch_b034
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.temp1.assoc.linear | head -n 10
 CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P 
  23      rs60075487    2699676    A        ADD     3099     0.1525       0.7321       0.4641
  23      rs60075487    2699676    A        AGE     3099    -0.2295       -16.09    5.152e-56
  23      rs60075487    2699676    A        SEX     3099      11.22        48.14            0
  23       rs2306736    2700027    C        ADD     3141     0.1219        0.637       0.5242
  23       rs2306736    2700027    C        AGE     3141    -0.2286       -16.17    1.456e-56
  23       rs2306736    2700027    C        SEX     3141      11.22        47.73            0
  23   Affx-92044070    2700151   AT        ADD     3111     -13.23       -2.111      0.03488
  23   Affx-92044070    2700151   AT        AGE     3111    -0.2283       -16.09    5.517e-56
  23   Affx-92044070    2700151   AT        SEX     3111      11.15        49.54            0
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.assoc.linear | head -n 10
 CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P 
  23      rs60075487    2699676    A        ADD     3099         NA           NA           NA
  23      rs60075487    2699676    A        SEX     3099         NA           NA           NA
  23      rs60075487    2699676    A        AGE     3099         NA           NA           NA
  23      rs60075487    2699676    A        SEX     3099         NA           NA           NA
  23       rs2306736    2700027    C        ADD     3141         NA           NA           NA
  23       rs2306736    2700027    C        SEX     3141         NA           NA           NA
  23       rs2306736    2700027    C        AGE     3141         NA           NA           NA
  23       rs2306736    2700027    C        SEX     3141         NA           NA           NA
  23   Affx-92044070    2700151   AT        ADD     3111         NA           NA           NA
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr1_v2.African.Height.temp1.assoc.linear | head -n 10
 CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P 
   1      rs28659788     723307    C        ADD        0         NA           NA           NA
   1      rs28659788     723307    C        AGE        0         NA           NA           NA
   1      rs28659788     723307    C        SEX        0         NA           NA           NA
   1     rs116587930     727841    A        ADD     2866     0.3683       0.3129       0.7543
   1     rs116587930     727841    A        AGE     2866    -0.2322       -15.93    7.872e-55
   1     rs116587930     727841    A        SEX     2866       11.3        48.72            0
   1     rs116720794     729632    T        ADD     3005      0.267       0.5391       0.5899
   1     rs116720794     729632    T        AGE     3005    -0.2291       -15.81    3.616e-54
   1     rs116720794     729632    T        SEX     3005      11.21        48.62            0
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr1_v2.African.Height.assoc.linear | head -n 10
 CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P 
   1      rs28659788     723307    C        ADD        0         NA           NA           NA
   1      rs28659788     723307    C        SEX        0         NA           NA           NA
   1      rs28659788     723307    C        AGE        0         NA           NA           NA
   1     rs116587930     727841    A        ADD     2866     0.3683       0.3129       0.7543
   1     rs116587930     727841    A        SEX     2866       11.3        48.72            0
   1     rs116587930     727841    A        AGE     2866    -0.2322       -15.93    7.872e-55
   1     rs116720794     729632    T        ADD     3005      0.267       0.5391       0.5899
   1     rs116720794     729632    T        SEX     3005      11.21        48.62            0
   1     rs116720794     729632    T        AGE     3005    -0.2291       -15.81    3.616e-54
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.temp1.assoc.linear | head -n 1546 | tail -n 10
  23     rs139127906    5192983    G        SEX     3033         NA           NA           NA
  23     rs149932678    5193109    C        ADD     3144    -0.2844     -0.06416       0.9489
  23     rs149932678    5193109    C        AGE     3144    -0.2288        -16.2    8.963e-57
  23     rs149932678    5193109    C        SEX     3144      11.18        49.92            0
  23       rs5961309    5203282    G        ADD     3141    -0.0281      -0.1518       0.8794
  23       rs5961309    5203282    G        AGE     3141    -0.2284       -16.18     1.33e-56
  23       rs5961309    5203282    G        SEX     3141      11.16        46.93            0
  23     rs150262381    5205074    C        ADD     3138     0.3212       0.2225        0.824
  23     rs150262381    5205074    C        AGE     3138    -0.2289       -16.17    1.601e-56
  23     rs150262381    5205074    C        SEX     3138      11.17        49.78            0
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.assoc.linear | head -n 1546 | tail -n 10
  23       rs1707492    4385969    G        SEX     3140         NA           NA           NA
  23       rs5915749    4388580    G        ADD     3132         NA           NA           NA
  23       rs5915749    4388580    G        SEX     3132         NA           NA           NA
  23       rs5915749    4388580    G        AGE     3132         NA           NA           NA
  23       rs5915749    4388580    G        SEX     3132         NA           NA           NA
  23       rs6638839    4388928    A        ADD     2703         NA           NA           NA
  23       rs6638839    4388928    A        SEX     2703         NA           NA           NA
  23       rs6638839    4388928    A        AGE     2703         NA           NA           NA
  23       rs6638839    4388928    A        SEX     2703         NA           NA           NA
  23     rs142163080    4424315    A        ADD     3113         NA           NA           NA
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr1_v2.African.Height.temp1.assoc.linear | head -n 1546 | tail -n 10
   1      rs12041925    1707740    G        SEX     3142      11.17        49.92            0
   1     rs116018620    1709119    T        ADD     3145      2.192        1.908      0.05648
   1     rs116018620    1709119    T        AGE     3145    -0.2284       -16.18    1.287e-56
   1     rs116018620    1709119    T        SEX     3145      11.18        49.94            0
   1      rs77787690    1712428    C        ADD     3144    -0.5953       -0.654       0.5132
   1      rs77787690    1712428    C        AGE     3144    -0.2295       -16.25    4.605e-57
   1      rs77787690    1712428    C        SEX     3144      11.18        49.95            0
   1     rs185462709    1720487    T        ADD     3145     0.4056       0.2885       0.7729
   1     rs185462709    1720487    T        AGE     3145    -0.2289       -16.21    7.842e-57
   1     rs185462709    1720487    T        SEX     3145      11.18        49.95            0
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr1_v2.African.Height.assoc.linear | head -n 1546 | tail -n 10
   1      rs12041925    1707740    G        AGE     3142      -0.23       -16.31    1.835e-57
   1     rs116018620    1709119    T        ADD     3145      2.192        1.908      0.05648
   1     rs116018620    1709119    T        SEX     3145      11.18        49.94            0
   1     rs116018620    1709119    T        AGE     3145    -0.2284       -16.18    1.287e-56
   1      rs77787690    1712428    C        ADD     3144    -0.5953       -0.654       0.5132
   1      rs77787690    1712428    C        SEX     3144      11.18        49.95            0
   1      rs77787690    1712428    C        AGE     3144    -0.2295       -16.25    4.605e-57
   1     rs185462709    1720487    T        ADD     3145     0.4056       0.2885       0.7729
   1     rs185462709    1720487    T        SEX     3145      11.18        49.95            0
   1     rs185462709    1720487    T        AGE     3145    -0.2289       -16.21    7.842e-57
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.temp1.assoc.linear | tail -n 10
  23        rs601290  154865915    A        SEX     3140      11.26         47.4            0
  23        rs473491  154899846    G        ADD     3132    -0.3918       -1.156       0.2479
  23        rs473491  154899846    G        AGE     3132    -0.2273       -16.07    6.487e-56
  23        rs473491  154899846    G        SEX     3132       11.2         49.8            0
  23     rs150522543  154900890    T        ADD     3135     0.6303       0.1423       0.8869
  23     rs150522543  154900890    T        AGE     3135    -0.2284       -16.14    2.266e-56
  23     rs150522543  154900890    T        SEX     3135      11.17        49.84            0
  23     rs111332691  154923374    A        ADD     3139    -0.1312      -0.0513       0.9591
  23     rs111332691  154923374    A        AGE     3139     -0.227       -16.08    5.338e-56
  23     rs111332691  154923374    A        SEX     3139      11.19        50.05            0
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.assoc.linear | tail -n 10
  23        rs473491  154899846    G        AGE     3132         NA           NA           NA
  23        rs473491  154899846    G        SEX     3132         NA           NA           NA
  23     rs150522543  154900890    T        ADD     3135         NA           NA           NA
  23     rs150522543  154900890    T        SEX     3135         NA           NA           NA
  23     rs150522543  154900890    T        AGE     3135         NA           NA           NA
  23     rs150522543  154900890    T        SEX     3135         NA           NA           NA
  23     rs111332691  154923374    A        ADD     3139         NA           NA           NA
  23     rs111332691  154923374    A        SEX     3139         NA           NA           NA
  23     rs111332691  154923374    A        AGE     3139         NA           NA           NA
  23     rs111332691  154923374    A        SEX     3139         NA           NA           NA
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr1_v2.African.Height.temp1.assoc.linear | tail -n 10
   1     rs150352847  249211879    A        SEX     3144         NA           NA           NA
   1      rs41308182  249212878    G        ADD     3108     -2.337       -2.102      0.03567
   1      rs41308182  249212878    G        AGE     3108    -0.2321       -16.34    1.142e-57
   1      rs41308182  249212878    G        SEX     3108      11.16        49.66            0
   1      rs74322946  249218540    A        ADD     3144     0.2623       0.1107       0.9119
   1      rs74322946  249218540    A        AGE     3144    -0.2295       -16.25    4.566e-57
   1      rs74322946  249218540    A        SEX     3144      11.17        49.89            0
   1     rs114152372  249222527    G        ADD     3112      1.903         1.09       0.2757
   1     rs114152372  249222527    G        AGE     3112    -0.2306       -16.23    6.133e-57
   1     rs114152372  249222527    G        SEX     3112      11.19        49.61            0
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr1_v2.African.Height.assoc.linear | tail -n 10
   1     rs150352847  249211879    A        AGE     3144         NA           NA           NA
   1      rs41308182  249212878    G        ADD     3108     -2.337       -2.102      0.03567
   1      rs41308182  249212878    G        SEX     3108      11.16        49.66            0
   1      rs41308182  249212878    G        AGE     3108    -0.2321       -16.34    1.142e-57
   1      rs74322946  249218540    A        ADD     3144     0.2623       0.1107       0.9119
   1      rs74322946  249218540    A        SEX     3144      11.17        49.89            0
   1      rs74322946  249218540    A        AGE     3144    -0.2295       -16.25    4.566e-57
   1     rs114152372  249222527    G        ADD     3112      1.903         1.09       0.2757
   1     rs114152372  249222527    G        SEX     3112      11.19        49.61            0
   1     rs114152372  249222527    G        AGE     3112    -0.2306       -16.23    6.133e-57
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$for pheno1 in `echo "Height BMI Waist Hip"`; do
> #for pheno1 in `echo "Height"`; do
> #for pheno1 in `echo "BMI Waist Hip"`; do
>         for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>                 ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>                 ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
> 
>                 echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
> 
>                 rm -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
>                 for i in {1..22} X; do
> 
>                         cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
> 
>                 done
> 
>                 cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped | sort -g -k 1,1 -k 4,4 | uniq | grep -v NSIG | grep -v ^$ | cat <(echo " CHR    F           SNP         BP        P    TOTAL   NSIG    S05    S01   S001  S0001    SP2") - > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.temp1
>                 mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.temp1 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
> 
>         done
> done
Height African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr19_v2.African.Height.ADD.assoc.linear.clumped: No such file or directory
Height Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.ADD.assoc.linear.clumped
Height British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrX_v2.British.Height.ADD.assoc.linear.clumped: No such file or directory
Height British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrX_v2.British.Ran10000.Height.ADD.assoc.linear.clumped: No such file or directory
Height British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrX_v2.British.Ran100000.Height.ADD.assoc.linear.clumped: No such file or directory
Height British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrX_v2.British.Ran200000.Height.ADD.assoc.linear.clumped: No such file or directory
Height Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chr22_v2.Caribbean.Height.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrX_v2.Caribbean.Height.ADD.assoc.linear.clumped: No such file or directory
Height Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrX_v2.Indian.Height.ADD.assoc.linear.clumped: No such file or directory
Height Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrX_v2.Irish.Height.ADD.assoc.linear.clumped: No such file or directory
BMI African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrX_v2.British.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrX_v2.British.Ran10000.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrX_v2.British.Ran100000.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrX_v2.British.Ran200000.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrX_v2.Caribbean.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrX_v2.Indian.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chr21_v2.Irish.BMI.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrX_v2.Irish.BMI.ADD.assoc.linear.clumped: No such file or directory
Waist African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr13_v2.African.Waist.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr22_v2.Any_other_white_background.Waist.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrX_v2.British.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrX_v2.British.Ran10000.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrX_v2.British.Ran100000.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrX_v2.British.Ran200000.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chr14_v2.Caribbean.Waist.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chr20_v2.Caribbean.Waist.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrX_v2.Caribbean.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrX_v2.Indian.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrX_v2.Irish.Waist.ADD.assoc.linear.clumped: No such file or directory
Hip African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrX_v2.British.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrX_v2.British.Ran10000.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrX_v2.British.Ran100000.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrX_v2.British.Ran200000.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrX_v2.Caribbean.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrX_v2.Indian.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chr21_v2.Irish.Hip.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrX_v2.Irish.Hip.ADD.assoc.linear.clumped: No such file or directory
...
Height British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr21_v2.British.Ran4000.Height.ADD.assoc.linear.clumped: No such file or directory
BMI British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.BMI.ADD.assoc.linear.clumped
Waist British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Waist.ADD.assoc.linear.clumped
Hip British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Hip.ADD.assoc.linear.clumped
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | wc
   7002   84024 1049612
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped | wc
     81     972   11021
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped | wc
    149    1788   24644
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped | wc
   2057   24684  354566
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped | wc
   4847   58164  771603
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped | wc
    131    1572   13800
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped | wc
    154    1848   16587
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped | wc
   1352   16224  185798
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped | wc
    240    2880   37655
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.ADD.assoc.linear.clumped | wc
  31630  379560 3982400
#From later in the day:
#[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear.clumped | wc
#     78     912   12923
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear | grep ADD | grep -v NA | sort -g -k 9,9 | head -n 10
   6       rs2256175   31380449    C        ADD    15725      1.283        17.41    3.027e-67
   6       rs2596531   31387557    C        ADD    15709      1.238        16.19    1.702e-58
   6       rs2596530   31387373    G        ADD    15705      1.232        16.11    6.487e-58
   6       rs2256183   31380529    A        ADD    15561      1.238        16.03    2.217e-57
   6   Affx-28452229   31322303    G        ADD    15734     -1.186       -15.97    5.878e-57
   6      rs67841474   31380160   TG        ADD    14926      1.221        15.84    4.814e-56
   6        rs537160   31916400    A        ADD    15691      1.313        15.55    3.754e-54
   6       rs2844513   31388214    A        ADD    15678     -1.095       -14.64    3.043e-48
   6       rs2844514   31380340    T        ADD    15687     -1.096       -14.64    3.178e-48
   6        rs630379   31922254    A        ADD    15694      1.292        14.62    4.416e-48
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | sort -g -k 9,9 | head -n 10
   6      rs41271299   19839415    T        ADD   428962     0.8564        27.51   2.065e-166
   6       rs6570507  142679572    A        ADD   429196    -0.3922       -25.77   2.486e-146
   6       rs7776375  142777064    G        ADD   428707    -0.3858       -25.35   1.211e-141
   6       rs3748069  142767633    G        ADD   425265    -0.3844       -25.22   3.393e-140
   6       rs7763064  142797289    A        ADD   428723    -0.3769       -24.98   1.416e-137
   6       rs7742369   34165721    G        ADD   429011     0.4481         24.8   1.104e-135
   6       rs7766641   26184102    A        ADD   421986    -0.3948       -24.69   1.649e-134
   6        rs806794   26200677    G        ADD   429099    -0.3813       -24.68   2.118e-134
   6        rs262121  142839498    C        ADD   428622    -0.3703       -24.48   3.265e-132
   6       rs2050157  142658162    A        ADD   382230    -0.3941       -24.45   6.076e-132
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | if ($9 < 5e-8) { print $0 } } ' | wc
bash: syntax error near unexpected token `{'
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | awk '{ if ($9 < 5e-8) { print $0 } } ' | wc
   4077   36693  383504
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear | grep ADD | grep -v NA | awk '{ if ($9 < 5e-8) { print $0 } } ' | wc
   2768   24912  260433
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear | grep ADD | grep -v NA | awk '{ if ($9 < 5e-2) { print $0 } } ' | wc
  22485  202365 2113841
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | awk '{ if ($9 < 5e-2) { print $0 } } ' | wc
  17949  161541 1687475
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear | grep ADD | grep -v NA | awk '{ if ($9 < 5e-4) { print $0 } } ' | wc
   9158   82422  861093
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | awk '{ if ($9 < 5e-4) { print $0 } } ' | wc
   7948   71532  747380
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10] 
             0              0              7            180           1312 
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05] 
           366            471            629            884           1259 
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1] 
          1972           3305           5625          10462          25932 
> 
> 
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10] 
            33             22            116            634           2309 
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05] 
           299            360            464            539            775 
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1] 
          1138           1969           3833           9348          31759 
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.ADD.assoc.linear.clumped | awk '{ print $6 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,10,25,50,100,250,500,1000)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,10,25,50,100,250,500,1000)));

     (0,10]     (10,25]     (25,50]    (50,100]   (100,250]   (250,500] 
       1455         195          46          26          16           4 
(500,1e+03] 
          0 
> 
> 
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $6 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,10,25,50,100,250,500,1000)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,10,25,50,100,250,500,1000)));

     (0,10]     (10,25]     (25,50]    (50,100]   (100,250]   (250,500] 
        153          41          21          25          14           4 
(500,1e+03] 
          1 
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr6_v2.British.Ran4000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print
 $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              0              0              0              0
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
             0              0              0              0              1
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
             3             65            514           5034          45825
>
>
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chr6_v2.British.Ran10000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10] 
             0              0              0              0              0 
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05] 
             0              0              0              0              4 
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1] 
            39            208            823           5655          45223 
> 
> 
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chr6_v2.British.Ran100000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10] 
             0              0              0             19            252 
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05] 
            67            112            215            312            518 
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1] 
           644            970           2343           7783          39969 
> 
> 
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chr6_v2.British.Ran200000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              1             20            123           1143
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
           288            281            310            384            610
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
           779           1211           2884           8626          36800
>
>
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              0              0              0              0
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
             0              0              0              0              1
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
            20            153            804           5784          45642
>
>
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              0              0             17            237
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
           135            217            269            370            532
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
           856           1291           2679           8657          38338
>
>
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr6_v2.British.Ran4000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              0              0              0              0
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
             0              0              0              0              1
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
             5             71            509           4393          46463
>
>
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chr6_v2.British.Ran10000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              0              0              0              0
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
             0              0              0              0              1
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
             7             64            524           4598          46758
>
>
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chr6_v2.British.Ran100000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              0              0              0              5
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
             5              5              2             10             22
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
           102            333           1505           6914          44301
>
>
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chr6_v2.British.Ran200000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              0              0              0             25
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
            12             16             48            102            168
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
           375            820           2198           7787          41909
>
>
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.assoc.linear | grep ADD | grep -v NA | sort -g -k 9,9 | head -n 10
   2       rs7570971  135837906    C        ADD     3968      1.736        12.55    1.862e-35
  15       rs1129038   28356859    C        ADD     3983     -1.881       -12.35    2.071e-34
   2       rs4988235  136608646    A        ADD     3600      1.763         12.3    4.103e-34
   2       rs1446585  136407479    G        ADD     3978     -1.706       -12.29    4.238e-34
  15      rs12913832   28365618    A        ADD     3963     -1.874       -12.23    8.423e-34
   2       rs6754311  136707982    T        ADD     3617      1.699        11.84    9.586e-32
   2      rs12465802  136381348    G        ADD     3617      1.689        11.72    3.487e-31
   2       rs6730157  135907088    A        ADD     3601      1.681        11.62    1.174e-30
   2        rs309125  136643555    T        ADD     3975     -1.655       -11.52    3.077e-30
   2       rs6716536  136787402    T        ADD     3968     -1.648       -11.47    5.687e-30
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr*_v2.British.Ran4000.Height.ADD.assoc.linear | grep ADD | grep -v NA | sort -g -k 9,9 | head -n 10
   1      rs33998267  235993709    A        ADD     3873      2.769        5.504    3.949e-08
   7        rs849141   28185091    A        ADD     3869     0.7921        5.037     4.95e-07
   7        rs520161   28210660    T        ADD     3873     0.7809        5.004    5.874e-07
  20       rs2876163    9174693    A        ADD     3862      -1.18       -4.905    9.711e-07
   7       rs1708299   28189946    A        ADD     3878     0.7583        4.872     1.15e-06
   7       rs6944291    2745394    C        ADD     3869    -0.7003       -4.833    1.399e-06
  23      rs10284225   33254938    C        ADD     3877      1.976        4.761        2e-06
   7      rs10257934    2749790    G        ADD     3871    -0.7565        -4.72    2.438e-06
  17       rs2003549   62008437    T        ADD     3872     0.7768         4.68    2.964e-06
   8       rs1460590  113005023    T        ADD     3874    -0.6738       -4.668    3.146e-06
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | sed 's/:/ /g' | awk '{ print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 }' | sort -k 1,1) | wc
   3954   59310  486180
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | wc
   3955   47459  620900
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | sed 's/:/ /g' | awk '{ print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 }' | sort -k 1,1) | head -n 10
1000329 1000329 1 Any_other_white_background 42 0.0099 -0.0075 -0.0031 0.0119 0.0001 -0.0020 -0.0008 0.0291 -0.0133 -0.0005
1000648 1000648 1 Any_other_white_background 58 0.0122 0.0222 0.0367 -0.0830 -0.0013 -0.0199 0.0121 -0.0093 -0.0012 0.0103
1002391 1002391 1 Any_other_white_background 61 -0.0050 -0.0059 -0.0139 -0.0049 0.0130 0.0127 -0.0138 -0.0151 0.0190 0.0433
1006367 1006367 0 Any_other_white_background 64 0.0072 -0.0129 -0.0010 0.0059 -0.0038 -0.0284 -0.0084 -0.0036 0.0079 0.0034
1007157 1007157 0 Any_other_white_background 51 -0.0066 0.0004 -0.0023 0.0098 0.0144 -0.0123 0.0154 -0.0109 0.0061 0.0082
1007351 1007351 0 Any_other_white_background 67 0.0105 -0.0033 -0.0018 0.0188 0.0229 0.0271 0.0030 0.0081 0.0035 0.0060
1007717 1007717 0 Any_other_white_background 40 0.0152 -0.0185 0.0219 -0.0142 -0.0013 0.0091 0.0073 0.0216 -0.0129 -0.0072
1007811 1007811 1 Any_other_white_background 53 0.0121 -0.0233 0.0049 0.0014 0.0246 -0.0114 -0.0061 0.0036 0.0106 -0.0161
1007941 1007941 0 Any_other_white_background 69 0.0020 -0.0014 -0.0134 0.0038 0.0322 -0.0342 -0.0027 0.0083 -0.0086 0.0046
1008510 1008510 0 Any_other_white_background 45 -0.0086 0.0074 -0.0058 -0.0094 -0.0099 0.0087 -0.0058 0.0065 -0.0174 -0.0047
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | sed 's/:/ /g' | awk '{ print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 }' | sort -k 1,1) | cat <(echo -e "FID     IID     SEX     ANCESTRY        AGE\tPC1\tPC2\tPC3\tPC4\tPC5\tPC6\tPC7\tPC8\tPC9\tPC10") - | head -n 10
FID     IID     SEX     ANCESTRY        AGE     PC1     PC2     PC3     PC4     PC5     PC6     PC7     PC8     PC9     PC10
1000329 1000329 1 Any_other_white_background 42 0.0099 -0.0075 -0.0031 0.0119 0.0001 -0.0020 -0.0008 0.0291 -0.0133 -0.0005
1000648 1000648 1 Any_other_white_background 58 0.0122 0.0222 0.0367 -0.0830 -0.0013 -0.0199 0.0121 -0.0093 -0.0012 0.0103
1002391 1002391 1 Any_other_white_background 61 -0.0050 -0.0059 -0.0139 -0.0049 0.0130 0.0127 -0.0138 -0.0151 0.0190 0.0433
1006367 1006367 0 Any_other_white_background 64 0.0072 -0.0129 -0.0010 0.0059 -0.0038 -0.0284 -0.0084 -0.0036 0.0079 0.0034
1007157 1007157 0 Any_other_white_background 51 -0.0066 0.0004 -0.0023 0.0098 0.0144 -0.0123 0.0154 -0.0109 0.0061 0.0082
1007351 1007351 0 Any_other_white_background 67 0.0105 -0.0033 -0.0018 0.0188 0.0229 0.0271 0.0030 0.0081 0.0035 0.0060
1007717 1007717 0 Any_other_white_background 40 0.0152 -0.0185 0.0219 -0.0142 -0.0013 0.0091 0.0073 0.0216 -0.0129 -0.0072
1007811 1007811 1 Any_other_white_background 53 0.0121 -0.0233 0.0049 0.0014 0.0246 -0.0114 -0.0061 0.0036 0.0106 -0.0161
1007941 1007941 0 Any_other_white_background 69 0.0020 -0.0014 -0.0134 0.0038 0.0322 -0.0342 -0.0027 0.0083 -0.0086 0.0046
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | sed 's/:/ /g' | awk '{ print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 }' | sort -k 1,1) | cat <(echo -e "FID\tIID\tSEX\tANCESTRY\tAGE\tPC1\tPC2\tPC3\tPC4\tPC5\tPC6\tPC7\tPC8\tPC9\tPC10") - | head -n 10  
FID     IID     SEX     ANCESTRY        AGE     PC1     PC2     PC3     PC4     PC5     PC6     PC7     PC8     PC9     PC10
1000329 1000329 1 Any_other_white_background 42 0.0099 -0.0075 -0.0031 0.0119 0.0001 -0.0020 -0.0008 0.0291 -0.0133 -0.0005
1000648 1000648 1 Any_other_white_background 58 0.0122 0.0222 0.0367 -0.0830 -0.0013 -0.0199 0.0121 -0.0093 -0.0012 0.0103
1002391 1002391 1 Any_other_white_background 61 -0.0050 -0.0059 -0.0139 -0.0049 0.0130 0.0127 -0.0138 -0.0151 0.0190 0.0433
1006367 1006367 0 Any_other_white_background 64 0.0072 -0.0129 -0.0010 0.0059 -0.0038 -0.0284 -0.0084 -0.0036 0.0079 0.0034
1007157 1007157 0 Any_other_white_background 51 -0.0066 0.0004 -0.0023 0.0098 0.0144 -0.0123 0.0154 -0.0109 0.0061 0.0082
1007351 1007351 0 Any_other_white_background 67 0.0105 -0.0033 -0.0018 0.0188 0.0229 0.0271 0.0030 0.0081 0.0035 0.0060
1007717 1007717 0 Any_other_white_background 40 0.0152 -0.0185 0.0219 -0.0142 -0.0013 0.0091 0.0073 0.0216 -0.0129 -0.0072
1007811 1007811 1 Any_other_white_background 53 0.0121 -0.0233 0.0049 0.0014 0.0246 -0.0114 -0.0061 0.0036 0.0106 -0.0161
1007941 1007941 0 Any_other_white_background 69 0.0020 -0.0014 -0.0134 0.0038 0.0322 -0.0342 -0.0027 0.0083 -0.0086 0.0046
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | grep 1000329
     1000329:1000329     0.0099     -0.0075     -0.0031      0.0119      0.0001     -0.0020     -0.0008      0.0291     -0.0133     -0.0005          Control
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | grep 1000648
     1000648:1000648     0.0122      0.0222      0.0367     -0.0830     -0.0013     -0.0199      0.0121     -0.0093     -0.0012      0.0103          Control
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear | grep -v NA | sort -g -k 9,9 | head -n 10
 CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P
   2      rs10184951  128897703    C        ADD     3570     0.7349        4.841    1.349e-06
   2      rs10184951  128897703    C        ADD     3570     0.7349        4.841    1.349e-06
  12     rs117743355   93986948    A        ADD     3935      3.395        4.706    2.607e-06
  12     rs117743355   93986948    A        ADD     3935      3.395        4.706    2.607e-06
  12     rs117941140   74245886    A        ADD     3935     -2.342       -4.705    2.632e-06
  12     rs117941140   74245886    A        ADD     3935     -2.342       -4.705    2.632e-06
   6      rs12198986    7720059    A        ADD     3935     0.6566        4.618        4e-06
   6      rs12198986    7720059    A        ADD     3935     0.6566        4.618        4e-06
  20      rs73125296   40351173    T        ADD     3927      1.274        4.609     4.17e-06
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr*_v2.Any_other_white_background.Height.ADD.assoc.linear | grep ADD | grep -v NA | sort -g -k 9,9 | head -n 10
  15     rs1129038   28356859    C        ADD    15730     -1.764       -23.02   2.359e-115
  15    rs12913832   28365618    A        ADD    15660     -1.749       -22.72   1.968e-112
   2       rs7570971  135837906    C        ADD    15680      1.548        22.16   3.487e-107
   2       rs4988235  136608646    A        ADD    14154      1.587        21.66   2.218e-102
   2       rs1446585  136407479    G        ADD    15711     -1.508        -21.5   4.455e-101
   2      rs12465802  136381348    G        ADD    14211      1.561         21.3    4.007e-99
   2       rs6754311  136707982    T        ADD    14214      1.555        21.29    4.652e-99
   2       rs6730157  135907088    A        ADD    14167      1.544        21.01    1.423e-96
   2       rs6716536  136787402    T        ADD    15687     -1.453       -20.11    8.381e-89
   2       rs4452212  137015991    A        ADD    15700      1.452         20.1    9.679e-89
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr*_v2.British.Ran4000.Height.ADD.assoc.linear | grep ADD | grep -v NA | sort -g -k 9,9 | head -n 10
   1      rs33998267  235993709    A        ADD     3873      2.769        5.504    3.949e-08
   7        rs849141   28185091    A        ADD     3869     0.7921        5.037     4.95e-07
   7        rs520161   28210660    T        ADD     3873     0.7809        5.004    5.874e-07
  20       rs2876163    9174693    A        ADD     3862      -1.18       -4.905    9.711e-07
   7       rs1708299   28189946    A        ADD     3878     0.7583        4.872     1.15e-06
   7       rs6944291    2745394    C        ADD     3869    -0.7003       -4.833    1.399e-06
  23      rs10284225   33254938    C        ADD     3877      1.976        4.761        2e-06
   7      rs10257934    2749790    G        ADD     3871    -0.7565        -4.72    2.438e-06
  17       rs2003549   62008437    T        ADD     3872     0.7768         4.68    2.964e-06
   8       rs1460590  113005023    T        ADD     3874    -0.6738       -4.668    3.146e-06
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr*_v2.African.Height.ADD.assoc.linear | grep ADD | grep -v NA | sort -g -k 9,9 | head -n 10
   4     rs115499719   85673984    G        ADD     3123      7.022        5.731    1.096e-08
   4      rs76512887   45839725    G        ADD     3145      6.918        5.064    4.332e-07
  14    rs77258689   29383787    T        ADD     3143      12.77        5.008    5.792e-07
   2     rs114846158   22672732    A        ADD     3119      8.912         4.94    8.225e-07
   7      rs73112189   46268024    A        ADD     3144      21.43        4.854    1.269e-06
   7        rs740091    9124433    A        ADD     3144       1.17        4.836    1.387e-06
   4     rs114447473  165302850    G        ADD     3143      13.49        4.822    1.491e-06
  14    rs74815549   95350999    G        ADD     3139     0.8471        4.788    1.766e-06
   5      rs72705201    1016654    T        ADD     3028      5.069        4.658    3.332e-06
   1      rs11805978  240251226    C        ADD     3140     -0.827       -4.627    3.862e-06
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | wc
   7002   84024 1049612
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped | wc
     81     972   11021
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped | wc
    149    1788   24644
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped | wc
   2057   24684  354566
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped | wc
   4847   58164  771603
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped | wc
    131    1572   13800
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped | wc
    154    1848   16587
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped | wc
   1352   16224  185798
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped | wc
    240    2880   37655
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
      5       5      44
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
     20      20     206
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
    654     654    6879
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
   1779    1779   18899
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
      2       2      14
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
      3       3      24
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
     26      26     269
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
     24      24     244
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
      1       1       4
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v CHR | head -n 10
1       958905  958905  rs2710890
1       987200  987200  rs9803031
1       1301388 1301388 rs71628956
1       1490161 1490161 rs3753332
1       1585642 1585642 rs3936009
1       1905790 1905790 rs16824603
1       1983421 1983421 rs4648795
1       2060058 2060058 rs28719902
1       2113565 2113565 rs262688
1       2127674 2127674 rs115785083
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat <(paste <(echo "Brit.Ran4k") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -b /users/mtur...
Brit.Ran4k      80      4       15      34      46      50
Brit.Ran10k     148     19      31      57      78      80
Brit.Ran100k    2056    653     824     1040    1161    1182
Brit.Ran200k    4846    1778    2028    2408    2626    2667
African 130     1       8       21      46      55
Caribbean       153     2       9       24      56      67
Indian  1351    25      123     302     584     696
Irish   239     23      57      95      123     136
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(echo "Afr_v_Caribbean") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbio...
Afr_v_Caribbean 153     0       0       1       7       12
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.clumped.AllPopComps      
Height                                                                                                                                                                                                                         
                                                                                                                                                                                                                               British.Ran4000 80      4       15      34      46      50                                                                                                                                                                     British.Ran10000        148     19      31      57      78      80                                                                                                                                                             British.Ran100000       2056    653     824     1040    1161    1182                                                                                                                                                           British.Ran200000       4846    1778    2028    2408    2626    2667                                                                                                                                                           African 130     1       8       21      46      55                                                                                                                                                                             Caribbean       153     2       9       24      56      67                                                                                                                                                                     Indian  1351    25      123     302     584     696                                                                                                                                                                            Irish   239     23      57      95      123     136                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          BMI                                                                                                                                                                                                                             
British.Ran4000 168     1       9       24      74      108
British.Ran10000        162     2       15      34      86      115
British.Ran100000       565     194     246     336     457     496
British.Ran200000       1386    722     810     1025    1242    1305
African 1946    22      77      268     875     1283
Caribbean       266     2       9       38      123     176
Indian  250     3       13      36      105     157
Irish   190     5       21      49      105     135


#Waist
#
#British.Ran4000 103     2       6       13      41      55
#British.Ran10000        108     1       8       18      40      61
#British.Ran100000       425     148     176     238     320     352
#British.Ran200000       1020    516     585     713     882     934
#African 113     0       6       13      40      60
#Caribbean       119     0       3       11      47      67
#Indian  183     0       7       23      77      103
#Irish   135     2       11      23      56      84
#
#
#Hip
#
#British.Ran4000 190     1       9       27      81      114
#British.Ran10000        172     2       8       25      65      106
#British.Ran100000       552     175     224     307     432     477
#British.Ran200000       1167    592     683     851     1028    1078
#African 358     1       10      30      124     198
#Caribbean       173     0       5       28      72      113
#Indian  278     0       7       36      102     151
#Irish   172     1       10      35      84      112
(MultiEthnicGWAS) [  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | head -n 10
  CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P 
1       Affx-10000328   39542062        G       ADD     3877    -0.1765 -0.3424 0.7321
1       Affx-10047176   39917888        A       ADD     3877    0.1098  0.3073  0.7586
1       Affx-10071327   40092089        T       ADD     423     -2.211  -1.273  0.2038
1       Affx-10080353   40160585        A       ADD     3875    0.09407 0.4949  0.6207
1       Affx-10096385   40773149        C       ADD     3853    -0.1205 -0.6912 0.4895
1       Affx-10134350   41256213        G       ADD     3722    -0.1502 -0.6808 0.4961
1       Affx-10349342   43131653        A       ADD     3872    0.04474 0.2001  0.8414
1       Affx-10384750   43394887        A       ADD     3880    21.3    3.385   0.0007193
1       Affx-10384852   43395635        T       ADD     3865    0.1908  1.054   0.292
(MultiEthnicGWAS) [  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | perl -lane 'if ($F[8] < 5e-4) { print join("\t", @F); }' | grep -v NA | wc
    485    4365   27439
(MultiEthnicGWAS) [  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | perl -lane 'if ($F[8] < 5e-4) { print join("\t", @F); }' | grep -v NA | head -n 10
CHR     SNP     BP      A1      TEST    NMISS   BETA    STAT    P
1       Affx-80210901   20645219        A       ADD     3881    -24.39  -3.88   0.000106
1       Affx-92044118   17350516        C       ADD     3425    16.27   4.463   8.337e-06
1       rs10888315      248348194       G       ADD     3870    -0.5247 -3.506  0.0004596
1       rs113592356     1004331 T       ADD     3879    -1.172  -3.54   0.0004053
1       rs114257724     245336818       A       ADD     3877    2.496   3.679   0.0002376
1       rs114383419     24844069        T       ADD     3875    1.345   3.548   0.0003925
1       rs114479443     220769097       A       ADD     3877    -2.863  -3.645  0.0002708
1       rs11572510      217093153       C       ADD     3877    0.9267  3.895   9.976e-05
1       rs12088804      231436654       G       ADD     3873    1.853   3.788   0.0001542
(MultiEthnicGWAS) [  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | perl -lane 'if ($F[8] < 5e-4) { print join("\t", @F); }' | grep -v NA | sort -g -k 9,9 | head -n 10
CHR     SNP     BP      A1      TEST    NMISS   BETA    STAT    P
1       rs33998267      235993709       A       ADD     3873    2.769   5.504   3.949e-08
7       rs849141        28185091        A       ADD     3869    0.7921  5.037   4.95e-07
7       rs520161        28210660        T       ADD     3873    0.7809  5.004   5.874e-07
20      rs2876163       9174693 A       ADD     3862    -1.18   -4.905  9.711e-07
7       rs1708299       28189946        A       ADD     3878    0.7583  4.872   1.15e-06
7       rs6944291       2745394 C       ADD     3869    -0.7003 -4.833  1.399e-06
23      rs10284225      33254938        C       ADD     3877    1.976   4.761   2e-06
7       rs10257934      2749790 G       ADD     3871    -0.7565 -4.72   2.438e-06
17      rs2003549       62008437        T       ADD     3872    0.7768  4.68    2.964e-06
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.ashr.results.gz | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(-log10(2*pnorm(abs(Data1\$betahat) / Data1\$sebetahat, lower.tail=FALSE)), c(0,1,2,3,4,5,7,10,50,100))); table(cut(-log10(2*pnorm(abs(Data1\$PosteriorMean) / Data1\$PosteriorSD, lower.tail=FALSE)), c(0,1,2,3,4,5,7,10,50,100)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(-log10(2*pnorm(abs(Data1$betahat) / Data1$sebetahat, lower.tail=FALSE)), c(0,1,2,3,4,5,7,10,50,100))); table(cut(-log10(2*pnorm(abs(Data1$PosteriorMean) / Data1$PosteriorSD, lower.tail=FALSE)), c(0,1,2,3,4,5,7,10,50,100)));

   (0,1]    (1,2]    (2,3]    (3,4]    (4,5]    (5,7]   (7,10]  (10,50] 
  661051    73259     8392     1224      210       82       16        0 
(50,100] 
       0 

   (0,1]    (1,2]    (2,3]    (3,4]    (4,5]    (5,7]   (7,10]  (10,50] 
  744109       63       23       11        7       10        4        7 
(50,100] 
       0 
> 
> 
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.ashr.results.gz | R -q -e "Data1 <- read.table(file('stdin'), header=T); nrow(Data1[Data1\$PosteriorMean > Data1\$betahat,]); nrow(Data1[Data1\$PosteriorMean < Data1\$betahat,]); quantile(Data1\$PosteriorMean - Data1\$betahat, na.rm=TRUE);"
> Data1 <- read.table(file('stdin'), header=T); nrow(Data1[Data1$PosteriorMean > Data1$betahat,]); nrow(Data1[Data1$PosteriorMean < Data1$betahat,]); quantile(Data1$PosteriorMean - Data1$betahat, na.rm=TRUE);
[1] 430970
[1] 430984
           0%           25%           50%           75%          100% 
-2.691896e+01 -1.306974e-01 -2.127500e-06  1.305210e-01  2.425907e+01 
> 
> 
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.ashr.results.gz | head -n 10
betahat sebetahat NegativeProb PositiveProb lfsr svalue lfdr qvalue PosteriorMean PosteriorSD
-0.2082 0.316310029612608 0.105064286700532 0.0774547708043533 0.894935713299468 0.747663534110751 0.817480942495115 0.797407434449884 -0.00289189233121574 0.0377938777536834
0.1906 0.222664595664309 0.066774711492263 0.115523212765579 0.884476787234421 0.700512727823062 0.817702075742158 0.797725923595555 0.00495449881520096 0.0372661174930877
-1.565 1.07461529486516 0.102830329008621 0.083788459776858 0.897169670991379 0.757427682006018 0.813381211214521 0.777695586667837 -0.00209183974882314 0.0395811913370459
0.2518 0.12228974699646 0.0275003353290735 0.252669002900265 0.747330997099735 0.233725064870417 0.719830661770662 0.628050238122853 0.0238036679540263 0.0519451640836735
-0.2304 0.109768394051956 0.277762933447017 0.023915071587609 0.722237066552983 0.197095225951551 0.698321994965374 0.599802177625683 -0.0265434060428938 0.0526208122095322
-0.2355 0.141252819555472 0.186426262701283 0.0380014707510792 0.813573737298717 0.395055165273512 0.775572266547638 0.705604776144254 -0.0151292319430873 0.0441418788613381
-0.1436 0.142120848755308 0.131968498892898 0.0510019752865797 0.868031501107102 0.622233380612944 0.817029525820523 0.796729843639772 -0.00778016863799267 0.0359848364074816
5.143 2.5953303821511 0.0877639081155271 0.0985227722202341 0.901477227779766 0.775968069694097 0.813713319664239 0.77912838655189 0.00118432777635476 0.0394798518318744
0.1544 0.114788869723054 0.0373973294106912 0.167123037335538 0.832876962664462 0.466403262476629 0.795479633253771 0.738488592591379 0.0123649327126391 0.0386105814672203
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.gz | head -n 10
  CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P 
1       Affx-10000328   39542062        G       ADD     9684    -0.2082 -0.6583 0.5104
1       Affx-10047176   39917888        A       ADD     9684    0.1906  0.8561  0.392
1       Affx-10071327   40092089        T       ADD     1026    -1.565  -1.457  0.1453
1       Affx-10080353   40160585        A       ADD     9673    0.2518  2.059   0.03949
1       Affx-10096385   40773149        C       ADD     9615    -0.2304 -2.099  0.03582
1       Affx-10134350   41256213        G       ADD     9301    -0.2355 -1.667  0.09547
1       Affx-10349342   43131653        A       ADD     9670    -0.1436 -1.011  0.3123
1       Affx-10384750   43394887        A       ADD     9682    5.143   1.982   0.04752
1       Affx-10384852   43395635        T       ADD     9667    0.1544  1.345   0.1786
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.ashr.results.gz | head -n 19521 | tail -n 10
0.08758 0.165600321623496 0.0672670326399303 0.104178532320824 0.895821467679176 0.751571922312223 0.828554435039246 0.804844923833426 0.00355552034870258 0.0340498867233755
-0.2891 0.383888595105383 0.105354011073783 0.0788017481589557 0.894645988926217 0.746424715314987 0.815844240767261 0.794819823987724 -0.00282558212937117 0.0384572134795336
0.1025 0.16277952668542 0.0641601018135876 0.108855806750366 0.891144193249634 0.73097077832829 0.826984091436046 0.804302555229489 0.00430769098664402 0.0343577294845964
0.09289 0.0973722710409669 0.0404321022007422 0.132003633221478 0.867996366778522 0.622062669024447 0.82756426457778 0.804507714811594 0.00818239321218696 0.032587121304695
0.02967 0.0998256817502583 0.0597059437980346 0.0856378814141029 0.914362118585897 0.814252922687644 0.854656174787862 0.811739217499798 0.00225027274399547 0.0278592547976394
0.01992 0.197349661918707 0.082913585299225 0.0890796301545312 0.910920369845469 0.810990204456393 0.828006784546244 0.804659889666877 0.000605813030757792 0.0344369315134422
-0.3059 0.131694613084285 0.281215592071058 0.0259524875976148 0.718784407928942 0.192726301206359 0.692831920331328 0.592724996545808 -0.0287954321717079 0.0593170828049442
0.08057 0.0928041557057301 0.040904737396607 0.123937465832624 0.876062534167376 0.660726985310266 0.835157796770769 0.806745392913748 0.00728845977832374 0.0311459763991494
-0.1626 0.130507749759064 0.15228529868248 0.0433243094032559 0.84771470131752 0.528928847390138 0.804390391914264 0.755553135518811 -0.010509126571141 0.0379416219107211
-0.1354 0.117579152697003 0.147510048553087 0.0420069406210059 0.852489951446913 0.550287588635299 0.810483010825907 0.769300128481467 -0.0099249726881557 0.0362666162529511
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.gz | head -n 19521 | tail -n 10
1       rs1229387       167610200       A       ADD     9460    0.08758 0.5289  0.5969
1       rs1229395       167603062       C       ADD     9684    -0.2891 -0.7532 0.4514
1       rs1229401       167591280       G       ADD     9676    0.1025  0.6297  0.5289
1       rs1230673       114194513       G       ADD     9675    0.09289 0.9541  0.3401
1       rs1231762       192843391       C       ADD     9647    0.02967 0.2973  0.7663
1       rs1231768       192810565       T       ADD     9677    0.01992 0.101   0.9196
1       rs1231988       96990811        T       ADD     8935    -0.3059 -2.323  0.02019
1       rs1233789       197938330       C       ADD     9668    0.08057 0.8683  0.3853
1       rs1233830       198040978       T       ADD     9673    -0.1626 -1.246  0.2128
1       rs1233839       198034569       C       ADD     9418    -0.1354 -1.152  0.2495
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$for pheno1 in `echo "Height BMI Waist Hip"`; do
> #for pheno1 in `echo "Height"`; do
> #for pheno1 in `echo "BMI Waist Hip"`; do
>         for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>                 ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>                 ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
> 
>                 echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
> 
>                 rm -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.gz
>                 rm -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.gz
>                 for i in {1..22} X; do
> 
>                         cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear | perl -lane 'if ($#F == 8) { print join("\t", @F); }' >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear
>                         cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
> 
>                 done
> 
>                 cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear | sort -g -k 1,1 -k 4,4 | uniq | grep -v BETA | grep -v ^$ | cat <(echo "  CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P ") - > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.temp1
>                 mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.temp1 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear
>                 cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped | sort -g -k 1,1 -k 4,4 | uniq | grep -v NSIG | grep -v ^$ | cat <(echo " CHR    F           SNP         BP        P    TOTAL   NSIG    S05    S01   S001  S0001    SP2") - > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.temp1
>                 mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.temp1 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
>                 gzip /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear
>                 gzip /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
> 
>         done
> done
Height African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr19_v2.African.Height.ADD.assoc.linear.clumped: No such file or directory
Height Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.ADD.assoc.linear.clumped
Height British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped
Height British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr21_v2.British.Ran4000.Height.ADD.assoc.linear.clumped: No such file or directory
Height British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped
Height British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped
Height British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped
Height Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chr22_v2.Caribbean.Height.ADD.assoc.linear.clumped: No such file or directory
Height Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped
Height Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped
BMI African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.BMI.ADD.assoc.linear.clumped
BMI Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.BMI.ADD.assoc.linear.clumped
BMI British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.BMI.ADD.assoc.linear.clumped
BMI British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.BMI.ADD.assoc.linear.clumped
BMI British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.BMI.ADD.assoc.linear.clumped
BMI British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.BMI.ADD.assoc.linear.clumped
BMI British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.BMI.ADD.assoc.linear.clumped
BMI Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.BMI.ADD.assoc.linear.clumped
BMI Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.BMI.ADD.assoc.linear.clumped
BMI Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chr21_v2.Irish.BMI.ADD.assoc.linear.clumped: No such file or directory
Waist African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr13_v2.African.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr22_v2.Any_other_white_background.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Waist.ADD.assoc.linear.clumped
Waist British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Waist.ADD.assoc.linear.clumped
Waist British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Waist.ADD.assoc.linear.clumped
Waist British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Waist.ADD.assoc.linear.clumped
Waist British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Waist.ADD.assoc.linear.clumped
Waist Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chr14_v2.Caribbean.Waist.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chr20_v2.Caribbean.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Waist.ADD.assoc.linear.clumped
Waist Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Waist.ADD.assoc.linear.clumped
Hip African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Hip.ADD.assoc.linear.clumped
Hip Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Hip.ADD.assoc.linear.clumped
Hip British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Hip.ADD.assoc.linear.clumped
Hip British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Hip.ADD.assoc.linear.clumped
Hip British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Hip.ADD.assoc.linear.clumped
Hip British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Hip.ADD.assoc.linear.clumped
Hip British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Hip.ADD.assoc.linear.clumped
Hip Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Hip.ADD.assoc.linear.clumped
Hip Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Hip.ADD.assoc.linear.clumped
Hip Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chr21_v2.Irish.Hip.ADD.assoc.linear.clumped: No such file or directory
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.clumped.AllPopComps
Height

British.Ran4000 80      6       18      42      64      71
British.Ran10000        147     35      57      95      128     137
British.Ran100000       2105    1179    1458    1819    2051    2085
British.Ran200000       4949    3323    3771    4404    4836    4910
African 130     2       17      50      99      115
Caribbean       169     10      24      50      121     155
Indian  1401    51      198     505     1067    1277
Irish   208     36      82      130     182     199


BMI

British.Ran4000 168     1       9       25      75      109
British.Ran10000        165     2       15      36      88      117
British.Ran100000       572     197     250     340     459     498
British.Ran200000       1405    733     822     1039    1257    1322
African 2051    22      77      269     902     1327
Caribbean       291     2       10      40      132     190
Indian  261     3       13      37      108     161
Irish   199     5       21      51      106     139


Waist

British.Ran4000 103     2       6       13      40      55
British.Ran10000        109     2       9       19      41      63
British.Ran100000       424     147     176     240     317     351
British.Ran200000       1029    526     594     723     892     947
African 119     0       6       13      42      62
Caribbean       124     0       3       11      48      68
Indian  197     1       8       26      79      109
Irish   146     1       10      22      58      88


Hip

British.Ran4000 190     1       9       27      81      115
British.Ran10000        174     3       9       26      66      107
British.Ran100000       560     177     226     310     436     481
British.Ran200000       1187    601     693     862     1042    1093
African 373     1       10      30      128     204
Caribbean       181     0       6       30      75      118
Indian  288     0       7       37      105     158
Irish   179     2       11      36      86      117
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps
Height

British.Ran4000 114     37      50      77      97      103
British.Ran10000        303     218     233     257     279     292
British.Ran100000       7730    7307    7407    7530    7665    7707
British.Ran200000       17170   16318   16549   16826   17060   17125
African 140     7       36      71      110     125
Caribbean       191     23      45      73      144     176
Indian  2320    451     791     1246    1907    2170
Irish   442     312     343     368     412     432


BMI

British.Ran4000 180     6       23      46      88      119
British.Ran10000        193     29      50      72      113     142
British.Ran100000       1337    1048    1089    1145    1223    1262
British.Ran200000       4267    3744    3824    3941    4097    4169
African 2670    98      212     492     1234    1764
Caribbean       320     6       20      57      149     207
Indian  279     9       33      61      124     176
Irish   221     16      46      79      127     161


Waist

British.Ran4000 123     11      16      27      54      75
British.Ran10000        136     30      38      47      72      92
British.Ran100000       945     700     728     764     828     863
British.Ran200000       2860    2386    2457    2556    2710    2766
African 130     1       8       16      46      71
Caribbean       128     1       7       22      56      74
Indian  244     2       11      38      107     144
Irish   182     21      38      53      86      120


Hip

British.Ran4000 204     1       18      40      89      124
British.Ran10000        197     21      32      46      90      123
British.Ran100000       1498    1199    1243    1289    1375    1422
British.Ran200000       4151    3675    3767    3866    3993    4048
African 422     2       20      53      153     236
Caribbean       186     4       20      39      85      124
Indian  323     2       27      56      119     184
Irish   195     9       25      51      107     131
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.ashr.results.gz | head -n 10
betahat sebetahat NegativeProb PositiveProb lfsr svalue lfdr qvalue PosteriorMean PosteriorSD
-0.1765 0.51557925141764 0.0366912797649103 0.0315488250421891 0.96330872023509 0.862324648681602 0.931759895192901 0.92328361376068 -0.000809380073474425 0.034999291979268
0.1098 0.357282595715227 0.0299213285682757 0.0362317047108396 0.96376829528916 0.867007368532384 0.933846966720885 0.924981453385552 0.000977346036550227 0.0338432182335573
-2.211 1.73984964988889 0.0381274867326558 0.0321889650903872 0.961872513267344 0.84797149646054 0.929683548176957 0.914895418659724 -0.000950890146514495 0.0362407434251708
0.09407 0.190094740640057 0.0221156469489675 0.0373327373205447 0.962667262679455 0.855869476031909 0.940551615730488 0.927182400131154 0.00219662913468734 0.0299895055311396
-0.1205 0.174358632247393 0.0415753147510309 0.0190823441117376 0.958424685248969 0.811800868755402 0.939342341137231 0.926856075093709 -0.00321752153813457 0.0305116974733594
-0.1502 0.220675012513906 0.0418744148985092 0.0220087740075788 0.958125585101491 0.808506011633257 0.936116811093912 0.925904563115253 -0.00295857212563033 0.0324158858125707
0.04474 0.223584815001318 0.0273329712795276 0.0329475634322919 0.967052436567708 0.888122723210991 0.939719465288181 0.926956229099168 0.000828632491571682 0.0305521600483588
21.3 6.29783416075755 0.0329864820380841 0.0373680393834688 0.962631960616531 0.855509935620387 0.929645478578447 0.914704723883216 0.000704664552574581 0.036354585522483
0.1908 0.181068594738024 0.0165023357465738 0.0526948133339399 0.94730518666606 0.677541451457243 0.930802850919486 0.92177025441877 0.00533736364891803 0.0346973476960722
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | head -n 10
  CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P 
1       Affx-10000328   39542062        G       ADD     3877    -0.1765 -0.3424 0.7321
1       Affx-10047176   39917888        A       ADD     3877    0.1098  0.3073  0.7586
1       Affx-10071327   40092089        T       ADD     423     -2.211  -1.273  0.2038
1       Affx-10080353   40160585        A       ADD     3875    0.09407 0.4949  0.6207
1       Affx-10096385   40773149        C       ADD     3853    -0.1205 -0.6912 0.4895
1       Affx-10134350   41256213        G       ADD     3722    -0.1502 -0.6808 0.4961
1       Affx-10349342   43131653        A       ADD     3872    0.04474 0.2001  0.8414
1       Affx-10384750   43394887        A       ADD     3880    21.3    3.385   0.0007193
1       Affx-10384852   43395635        T       ADD     3865    0.1908  1.054   0.292
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.ashr.results.gz | tail -n 10
0.1559 0.165604448619374 0.0162934295255303 0.0490458437783885 0.950954156221612 0.722767884797491 0.934660726696081 0.925366120241675 0.00471175797341617 0.0327070513954554
-0.08657 0.164407085879733 0.0369938040277777 0.0199729529593963 0.963006195972222 0.859257326984155 0.943033243012826 0.927848564868901 -0.00238158651065105 0.0285291542284419
-6.634 2.83823379826688 0.0386260950325508 0.031905129759768 0.961373904967449 0.842934814852382 0.929468775207681 0.913985323863885 -0.00108121420490664 0.0365232847617687
-0.1822 0.177145809088945 0.0519270376131318 0.0164303293635157 0.948072962386868 0.687051054640137 0.931642633023352 0.923126603218458 -0.00520609672609872 0.0342637018513619
0.3236 0.166981050358021 0.0104211677643059 0.104201777806725 0.895798222193275 0.234824682506148 0.885377054428969 0.839331672079351 0.0149661618391396 0.05158235078295
0.4043 0.213950916617067 0.0133037963650402 0.0849424189012549 0.915057581098745 0.349690506520774 0.901753784733705 0.863248805687215 0.0114671610445161 0.0469791306142695
-0.064 0.16703138232166 0.0338970113748707 0.0217569683829767 0.966102988625129 0.885583876087643 0.944346020242153 0.9282027699294 -0.00169571267367072 0.0278479234927784
-0.1988 0.260571419069276 0.0433388157068274 0.0231052510812477 0.956661184293173 0.791771849726535 0.933555933211925 0.924818377794005 -0.00307978241021344 0.0338398462347753
0.6088 0.534500402008459 0.0269509425887307 0.0438017507459463 0.956198249254054 0.786400187917598 0.929247306665323 0.913208395548966 0.00266980563261122 0.0362728932431515
-0.1736 0.160693226013192 0.0542656097267101 0.0148916381871372 0.94573439027329 0.65789072339012 0.930842752086153 0.921843174090134 -0.00569624259840861 0.0343907117415166
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | tail -n 10
23      rs995355        44281368        G       ADD     3876    0.1559  0.9415  0.3465
23      rs996126        46676931        T       ADD     3872    -0.08657        -0.5266 0.5985
23      rs996341        98536813        A       ADD     3457    -6.634  -2.338  0.01942
23      rs9969869       29626423        G       ADD     3875    -0.1822 -1.029  0.3037
23      rs9969910       129429712       T       ADD     3862    0.3236  1.939   0.05263
23      rs9969915       30346878        T       ADD     3874    0.4043  1.89    0.0588
23      rs9969924       140023572       T       ADD     3874    -0.064  -0.3832 0.7016
23      rs9988241       138270573       G       ADD     3432    -0.1988 -0.7631 0.4455
23      rs9988292       112123649       C       ADD     3870    0.6088  1.139   0.2547
23      rs9988299       144219627       A       ADD     3861    -0.1736 -1.08   0.28
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.ashr.results.gz | head -n 435165 | tail -n 10
-0.1872 0.468546211670901 0.0372455088670453 0.0307052727687713 0.962754491132955 0.856745148099336 0.932049218364183 0.923623037267994 -0.00102645476764451 0.0348341923776666
-0.2297 0.369525796654266 0.040042151197612 0.02750935869758 0.959957848802388 0.828342934706538 0.932448490104808 0.924019900269691 -0.00195049806657821 0.034569859125062
-0.1086 0.472195657846298 0.0357237038891803 0.0319919832482926 0.96427629611082 0.872435962170257 0.932284312862527 0.923864256863055 -0.000585452475121904 0.0347153586052106
0.007177 0.454458688361793 0.0335598482265164 0.0338245303864884 0.966175469613512 0.885829692700163 0.932615621386995 0.924167498336451 4.14513526105802e-05 0.0345378409594841
1.071 0.71709580133105 0.0273913096593632 0.0442097943299856 0.955790205670014 0.781620879235534 0.928398896010651 0.910693685607487 0.00268212540618194 0.0367651084939341
-0.2392 0.148572334722714 0.084444094322961 0.0108378749022974 0.915555905677039 0.353331374933784 0.904718030774742 0.867846935110199 -0.0111486286825356 0.0444312969736253
1.213 0.315078875670193 0.0102049726109904 0.16020973421066 0.83979026578934 0.0966595187388178 0.82958529317835 0.766538594969194 0.0272534109649107 0.0735596302135026
0.273 0.603854372851334 0.0315063138984886 0.0373902736744102 0.96260972632559 0.855292639569116 0.931103412427101 0.922307165537358 0.000930124662650361 0.0353572359133559
-0.5202 0.424307906969782 0.047115214325671 0.0245566001377374 0.952884785674329 0.746541773931772 0.928328185536592 0.910497566593847 -0.00356198387286329 0.0366638583016746
-0.2021 0.300544714834968 0.0413137101693685 0.0253191730249551 0.958686289830632 0.814698312316146 0.933367116805676 0.924704307363091 -0.00245903925753234 0.0340199387845769
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | head -n 435165 | tail -n 10 
9       rs75520839      10358103        G       ADD     3873    -0.1872 -0.3996 0.6895
9       rs75524650      81144942        G       ADD     3878    -0.2297 -0.6217 0.5342
9       rs75524760      122917206       T       ADD     3614    -0.1086 -0.23   0.8181
9       rs75525254      71192450        G       ADD     3626    0.007177        0.01573 0.9874
9       rs75525992      132531575       C       ADD     3458    1.071   1.494   0.1353
9       rs755267        13986757        C       ADD     3868    -0.2392 -1.61   0.1074
9       rs75527174      133280476       A       ADD     3878    1.213   3.854   0.0001182
9       rs75529319      72752666        T       ADD     3882    0.273   0.4521  0.6512
9       rs75529335      93613252        A       ADD     3880    -0.5202 -1.226  0.2202
9       rs75531388      3032917 T       ADD     3869    -0.2021 -0.6724 0.5013
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cmp <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | awk '{ print $7 }' | grep -v BETA) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.ashr.results.gz | awk '{ print $1 }' | grep -v betahat)                         /dev/fd/63 /dev/fd/62 differ: char 318211, line 44596
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | awk '{ print $7 }' | grep -v BETA) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.ashr.results.gz | awk '{ print $1 }' | grep -v betahat) | head -n 44600 | tail -n 10
-0.02706        -0.02706
0.717   0.717
-0.1034 -0.1034
-0.07824        -0.07824
-0.1562 -0.1562
0.0005  5e-04
-0.1303 -0.1303
-0.257  -0.257
-0.5004 -0.5004
0.1294  0.1294
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | awk '{ print $7 }' | grep -v BETA) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.ashr.results.gz | awk '{ print $1 }' | grep -v betahat) | awk '{ if ($1 != $2) { print $0 } } ' | wc
      0       0       0
[  mturchin@node803  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.gz | awk '{ print $7 }' | grep -v BETA) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.ashr.results.gz | awk '{ print $1 }' | grep -v betahat) | awk '{ if ($1 != $2) { print $0 } } ' | wc
      0       0       0
[  mturchin@node803  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.gz | awk '{ print $7 }' | grep -v BETA) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.ashr.results.gz | awk '{ print $1 }' | grep -v betahat) | awk '{ if ($1 != $2) { print $0 } } ' | wc
      0       0       0
[  mturchin@node803  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.gz) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.ashr.results.gz) | perl -lane 'print $F[0], "\t", $F[2], "\t", $F[1], "\t", $F[$#F-1], "\t", $F[$#F];' | R -q -e "Data1 <- read.table(file('stdin'), header=T); Data1 <- cbind(Data1, pnorm(abs(Data1\$PosteriorMean) / Data1\$PosteriorSD, lower.tail=FALSE)); colnames(Data1) <- c(names(Data1)[-ncol(Data1)], \"pVal\"); write.table(Data1, quote=FALSE, row.names=FALSE);" | head -n 10
> Data1 <- read.table(file('stdin'), header=T); Data1 <- cbind(Data1, pnorm(abs(Data1$PosteriorMean) / Data1$PosteriorSD, lower.tail=FALSE)); colnames(Data1) <- c(names(Data1)[-ncol(Data1)], "pVal"); write.table(Data1, quote=FALSE, row.names=FALSE);
CHR BP SNP PosteriorMean PosteriorSD pVal
1 39542062 Affx-10000328 -0.0183108628018179 0.0305653098790492 0.274561983753496
1 39917888 Affx-10047176 0.128908276748433 0.0338473484293385 6.9900743152814e-05
1 40092089 Affx-10071327 -0.0256278303887924 0.0555566592434716 0.322294639789851
1 40160585 Affx-10080353 0.096319454869676 0.0197522309691447 5.40242026014832e-07
1 40773149 Affx-10096385 -0.142986662598653 0.0150650324639293 1.14091172877303e-21
1 41256213 Affx-10134350 -0.0561900409014686 0.0223232788908437 0.00591617505556995
1 43131653 Affx-10349342 0.0134496039954067 0.0169219723849402 0.213364575782362
1 43394887 Affx-10384750 0.00134349867728841 0.0469280960919012 0.488580290617208
Error in write.table(Data1, quote = FALSE, row.names = FALSE) : 
  ignoring SIGPIPE signal
Execution halted
[  mturchin@node803  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.gz) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.ashr.results.gz) | perl -lane 'print $F[0], "\t", $F[2], "\t", $F[1], "\t", $F[$#F-1], "\t", $F[$#F];' | R -q -e "Data1 <- read.table(file('stdin'), header=T); Data1 <- cbind(Data1, pnorm(abs(Data1\$PosteriorMean) / Data1\$PosteriorSD, lower.tail=FALSE)); colnames(Data1) <- c(names(Data1)[-ncol(Data1)], \"pVal\"); write.table(Data1, quote=FALSE, row.names=FALSE);" | perl -lane 'if ($F[$#F] < .0001) { print join("\t", @F0); } ' | wc
  26452       0   26452
[  mturchin@node803  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.gz) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.ashr.results.gz) | perl -lane 'print $F[0], "\t", $F[2], "\t", $F[1], "\t", $F[$#F-1], "\t", $F[$#F];' | R -q -e "Data1 <- read.table(file('stdin'), header=T); Data1 <- cbind(Data1, pnorm(abs(Data1\$PosteriorMean) / Data1\$PosteriorSD, lower.tail=FALSE)); colnames(Data1) <- c(names(Data1)[-ncol(Data1)], \"pVal\"); write.table(Data1, quote=FALSE, row.names=FALSE);" | perl -lane 'if ($F[$#F] < 5e-8) { print join("\t", @F0); } ' | wc
  12978       0   12978
[  mturchin@node803  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed | head -n 10
chr1    39917888        39917888        Affx-10047176
chr1    40160585        40160585        Affx-10080353
chr1    40773149        40773149        Affx-10096385
chr1    53072454        53072454        Affx-11410175
chr1    84876711        84876711        Affx-15002439
chr1    93400766        93400766        Affx-15758179
chr1    51047717        51047717        Affx-35344154
chr1    218510892       218510892       Affx-35455537
chr1    119075738       119075738       Affx-4674273
chr1    25629943        25629943        Affx-52122172
[  mturchin@node803  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.250kbPadding.bed | head -n 10
chr1    39667888        40167888        Affx-10047176
chr1    39910585        40410585        Affx-10080353
chr1    40523149        41023149        Affx-10096385
chr1    52822454        53322454        Affx-11410175
chr1    84626711        85126711        Affx-15002439
chr1    93150766        93650766        Affx-15758179
chr1    50797717        51297717        Affx-35344154
chr1    218260892       218760892       Affx-35455537
chr1    118825738       119325738       Affx-4674273
chr1    25379943        25879943        Affx-52122172
[  mturchin@node844  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.
AllPopComps                                                                                                                                                                                                                     
Height
British.Ran4000 0       0       0       0       0       0                                                                                                                                                                    
British.Ran10000        27      21      27      27      27      27                                                                                                                                                            
British.Ran100000       3843    3810    3825    3829    3838    3838                                                                                                                                                          
British.Ran200000       8620    8521    8551    8582    8605    8611                                                                                                                                                         
African 0       0       0       0       0       0                                                                                                                                                                           
Caribbean       0       0       0       0       0       0                                                                                                                                                                  
Indian  218     25      51      99      196     210                                                                                                                                                                        
Irish   44      37      43      43      43      44


BMI                                                                                                                                                                                                                            
 
British.Ran4000 14      0       3       4       5       6
British.Ran10000        6       2       4       4       4       4
British.Ran100000       222     219     219     219     219     221
British.Ran200000       1001    983     984     992     997     999
African 694     21      39      66      169     259
Caribbean       0       0       0       0       0       0
Indian  7       0       1       2       3       3
Irish   14      0       1       2       4       5


Waist

British.Ran4000 0       0       0       0       0       0
British.Ran10000        5       5       5       5       5       5
British.Ran100000       104     101     101     102     103     103
British.Ran200000       730     687     692     704     718     720
African 0       0       0       0       0       0
Caribbean       3       0       0       0       0       1
Indian  0       0       0       0       0       0
Irish   1       0       0       0       1       1


Hip

British.Ran4000 12      0       4       4       4       6
British.Ran10000        12      3       4       4       4       7
British.Ran100000       426     410     410     411     412     413
British.Ran200000       1353    1330    1331    1335    1341    1343
African 34      0       0       0       6       10
Caribbean       0       0       0       0       0       0
Indian  3       0       0       0       0       0
Irish   13      0       1       1       5       7
...
[  mturchin@node844  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.clumped.AllPopComps   
Height

British.Ran4000 80      6       18      42      64      71
British.Ran10000        147     35      57      95      128     137
British.Ran100000       2105    1179    1458    1819    2051    2085
British.Ran200000       4949    3323    3771    4404    4836    4910
British 13019   13019   13019   13019   13019   13019
African 130     2       17      50      99      115
Caribbean       169     10      24      50      121     155
Indian  1401    51      198     505     1067    1277
Irish   208     36      82      130     182     199


BMI

British.Ran4000 168     1       9       25      75      109
British.Ran10000        165     2       15      36      88      117
British.Ran100000       572     197     250     340     459     498
British.Ran200000       1405    733     822     1039    1257    1322
British 4088    4088    4088    4088    4088    4088
African 2051    22      77      269     902     1327
Caribbean       291     2       10      40      132     190
Indian  261     3       13      37      108     161
Irish   199     5       21      51      106     139


Waist

British.Ran4000 103     2       6       13      40      55
British.Ran10000        109     2       9       19      41      63
British.Ran100000       424     147     176     240     317     351
British.Ran200000       1029    526     594     723     892     947
British 3040    3040    3040    3040    3040    3040
African 119     0       6       13      42      62
Caribbean       124     0       3       11      48      68
Indian  197     1       8       26      79      109
Irish   146     1       10      22      58      88


Hip

British.Ran4000 190     1       9       27      81      115
British.Ran10000        174     3       9       26      66      107
British.Ran100000       560     177     226     310     436     481
British.Ran200000       1187    601     693     862     1042    1093
British 3217    3217    3217    3217    3217    3217
African 373     1       10      30      128     204
Caribbean       181     0       6       30      75      118
Indian  288     0       7       37      105     158
Irish   179     2       11      36      86      117
[  mturchin@node844  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps 
Height                                                                                                                                                                                                                         
                                                                                                                                                                                                                               
British.Ran4000 114     37      50      77      97      103                                                                                                                                                                    
British.Ran10000        303     218     233     257     279     292                                                                                                                                                            
British.Ran100000       7730    7307    7407    7530    7665    7707                                                                                                                                                           
British.Ran200000       17170   16318   16549   16826   17060   17125                                                                                                                                                          
British 40381   40381   40381   40381   40381   40381
African 140     7       36      71      110     125
Caribbean       191     23      45      73      144     176
Indian  2320    451     791     1246    1907    2170
Irish   442     312     343     368     412     432


BMI

British.Ran4000 180     6       23      46      88      119
British.Ran10000        193     29      50      72      113     142
British.Ran100000       1337    1048    1089    1145    1223    1262
British.Ran200000       4267    3744    3824    3941    4097    4169
British 13774   13774   13774   13774   13774   13774
African 2670    98      212     492     1234    1764
Caribbean       320     6       20      57      149     207
Indian  279     9       33      61      124     176
Irish   221     16      46      79      127     161


Waist

British.Ran4000 123     11      16      27      54      75
British.Ran10000        136     30      38      47      72      92
British.Ran100000       945     700     728     764     828     863
British.Ran200000       2860    2386    2457    2556    2710    2766
British 9316    9316    9316    9316    9316    9316
African 130     1       8       16      46      71
Caribbean       128     1       7       22      56      74
Indian  244     2       11      38      107     144
Irish   182     21      38      53      86      120


Hip

British.Ran4000 204     1       18      40      89      124
British.Ran10000        197     21      32      46      90      123
British.Ran100000       1498    1199    1243    1289    1375    1422
British.Ran200000       4151    3675    3767    3866    3993    4048
British 12123   12123   12123   12123   12123   12123
African 422     2       20      53      153     236
Caribbean       186     4       20      39      85      124
Indian  323     2       27      56      119     184
Irish   195     9       25      51      107     131
[  mturchin@node844  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.AllPopComps
Height

British.Ran4000 0       0       0       0       0       0
British.Ran10000        24      18      24      24      24      24
British.Ran100000       3554    3526    3540    3543    3548    3548
British.Ran200000       7952    7871    7895    7923    7943    7944
British 24500   24500   24500   24500   24500   24500
African 0       0       0       0       0       0
Caribbean       0       0       0       0       0       0
Indian  200     19      34      46      91      173
Irish   41      34      40      40      40      41


BMI

British.Ran4000 13      0       3       3       4       6
British.Ran10000        5       1       3       3       3       3
British.Ran100000       211     208     208     208     208     210
British.Ran200000       906     888     890     896     903     904
British 6060    6060    6060    6060    6060    6060
African 595     20      35      54      133     216
Caribbean       0       0       0       0       0       0
Indian  7       0       1       2       2       2
Irish   14      0       1       2       4       5


Waist

British.Ran4000 0       0       0       0       0       0
British.Ran10000        5       5       5       5       5       5
British.Ran100000       86      86      86      86      86      86
British.Ran200000       618     591     593     600     609     611
British 3294    3294    3294    3294    3294    3294
African 0       0       0       0       0       0
Caribbean       3       0       0       0       0       1
Indian  0       0       0       0       0       0
Irish   0       0       0       0       0       0


Hip

British.Ran4000 10      0       2       2       2       4
British.Ran10000        10      2       3       3       3       6
British.Ran100000       388     375     375     376     377     378
British.Ran200000       1249    1232    1233    1235    1239    1242
British 5543    5543    5543    5543    5543    5543
African 32      0       0       0       4       8
Caribbean       0       0       0       0       0       0
Indian  3       0       0       0       0       0
Irish   12      0       1       1       2       6


#20180313
(MultiEthnicGWAS) [  mturchin@node813  ~/data/ukbiobank_jun17/subsets/African/African]$cat *bim | wc
 803113 4818678 23068702
(MultiEthnicGWAS) [  mturchin@node813  ~/data/ukbiobank_jun17/subsets/African/African]$cat plink.log
PLINK v1.90b4 64-bit (20 Mar 2017)
Options in effect:
  --bfile /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African
  --exclude range /users/mturchin/Software/flashpca/exclusion_regions_hg19.txt
  --indep-pairwise 1000 50 0.05

Hostname: node813
Working directory: /gpfs/data/sramacha/ukbiobank_jun17/subsets/African/African
Start time: Tue Mar 13 14:15:52 2018

Random number seed: 1520964952
129170 MB RAM detected; reserving 64585 MB for main workspace.
18857 variants loaded from .bim file.
3205 people (1651 males, 1554 females) loaded from .fam.
Warning: No variants excluded by '--exclude range'.
--exclude range: 18857 variants remaining.
Using 1 thread (no multithreaded calculations invoked).
Before main variant filters, 3205 founders and 0 nonfounders present.
Calculating allele frequencies... done.
Total genotyping rate is 0.975492.
18857 variants and 3205 people pass filters and QC.
Note: No phenotypes present.
Pruned 15358 variants from chromosome 23, leaving 3499.
Pruning complete.  15358 of 18857 variants removed.
Marker lists written to plink.prune.in and plink.prune.out .

End time: Tue Mar 13 14:15:54 2018
(MultiEthnicGWAS) [  mturchin@node813  ~/data/ukbiobank_jun17/subsets/African/African]$cat /users/mturchin/data/ukbiobank_jun17/ukb_snp_qc.txt | wc
 805427 128062893 371289758
(MultiEthnicGWAS) [  mturchin@node813  ~/data/ukbiobank_jun17/subsets/African/African]$cat /users/mturchin/data/ukbiobank_jun17/ukb_snp_qc.txt | head -n 10
rs_id affymetrix_snp_id affymetrix_probeset_id chromosome position allele1_ref allele2_alt strand array Batch_b001_qc Batch_b002_qc Batch_b003_qc Batch_b004_qc Batch_b005_qc Batch_b006_qc Batch_b007_qc Batch_b008_qc Batch_b009_qc Batch_b010_qc Batch_b011_qc Batch_b012_qc Batch_b013_qc Batch_b014_qc Batch_b015_qc Batch_b016_qc Batch_b017_qc Batch_b018_qc Batch_b019_qc Batch_b020_qc Batch_b021_qc Batch_b022_qc Batch_b023_qc Batch_b024_qc Batch_b025_qc Batch_b026_qc Batch_b027_qc Batch_b028_qc Batch_b029_qc Batch_b030_qc Batch_b031_qc Batch_b032_qc Batch_b033_qc Batch_b034_qc Batch_b035_qc Batch_b036_qc Batch_b037_qc Batch_b038_qc Batch_b039_qc Batch_b040_qc Batch_b041_qc Batch_b042_qc Batch_b043_qc Batch_b044_qc Batch_b045_qc Batch_b046_qc Batch_b047_qc Batch_b048_qc Batch_b049_qc Batch_b050_qc Batch_b051_qc Batch_b052_qc Batch_b053_qc Batch_b054_qc Batch_b055_qc Batch_b056_qc Batch_b057_qc Batch_b058_qc Batch_b059_qc Batch_b060_qc Batch_b061_qc Batch_b062_qc Batch_b063_qc Batch_b064_qc Batch_b065_qc Batch_b066_qc Batch_b067_qc Batch_b068_qc Batch_b069_qc Batch_b070_qc Batch_b071_qc Batch_b072_qc Batch_b073_qc Batch_b074_qc Batch_b075_qc Batch_b076_qc Batch_b077_qc Batch_b078_qc Batch_b079_qc Batch_b080_qc Batch_b081_qc Batch_b082_qc Batch_b083_qc Batch_b084_qc Batch_b085_qc Batch_b086_qc Batch_b087_qc Batch_b088_qc Batch_b089_qc Batch_b090_qc Batch_b091_qc Batch_b092_qc Batch_b093_qc Batch_b094_qc Batch_b095_qc UKBiLEVEAX_b1_qc UKBiLEVEAX_b2_qc UKBiLEVEAX_b3_qc UKBiLEVEAX_b4_qc UKBiLEVEAX_b5_qc UKBiLEVEAX_b6_qc UKBiLEVEAX_b7_qc UKBiLEVEAX_b8_qc UKBiLEVEAX_b9_qc UKBiLEVEAX_b10_qc UKBiLEVEAX_b11_qc in_HetMiss in_Relatedness in_PCA PC1_loading PC2_loading PC3_loading PC4_loading PC5_loading PC6_loading PC7_loading PC8_loading PC9_loading PC10_loading PC11_loading PC12_loading PC13_loading PC14_loading PC15_loading PC16_loading PC17_loading PC18_loading PC9_loading PC20_loading PC21_loading PC22_loading PC23_loading PC24_loading PC25_loading PC26_loading PC27_loading PC28_loading PC9_loading PC30_loading PC31_loading PC32_loading PC33_loading PC34_loading PC35_loading PC36_loading PC37_loading PC38_loading PC9_loading PC40_loading in_Phasing_Input
rs28659788 Affx-13546538 AX-32115783 1 723307 C G + 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 0
rs116587930 Affx-35298040 AX-37361813 1 727841 G A + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 0 0 0 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 0
rs116720794 Affx-13637449 AX-32137419 1 729632 C T + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 0 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 0
rs3131972 Affx-13945728 AX-13191280 1 752721 A G + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 1
rs12184325 Affx-13963217 AX-11194291 1 754105 C T + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 -0.00019684 1.61348e-05 0.00293187 -0.00653266 -0.00053331 0.00136479 -0.00495838 0.00296911 -0.00273732 -0.00309628 -0.00278084 0.000566625 0.00118939 -0.00110896 -0.00116043 -0.00501367 -0.00522113 0.000986281 0.00279501 0.00201829 -0.00168376 0.00063532 -0.00160938 0.00369638 -0.000535131 -0.00283076 0.0016734 0.00213946 -0.00294971 0.00193457 0.00402521 -0.00347144 0.00589896 -0.00373881 -0.00189571 -0.00286888 0.000792278 -0.00191024 0.00307453 -0.000410934 1
rs3131962 Affx-13995532 AX-32225497 1 756604 A G + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 1
rs114525117 Affx-14027812 AX-32233025 1 759036 G A + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 1
rs3115850 Affx-14055733 AX-40202607 1 761147 T C + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 0
rs115991721 Affx-35298091 AX-37361837 1 767096 A G + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 1
(MultiEthnicGWAS) [  mturchin@node813  ~/data/ukbiobank_jun17/subsets/African/African]$cat /users/mturchin/data/ukbiobank_jun17/ukb_snp_qc.txt | awk '{ print $8 }' | sort | uniq -c
 805426 +
      1 strand
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/*/*/mturchin20/*genome.gz | sort -rg -k 10,10 | head -n 10
  2158009  2158009  2529116  2529116 UN    NA  0.0000  0.0018  0.9982  0.9991  -1  0.999732  1.0000      NA
  1877246  1877246  2988290  2988290 UN    NA  0.0000  0.0050  0.9950  0.9975  -1  0.999279  1.0000      NA
  1799741  1799741  2095912  2095912 UN    NA  0.0000  0.0066  0.9934  0.9967  -1  0.999292  1.0000      NA
  2703114  2703114  5491748  5491748 UN    NA  0.0000  0.0091  0.9909  0.9955  -1  0.999021  1.0000      NA
  2227118  2227118  5098716  5098716 UN    NA  0.0000  0.0178  0.9822  0.9911  -1  0.997419  1.0000      NA
  1651492  1651492  2212586  2212586 UN    NA  0.0000  0.0389  0.9611  0.9806  -1  0.995811  1.0000      NA
  4741676  4741676  4822865  4822865 UN    NA  0.1352  0.4565  0.4083  0.6366  -1  0.927493  1.0000 19.8074
  3030528  3030528  5307254  5307254 UN    NA  0.1080  0.5356  0.3565  0.6242  -1  0.897493  1.0000 25.3525
  2120488  2120488  2597019  2597019 UN    NA  0.1106  0.5342  0.3552  0.6223  -1  0.923354  1.0000 23.3016
  1033231  1033231  1327772  1327772 UN    NA  0.1363  0.5022  0.3615  0.6126  -1  0.926737  1.0000 23.3130
[  mturchin@login002  ~/data/ukbiobank_jun17]$for i in {25..31}; do echo $i; zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz | awk -v iAwk=$i '{ print $iAwk }' | sort | uniq -c; done
25
 487409 0
    968 1
26
 487725 0
    652 1
27
 340646 0
 147731 1
28
 487400 0
    977 1
29
 488189 0
    188 1
30
  78674 0
 409703 1
31
  81158 0
 407219 1
(MultiEthnicGWAS) [  mturchin@node604  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs | wc
    188     376    3008
(MultiEthnicGWAS) [  mturchin@node604  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>         ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>         ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
> 
>         echo $ancestry1 $ancestry2
> 
>         cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.genome.drop.FIDIIDs | wc
> 
> done
African African
     59     118     944
Any_other_Asian_background Any_other_Asian_background
     63     126    1008
Any_other_mixed_background Any_other_mixed_background
      6      12      96
Any_other_white_background Any_other_white_background
   3289    6578   52624
British British
      0       0       0
British British.Ran4000
      6      12      96
British British.Ran10000
     22      44     352
British British.Ran100000
      0       0       0
British British.Ran200000
      0       0       0
Caribbean Caribbean
    265     530    4240
Chinese Chinese
     35      70     560
Indian Indian
    306     612    4896
Irish Irish
    518    1036    8288
Pakistani Pakistani
     73     146    1168
[  mturchin@login002  ~/data/1000G]$cat /users/mturchin/data/1000G/integrated_call_samples_v3.20130502.ALL.panel | head -n 10                         
sample  pop     super_pop       gender  
HG00096 GBR     EUR     male
HG00097 GBR     EUR     female
HG00099 GBR     EUR     female
HG00100 GBR     EUR     female
HG00101 GBR     EUR     male
HG00102 GBR     EUR     female
HG00103 GBR     EUR     male
HG00105 GBR     EUR     male
HG00106 GBR     EUR     female
[  mturchin@login002  ~/data/1000G]$cat /users/mturchin/data/1000G/integrated_call_samples_v3.20130502.ALL.panel | awk '{ print $3 }' | sort | uniq -c
    661 AFR
    347 AMR
    504 EAS
    503 EUR
    489 SAS
      1 super_pop
[  mturchin@login002  ~/data/1000G]$cat /users/mturchin/data/1000G/integrated_call_samples_v3.20130502.ALL.panel | awk '{ print $2 }' | sort | uniq -c
     96 ACB
     61 ASW
     86 BEB
     93 CDX
     99 CEU
    103 CHB
    105 CHS
     94 CLM
     99 ESN
     99 FIN
     91 GBR
    103 GIH
    113 GWD
    107 IBS
    102 ITU
    104 JPT
     99 KHV
     99 LWK
     85 MSL
     64 MXL
     85 PEL
     96 PJL
    104 PUR
    102 STU
    107 TSI
    108 YRI
      1 pop
[  mturchin@login002  ~/data/1000G]$cat /users/mturchin/data/1000G/integrated_call_samples_v3.20130502.ALL.panel | awk '{ print $4 }' | sort | uniq -c
   1271 female
      1 gender
   1233 male



~~~














