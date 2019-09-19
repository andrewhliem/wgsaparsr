if (!requireNamespace("BiocManager", quietly=TRUE))
  install.packages("BiocManager")
BiocManager::install('CVE')
library(CVE)
#load package
library(RTCGAToolbox)

#load all colorectal cancer data 
crcData <- getFirehoseData(dataset="COAD",
                           clinical=TRUE,
                           Mutation=TRUE,
                           runDate="20160128")
#pick a single patient for case study
mutData <- selectType(crcData, "Mutation")
crcCase_Firehouse <- mutData[mutData[["Tumor_Sample_Barcode"]] == 
                               "TCGA-AA-A00N-01A-02W-A00E-09",]
crcCase_input = data.frame(chr=crcCase_Firehouse$Chromosome,
                           start=crcCase_Firehouse$Start_position,
                           end=crcCase_Firehouse$End_position,
                           reference_allele=crcCase_Firehouse$Reference_Allele,
                           observed_allele=crcCase_Firehouse$Tumor_Seq_Allele2)
library(jsonlite)
crcCase <- get.oncotator.anno(crcCase_input)
openCVE(crcCase)
