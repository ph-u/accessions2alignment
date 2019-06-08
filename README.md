
# accessions2alignment: Accession numbers to sequence alignment handler

## Welcome

This is a detailed instruction page introducing the program, an R-based genetic sequence handler.  For a quick help, pull the "00_master_seq_grep.sh" file into the Unix-type command console (i.e. the "Terminal.app" for Mac and Linux users) and press `enter`.  For the command instructions, add a `-h` tag behind the script before pressing `enter`.  
&nbsp;  
For Windows users, there is currently **NO** method of programming preparation.  [Cygwin][Cygwin] is NOT supported by [Rtools*.exe][Rtools] even though R adaptations still [exist][adpt] (search for keywords "cygwin" for more related information in these documentations).  A potential solution is to make a second boot operation system (OS) for a Linux distribution (e.g. [Ubuntu][Ubuntu]) which make all Linux commands and programs usable.  

## Primitive setup

Go to the "release" page and download the latest version.  Unzip the download file and it should be good to go.  
If not, please do the following in the Unix concole:

1. Type `cd` and pull the unzipped "accesions2alignment" folder into the concole, then press `enter`
2. Type `chmod u+x *.sh; chmod u+x *.R`, then press `enter`.

And the program is ready for use.

## Computational preparation

* Terminal.app (i.e. MacOS or any Linux-based OS)
* R version >=3.5.0 (R language [website][R]; if you are not clear about your R version, type `R --version` into your Unix-type command console and press "enter" to check)
* your data: if you want to grab from NCBI, .csv OR .txt tabular formatted file; if you want to align & combine your own FASTA files, one folder containing all your raw sequences WITHOUT SEQUENCE NAME DUPLICATION
* workable internet (if this is your first run or you want to grab sequences from [NCBI][NCBI])

## 1. Online NCBI sequence extraction

### 1.1 Input data requirements

1. Accepted input file format: a matrix as `comma`-separated values (csv, e.g. sample.csv) OR `Tab`-separated values (txt, e.g. sample.txt)
2. Entry data format: See below

Accession Entry | Description
--- | ---
Normal | one NCBI-recognized accession number in a data cell
Missing data | blank data cell
Multiple accessions | "/" separating accession numbers WITHOUT SPACES in a data cell
Replacement sequence | whole sequence entry within ONE LINE (i.e. no column separations) in a data cell

### 1.2 Make it work from your Unix console

1. Give the following **5 inputs** to the console: `<pull 00_master_seq_grep.sh> -SeqG <type dna/rna> <pull input file> <type non-zero integer short break (in minute)>` then press `enter`.
   1. Pulling files to the console gives the full path of the file, which is essential for the program identifying path for outputs.
   2. -SeqG: a tag for the program to know you will need to grab sequence from NCBI database
   3. The non-zero number: in case of a sequence grabbing traffic jam / unexpected long sequence retrieval time, this will potentially fit you inside the NCBI defense system.  If you grab sequences too fast, you may face a **IP-block** by the NCBI, encountering an unnecessary error (See below **Potential Errors** section)
2. Wait for the result in the same folder of your input file.
   1. **Missing data**: a null sequence will be given to every empty entry during sequence alignment
   2. **Multiple accessions** entries will be aligned before a grand alignment with all taxa (i.e. rows of your input data matrix)
   3. **Replacement sequence** entries will be directly used for sequence alignment
   4. For every 10 minutes of non-stop sequence acquisition, the program would have a short break (which the time is specified by the user).

#### 1.3 Result outputs

Name | Description
--- | ---
{your input file name}.fa | Aligned FASTA file (main output)
{your input file name}_Summary.csv | aligned sequence lengths of your input
Seq_Data_Cant_Download.txt | rare occasion (this file usually don't appear), trigger by online database; require **Replacement sequence** entry & rerun the program

#### 1.4 Potential Errors

Error | Description
--- | ---
`4xx` | your input accession numbers has problems, please refer to the sample inputs in **Input data requirements** section
`5xx` | don't attempt to grab sequence again for the next **30 mins**, and input a larger integer (recommend: 15 or more) in the `<type non-zero integer short break (in minute)>` entry for your next attempt

***

## 2. Local sequence handler

### 2.1 Input data requirements

1. All input FASTA file(s) inside one input folder (e.g. the `./sample/` folder)
2. Accepted FASTA file(s) formats
   1. odd lines = sequence names; even lines = sequence
   2. sequence names on top of a multi-line formatted sequence
3. OK to have different set of taxa in different FASTA files within the input folder
   1. There should be at least one shared taxon between any two FASTA files in the input folder
   2. The shared taxa among these FASTA files should be able to connect them together as a whole dataset

### 2.2 Make it work from your Unix console

1. Give the following **4 inputs** to the console: `<pull 00_master_seq_grep.sh> -SeqA <type dna/rna> <pull your input folder>` then press `enter`.
   1. Pulling files to the console gives the full path of the file, which is essential for the program identifying path for outputs.
   2. -SeqA: a tag for the program to know you will need to align multiple sequences from different local FASTA files
2. Wait for the result in the same folder of your input folder
   1. If this is not your first run for the same set of sequence data, make sure that you have either backup these main outputs elsewhere.  If not, they will be replaced before the *Handler* rerun start.
   2. For any taxa that is missing for a sequence (in a FASTA file), the program will add a null sequence automatically for that taxa's sequence when fusing all FASTA files together
   3. `./int/` folder: individual aligned FASTA files for each input FASTA files in your input folder
   4. If input folder has >1 FASTA file, a "00_all_fused.fa" will be the main input
   5. If input folder has 1 FASTA file, only the `./int/` folder will be made with that sequence FASTA file inside (since that file is already what is needed)

#### 2.3 Result outputs

Name | Description
--- | ---
`./int/` folder | all aligned individual sequence FASTA files will be deposited here
{seq name}_aln.fa | aligned sequence FASTA file for one sequence input file
00_all_fused.fa | (multiple FASTA files in input folder only) FASTA file output fusing all individual input sequences, containing all considered taxa
00_all_fused_summary.csv | aligned sequence lengths of your input

## Citations

If you have used this program, please cite the following published sources:  
Citation for [Clustal Omega][CO] sequence aligning algorithm  

```{r}
## R codes for Bibtex citations source text
citation()## R
citation("traits")## online NCBI sequence extracter
citation("msa")## local sesquence aligner
citation("ape")## local FASTA reader & writer
citation("RcmdrMisc")## local FASTA files fusion
```

[Cygwin]:https://www.cygwin.com
[Rtools]: https://cran.r-project.org/bin/windows/Rtools/Rtools.txt
[adpt]: https://cran.r-project.org/doc/manuals/r-release/R-admin.pdf
[Ubuntu]: https://www.ubuntu.com/download/desktop
[R]:https://www.r-project.org
[NCBI]:https://www.ncbi.nlm.nih.gov
[CO]:http://msb.embopress.org/content/msb/7/1/539.full.pdf