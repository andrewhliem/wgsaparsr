a <- read_delim("C:/Users/598266/OneDrive - BOOZ ALLEN & HAMILTON/Projects/MVP - GENISIS, Annotation/Projects/2019-06-03_wgsa/wgsa_profiling.txt", 
                             "\t", escape_double = FALSE, trim_ws = TRUE)
options(scipen=999)
colnames(a)
#[1] "class"   "type"    "general" "Minutes"

#EDA
a <- arrange(a, desc(Minutes))
aggregate(a$Minutes, by=list(type=a$type), FUN = sum)
    # type    x
    # 1 focal_pseudo_SNV  811
    # 2            indel  454
    # 3              SNV 1356
head(a, n = 10)

b <- dplyr::filter(a, type != "focal_pseudo_SNV" )
head(b, n = 20)
    # class                                        type  general   Minutes
    # <chr>                                        <chr> <chr>       <dbl>
    # 1 ANNOVAR_SnpEff_VEP                           indel 6 h 12 m~     372
    # 2 Integrated_SNV_annotation                    SNV   5 h 15 m~     315
    # 3 CADD_                                        SNV   2 h 11 m~     131
    # 4 fathmm_MKL                                   SNV   2 h 20 m~     102
    # 5 Ensembl_Regulatory_Build_cell_type_specific~ SNV   2 h 38 m~      78
    # 6 Funseq_like_noncoding                        SNV   1 h 42 m~      74
    # 7 RegulomeDB                                   SNV   1 h 25 m~      56
    # 8 Funseq2_noncoding                            SNV   1 h 26 m~      55
    # 9 Denisova_geno.                               SNV   41 min         41
    # 10 Altai_Neandertal_geno.                       SNV   39 min         39
    # 11 SiPhy                                        SNV   1 h 11 m~      37
    # 12 ENCODE_Dnase                                 SNV   28 min         28
    # 13 dbNSFP                                       SNV   28 min         28
    # 14 FAMTOM5_CAGE                                 SNV   27 min         27
    # 15 FAMTOM5_enhancer                             SNV   26 min         26
    # 16 GERP__                                       SNV   43 min         25
    # 17 ExAC_allele_freq.                            SNV   23 min         23
    # 18 OregAnno                                     SNV   23 min         23
    # 19 ExAC_allele_freq.                            indel 1 min          23
    # 20 Duke_mapability                              SNV   34 min         21

#Visualize data
b.top = head(b, n = 10)
  #rename so its more fiting
b.top$class = c("integrated.",
                "integrated",
                "CADD",
                "fathmm_MKL",
                "Ensembl_regu",
                "Funseq (noncod)",
                "ReguulomeDB",
                "Funseq2 (noncod)",
                "Denisova",
                "Altai_Neandertal") 

ggplot(b.top, aes(x = reorder(class, Minutes), Minutes, fill = type)) + 
  geom_col() + 
  scale_y_continuous(breaks = seq(0,420,30),
                     limits = c(0,420)) +
  labs(x = "annotation step", y= "minutes") + 
  theme_bw() +
  theme(axis.text.x = element_text(angle = 20),
        legend.position = "none") + 
  coord_flip()
  
  
  