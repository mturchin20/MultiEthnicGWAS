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





```

