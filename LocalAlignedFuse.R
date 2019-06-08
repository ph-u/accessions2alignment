args = commandArgs(T)

## input from Unix environment
wkdir<-args[[1]]

## load necessary libraries
library(ape)
library(RcmdrMisc)

## define useful functions
combine_by_name<-function(my.pattern,pre_made_col.series){v1<-ls(pattern = my.pattern,envir = parent.frame());Reduce(function(x,y) merge(x,y,by=pre_made_col.series,all=T), mget(v1,envir = parent.frame()))}

## target & import files
tgt<-list.files(path=paste0(wkdir,"/int"),pattern="_aln.fa",full.names=T)
for(i in 1:length(tgt)){
	print(paste("Start importing",tgt[i],"for fusion at",Sys.time()))
	tmp<-as.data.frame(matrix(nrow=length(read.dna(tgt[i],format="fa",as.character = T,as.matrix = F)),ncol=2))
	colnames(tmp)=c("spp",tgt[i])
	tmp[,1]<-names(read.dna(tgt[i],format="fa",as.character = T,as.matrix = F))
	for(j in 1:length(read.dna(tgt[i],format="fa",as.character = T,as.matrix = F))){
		tmp[j,2]<-paste0(unname(unlist(read.dna(tgt[i],format="fa",as.character = T,as.matrix = F)[j])),collapse="")
	}
	assign(paste0("aln_",i),tmp)
};rm(i,j,tmp)

## make alignment fusion
print(paste("Start alignment fusion",Sys.time()))
cmb<-combine_by_name("aln_","spp")
fusSum<-as.data.frame(matrix(nrow=length(colnames(cmb)[-1]),ncol=2))
fusSum[,1]<-colnames(cmb)[-1]
colnames(fusSum)=c("aligned_file","aligned_sequence_length")
for(j in 2:dim(cmb)[2]){
	ggd<-unique(nchar(cmb[,j]))
	fusSum[j-1,2]<-ggd[order(ggd)][1]
	for(i in 1:dim(cmb)[1]){
		if(is.na(cmb[i,j])==T){
			cmb[i,j]<-paste0(rep("n",fusSum[j-1,2]),collapse="")
		}
	}
};rm(i,j,ggd)
fixedNum<-dim(cmb)[2]
for(i in 1:dim(cmb)[1]){
	cmb[i,fixedNum+1]<-paste0(cmb[i,2:fixedNum],collapse="")
};rm(i)

## FASTA output
write.dna(setNames(cmb[,dim(cmb)[2]],cmb[,1]),paste0(wkdir,"/00_all_fused.fa"),format="fa",nbcol=-1,colsep="",colw=nchar(cmb[1,dim(cmb)[2]]))
write.csv(fusSum,paste0(wkdir,"/00_all_fused_summary.csv"),row.names=F,quote=F)
print(paste("Done sequence fusion at",Sys.time()))