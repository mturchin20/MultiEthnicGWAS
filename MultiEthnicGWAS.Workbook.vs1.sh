#!/bin/sh

###20171108 -- MultiEthnicGWAS


##20171117 -- Dealing with sockets/missing screen issue

#From https://superuser.com/questions/58525/how-do-i-reconnect-to-a-lost-screen-detached-missing-socket

# ps aux | grep mturchin
# kill -CHLD 16830 

#20171128 NOTE -- might be helpful here, shows the use of `autodetach on` at the end from this person's defaults, which I was not originally including in my `.screenrc` file, `https://remysharp.com/2015/04/27/screen`


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

#Beginning Work

#/users/mturchin/data/ukbiobank , /users/mturchin/data/ukbiobank_jun17/mturchin

#mkdir /users/mturchin/LabMisc/RamachandranLab/IntroProjs
#mkdir /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS
#mkdir /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/PCAEffects
mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS; 
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

#Saved the below code into a file via ':218,227w! /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.vs2.sh'; moved to the 'vs2' version after the retreat 
#!/bin/sh

ancestry="$1"
ancestry2="$2"
keep="$3"
chr="$4"

plink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr${chr}_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr${chr}_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --make-bed --keep $keep --out /users/mturchin/data/ukbiobank_jun17/2017WinterHack/$ancestry/ukb_chr${chr}_v2.${ancestry2} --noweb

##srun -e /users/mturchin/data/ukbiobank_jun17/2017WinterHack/error -o /users/mturchin/data/ukbiobank_jun17/2017WinterHack/out bash /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.sh British /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs 21
sbatch -e /users/mturchin/data/ukbiobank_jun17/2017WinterHack/British/ukb_chr${i}_v2.British.Ran4000.slurm.error /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.sh British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs 21

#Ran below for 'British.Ran4000', 'African', and 'Caribbean'; also ran the below during the retreat itself, and then moved to the next version of the for loop that includes the outer, per-ancestry for loop as well
#for i in {X..X}; do
#	
#	echo $i	
#	sbatch -t 1:00:00 --mem 8g -e /users/mturchin/data/ukbiobank_jun17/2017WinterHack/Caribbean/ukb_chr${i}_v2.Caribbean.slurm.error /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.sh Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.Caribbean.FIDIIDs $i
#
#done

mkdir /users/mturchin/data/ukbiobank_jun17/subsets/

val1hg19=`echo "HaemgenRBC2016;HaemgenRBC2016;8.31e-9;RBC,MCV,PCV,MCH,Hb,MCHC GEFOS2015;GEFOS2015;1.2e-8;FA,FN,LS SSGAC2016;SSGAC2016;5e-8;NEB_Pooled,AFB_Pooled EMERGE22015;EMERGE22015;7.1e-9;ICV,Accumbens,Amygdala,Caudate,Hippocampus,Pallidum,Putamen,Thalamus"`;
                
for i in `cat <(echo $val1hg19 | perl -lane 'print join("\n", @F);')`; do
        Dir1=`echo $i | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
        Dir2=`echo $i | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
        pVal1=`echo $i | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[2];'`



for j in `cat | head -n 2`; do
	ancestry1=``
	ancestry2=``

	for chr1 in {X..X}; do
	
		if [ ! -d /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1 ]; then
		
		fi
		if [ ! -d /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2 ]; then
		
		fi
	
		echo $ancestry1 $ancestry2 $chr1	
		sbatch -t 1:00:00 --mem 8g -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.$ancestry2.slurm.error /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.vs2.sh $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.$ancestry2.FIDIIDs $chr1
	
	done
done

#post-retreat extra work to clean things up/actually partially use?


21000 Ethnic_background 501726
21001 Body_mass_index_(BMI) 499579
21003 Age_when_attended_assessment_centre 502620
22000 Genotype_measurement_batch 488366
22001 Genetic_sex 488366
22006 Genetic_ethnic_grouping 409694
22007 Genotype_measurement_plate 488366
22008 Genotype_measurement_well 488366
22009 Genetic_principal_components 488366
22011 Genetic_relatedness_pairing 17306
22012 Genetic_relatedness_factor 17306
22013 Genetic_relatedness_IBS0 17306
31 Sex 502620
34 Year_of_birth 502620
48 Waist_circumference 500500
49 Hip_circumference 500438
50 Standing_height 500130

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






```
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




```

