#!/bin/bash
## find path to itself line below https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
a="$( cd "$(dirname "$0")" ; pwd -P )"

if [ -z "$1" ];then
    echo
    echo "This is an R-based genetic sequence handler coded by PokMan HO in 2019 May."
    echo "If you like to look at quick instructions, input option -h"
    echo "If you like accession numbers formating samples (only accept .csv OR .txt), see these two sample files in the sample directory of this script."
    echo "Detailed instructions are in 00_instructions.md file"
    echo "Thanks for making a fresh attempt.  I'll do my best when your inputs are ready."
    echo
    exit
fi

if [ $1 == "-h" ];then
    echo
    echo "This is the help page"
    echo
    echo "For making aligned FASTA file from a matrix of accession numbers, input option -SeqG following the sample input below"
    echo "<pull this master script here> -SeqG <dna / rna> <pull accession number file here> <type integer number of NCBI rest time (minutes)>"
    echo "Please make sure you are having internet connection"
    echo
    echo "For aligning sequences directly from known FASTA files from a single folder (one gene per file), input option -SeqA following the sample input below"
    echo "<pull this master script here> -SeqA <dna / rna> <pull your folder containing the gene sequence FASTA files>"
    echo "Notice that genes can only be arranged according to the FASTA file order in your input folder"
    exit
fi

if [ $1 = "-SeqG" ];then
    inF=`dirname $3`
    test1=`R --version|head -n 1|awk -v OFS=" " '{print $3}'`
    # test=${test1:0:1}
    test2=`echo ${test1}|cut -f 1 -d "."`
    test3=`echo ${test1}|cut -f 2 -d "."`
    test4=`echo ${test1}|cut -f 3 -d "."`
    test=$((${test2}${test3}${test4}))
    if [ ${test} -lt 320 ];then
        echo
        echo "Please upgrade your R to the latest version before try again."
        echo
        exit
    fi
    Rscript ${a}/CheckTools.R

    ## test file extension https://stackoverflow.com/questions/407184/how-to-check-the-extension-of-a-filename-in-a-bash-script
    if [[ $3 == *.csv ]];then
        b=1;else
        b=2
    fi
    c=`basename $3|cut -f 1 -d "."`
    # echo "Rscript ${a}/GetAligned.R $3 ${b} ${inF} $2 ${c} $4"
    Rscript ${a}/GetAligned.R $3 ${b} ${inF} $2 ${c} $4
    exit
fi

if [ $1 = "-SeqA" ];then
    test1=`R --version|head -n 1|awk -v OFS=" " '{print $3}'`
    # test=${test1:0:1}
    test2=`echo ${test1}|cut -f 1 -d "."`
    test3=`echo ${test1}|cut -f 2 -d "."`
    test4=`echo ${test1}|cut -f 3 -d "."`
    test=$((${test2}${test3}${test4}))
    if [ ${test} -lt 350 ];then
        echo
        echo "Please upgrade your R to the latest version before try again."
        echo
        exit
    fi
    Rscript ${a}/CheckTools.R

    ## remove potential past attempt
    if [ `ls $3/00_*.fa|wc -l` -gt 0 ];then
        echo
        echo "There maybe a past sequence fusion result you may want to backup ASAP, I'll stop for 5 seconds"
        echo
        sleep 5
    fi
    mkdir -p $3/int
    if [ `ls $3/int/*|wc -l` -gt 0 ];then
        rm $3/int/*
    fi

    ## last file backup warning
    echo "Last chance of keeping a record of the past attempt, 10 seconds left"
    echo
    sleep 10
    rm $3/00_*.fa

    ## align individual FASTA file
    for i in `ls $3/*.fa`;do
        bn=`basename ${i}|cut -f 1 -d "."`
        Rscript ${a}/LocalAlign.R $3 ${i} ${bn} $2
    done

    if [ $((`ls $3/int/*_aln.fa|wc -l`)) -gt 1 ];then
        ## combine FASTA files together
        Rscript ${a}/LocalAlignedFuse.R $3
    fi
    exit
fi