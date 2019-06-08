for(i in c("traits","ape","RcmdrMisc")){
  if(i %in% rownames(installed.packages())==F){
      install.packages(i,repos='http://cran.rstudio.com/')
  }
};rm(i)
if("msa" %in% rownames(installed.packages())==F){
    source("http://bioconductor.org/biocLite.R")
    biocLite("msa")
}