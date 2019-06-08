args = commandArgs(T)

## input from Unix environment
a<-args[[1]]## source data file full path
b<-args[[2]]## csv (1) / txt (2)
dirname<-args[[3]]## in-folder path
type<-args[[4]]## dna / rna
out<-args[[5]]## out-file name
rest<-args[[6]]## rest minutes

## load necessary libraries
library(traits)
library(msa)
library(ape)

## read source file in either csv / txt form
if(b==1){
    oo<-read.csv(a,header=T,row.names=1,stringsAsFactors=F)
} else {
   oo<-read.table(a,header=T, sep="\t",row.names=1,stringsAsFactors=F,na.strings="NA",blank.lines.skip=F)
}
oo[oo == ""] <- oo[is.na(oo)] <- "ppp"

## create same NULL matrix for sequence download
res<-as.data.frame(matrix(nrow=dim(oo)[1],ncol=dim(oo)[2]))
row.names(res)=row.names(oo)
colnames(res)=colnames(oo)

## create error sequence collector
error<-0

## sequence download + align (dna / rna / aa)
stTime<-Sys.time()
print(paste("Start beating the NCBI for data from",stTime))
for(i in 1:dim(res)[1]){
	for(j in 1:dim(res)[2]){
		cat(paste(row.names(oo)[i],colnames(oo)[j],"; "))
		if(length(grep("ppp",oo[i,j]))==length(grep("/",oo[i,j]))){
			if(nchar(oo[i,j])>3 & length(grep("[[:digit:]]",oo[i,j]))==0){
				res[i,j]<-oo[i,j]
			}else{
				tmp<-ncbi_byid(oo[i,j],verbose=F)
				res[i,j]<-tmp[1,6]
				if(is.na(tmp[1,6])==T){
					error<-c(error,paste(row.names(res)[i],",",colnames(res)[j]))
					}
				rm(tmp)
				Sys.sleep(2)
			}
		}else if(length(grep("/",oo[i,j]))>0){
			tmp1<-unlist(strsplit(oo[i,j],"/"))
			tmp<-ncbi_byid(tmp1,verbose=F)
			res[i,j]<-gsub("-","",consensusString(msa(tmp[,6],method="ClustalOmega",type=type)))
			rm(list=ls(pattern="tmp"))
			Sys.sleep(2)
		}
		if(as.numeric(difftime(Sys.time(),stTime,units="secs"))>(60*10)){
			print(paste("Give NCBI a",rest,"minute teabreak"))
			Sys.sleep(60*rest)
			stTime<-Sys.time()
			print(paste("Continue beating the NCBI from",stTime))
			}
	}
};rm(i,j)

## create same NULL matrix for aligned sequence
res1<-as.data.frame(matrix(nrow=dim(oo)[1],ncol=dim(oo)[2]))
row.names(res1)=row.names(oo)
colnames(res1)=colnames(oo)

## align downloaded sequences
for(j in 1:dim(res)[2]){
	cat(paste("Aligning",colnames(res)[j],"with ClustalOmega; "))
	aligned<-as.alignment(msaConvert(msa(setNames(res[,j],row.names(res)),method="ClustalOmega",type=type),type="ape::DNAbin"))
	for(i in 1:dim(res)[1]){
		res1[i,j]<-unname(aligned$seq[which(aligned$nam==row.names(oo)[i])])
	}
};rm(i,j)

## combine sequence for fasta output
seq<-0
for(i in 1:dim(res1)[1]){
	seq<-c(seq,paste(res1[i,1:dim(res1)[2]],collapse=""))
};rm(i)

## sequence summary
seqSum<-as.data.frame(matrix(nrow=dim(res1)[2],ncol=2))
seqSum[,1]<-colnames(res1)
for(i in 1:dim(seqSum)[1]){
	seqSum[i,2]<-unique(nchar(res1[,i]))[1]
};rm(i)
colnames(seqSum)=c("sequence_name","aligned_length")

## Ending outputs
if(length(error)>1){
	write.table(error[-1],paste0(dirname,"/Seq_Data_Cant_Download.txt"),sep="\t",quote=F,col.names=F,row.names=F)
}
write.dna(setNames(seq[-1],row.names(res1)),paste0(dirname,"/",out,".fa"),format="fa",nbcol=-1,colsep="",colw=nchar(seq[length(seq)]))
write.csv(seqSum,paste0(dirname,"/",out,"_Summary.csv"),row.names=F,quote=F)
print(paste("Whole download finished on",Sys.time()))