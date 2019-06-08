args = commandArgs(T)

## input from Unix environment
indir<-args[[1]]
infile<-args[[2]]
outnam<-args[[3]]
type<-args[[4]]

## load necessary libraries
library(msa)
library(ape)

## read FASTA file
oo<-read.dna(infile,format="fa",as.character = T,as.matrix = F)

## prepare alignment dataframe
aa<-as.data.frame(matrix(nrow=length(oo),ncol=3))
aa[,1]<-names(oo)
for(i in 1:length(oo)){
	aa[i,2]<-paste0(unname(unlist(oo[i])),collapse="")
};rm(i)

## check sequence name uniqueness
if(length(unique(aa[,1]))!=dim(aa)[1]){print(paste("Repeated sequence name for",outnam,", causing error in later step!!!"))}

## msa align
cat(paste("Aligning",outnam,"with ClustalOmega; "))
aligned<-as.alignment(msaConvert(msa(setNames(aa[,2],aa[,1]),method="ClustalOmega",type=type),type="ape::DNAbin"))
for(i in 1:dim(aa)[1]){
	aa[i,3]<-unname(aligned$seq[which(aligned$nam==aa[i,1])])
};rm(i)

## out into the int/ folder
write.dna(setNames(aa[,3],aa[,1]),paste0(indir,"/int/",outnam,"_aln.fa"),format="fa",nbcol=-1,colsep="",colw=nchar(aa[1,3]))
print(paste("Done",outnam," aligning with ClustalOmega at",Sys.time()))