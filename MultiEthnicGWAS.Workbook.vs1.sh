#!/bin/sh

###20171108 -- MultiEthnicGWAS


##20171117 -- Dealing with sockets/missing screen issue

#From https://superuser.com/questions/58525/how-do-i-reconnect-to-a-lost-screen-detached-missing-socket

# ps aux | grep mturchin
# kill -CHLD 16830 

#20171128 NOTE -- might be helpful here, shows the use of `autodetach on` at the end from this person's defaults, which I was not originally including in my `.screenrc` file, `https://remysharp.com/2015/04/27/screen`


##20171108 -- PCAEffects

#20171128 -- git webpage TOC main .Rmd file setup here

cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/MultiEthnicGWAS.Workbook.vs1.sh | perl -lane 'if ($. == 1) { $flag1 = 0; } my $line1 = join(" ", @F); if ($line1 =~ m/^-->.*/) { $flag1 = 0; close $fh1; } if ($flag1 == 1) { print $fh1 join("\t", @F); } if ($line1 =~ m/^<!-- (.*Rmd).*/) { $flag1 = 1; $file1 = "/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/website/" . $1; open($fh1, ">", $file1) }'

<!-- index.Rmd
---
title: "Home"
output:
  html_document:
    toc: false
---

Homepage for the Ramachandran Lab project `MultiEthnic GWAS`.

* [Example 1][Example1]
* [Example 2][Example2]

Github [repo][gitrepo1] page

[example1]: url
[example2]: url
[gitrepo1]: https://github.com/mturchin20/MultiEthnicGWAS

-->




#/users/mturchin/data/ukbiobank

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

rm -f /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/UKBioBank.HTMLScraping.FieldCategories.Field_Name.vs.txt; for i in $urls1; do echo $i; GET $i | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*.a class="basic" href="field.cgi\?id=(\d+)"..*.a class="subtle" href="field.cgi\?id=\d+".(.*).\/a..\/td..*/) { print $1, "\t", $2 ; }' >> /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/UKBioBank.HTMLScraping.FieldCategories.Field_Name.vs.txt; done

rm -f /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt; for i in `cat /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/UKBioBank.HTMLScraping.FieldCategories.Field_Name.vs.txt | perl -F"\t" -lane 'chomp(@F); print join(";", @F);' | sed 's/ /_/g'`; do 
#rm -f /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt; for i in `cat /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/UKBioBank.HTMLScraping.FieldCategories.Field_Name.vs.txt | sed 's/\t/;/g' | sed 's/\s/_/g'`; do 
#	echo $i; done
	Field1=`echo $i | perl -F\; -ane 'print $F[0];'`
	Name1=`echo $i | perl -F\; -ane 'print $F[1];'`
	
#	echo $i $Field1 $Name1; 
#	echo $Field1 $Name1; 

	GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=$Field1 | perl -slane 'my $line = join(" ", @F); if ($line =~ m/.* (\d+,\d+) participants.*/) { print $Field2, "\t", $Name2, "\t", $1; }' -- -Field2=$Field1 -Name2=$Name1 | sed 's/,//g' >> /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt;
done

cat UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | awk '{ print $3 }' | R -q -e "Data1 <- read.table(file('stdin'), header=F); png(\"nana.png\", height=650, width=650, res=150); hist(Data1[,1]); dev.off();"

#Getting .Rmd/.html/git directory stuff worked out by copying some base content from workflowr (https://github.com/jdblischak/workflowr) that I have stored in a previously temp workflowr test run at https://github.com/mturchin20/misc 
#cd /users/mturchin/LabMisc/RamachandranLab/
#clone https://github.com/mturchin20/misc

mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/docs
mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/website

cp -rp /users/mturchin/LabMisc/RamachandranLab/misc/docs/site_libs/* /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/docs/site_libs/.
cp -rp /users/mturchin/LabMisc/RamachandranLab/misc/analysis/* /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/website/.

#some helpful comments on Makefile misc -- https://stackoverflow.com/questions/3220277/what-do-the-makefile-symbols-and-mean, https://stackoverflow.com/questions/18136918/how-to-get-current-relative-directory-of-your-makefile, https://stackoverflow.com/questions/3707517/make-file-echo-displaying-path-string, https://www.gnu.org/software/make/manual/html_node/File-Name-Functions.html, https://www.gnu.org/software/make/manual/html_node/Text-Functions.html

#20171128 NOTE -- copy and pasted the correct `<img src =....` lines from files such as `https://github.com/mturchin20/misc/blob/master/docs/index.html` into `/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/docs/20171127.CorrectHTML.html` and then coming up with the `head`, `awk if (NR >...`, and `cat tmp1 CorrectHTML tmp2` commands found in the `Makefile` now  

#some helpful comments from here re: knitr related commands https://stackoverflow.com/questions/10646665/how-to-convert-r-markdown-to-html-i-e-what-does-knit-html-do-in-rstudio-0-9
#R -e "library(\"knitr\"); knitr::knit2html(\"Example.Rmd\");"

#cat MainScript.IntroProjs.MultiEthnGWAS.vs1.sh | 
#cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/MultiEthnicGWAS.Workbook.vs1.sh | perl -lane 'if ($. == 1) { $flag1 = 0; } my $line1 = join(" ", @F); if ($line1 =~ m/^-->.*/) { $flag1 = 0; close $fh1; } if ($flag1 == 1) { print $fh1 join("\t", @F); } if ($line1 =~ m/^<!-- (.*Rmd).*/) { $flag1 = 1; $file1 = "/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/website/" . $1; open($fh1, ">", $file1) }'

<!-- Example1.Rmd

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


```

