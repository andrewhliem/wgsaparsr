
# Load files --------------------------------------------------------------

a_1 <- read_delim("D:/OneDrive - BOOZ ALLEN HAMILTON/Projects/MVP - GENISIS, Annotation/Projects/2019-06-03_wgsa/DATA/1000G_and_MVP_snp_sortedR.txt", 
                  "\t", escape_double = FALSE, trim_ws = TRUE)
a_2 <- read_delim("D:/OneDrive - BOOZ ALLEN HAMILTON/Projects/MVP - GENISIS, Annotation/Projects/2019-06-03_wgsa/DATA/SNP_AA_chip_v2.tsv", 
                  "\t", escape_double = FALSE, trim_ws = TRUE)


# EDA ---------------------------------------------------------------------

head(a_1)
# chromosome position ref   alt  
# <dbl>    <dbl> <chr> <chr>
#   1          1    10177 A     AC   
# 2          1    10235 T     TA   
# 3          1    10352 T     TA   
# 4          1    10505 A     T    
# 5          1    10506 C     G    
# 6          1    10511 G     A    

head(a_2)

# # A tibble: 6 x 5
# num   chr position ref   alt  
# <dbl> <dbl>    <dbl> <chr> <chr>
#   1     1     1   721119 C     T    
# 2     2     1   723918 G     A    
# 3     3     1   728606 G     A    
# 4     4     1   729632 C     T    
# 5     5     1   737130 C     A    
# 6     6     1   740416 A     G     

# Merge file --------------------------------------------------------------
a_2 <- dplyr::select(a_2, 2:5)
colnames(a_2) <- c("chromosome", "position", "ref", "alt")
b <- dplyr::bind_rows(a_1, a_2)
b <- dplyr::arrange(b, chromosome, position)

c <- dplyr::distinct(b) #check if files duplicated; 1,353,944 duplicate rows

#QC; lets see duplicated rows
b$combine = str_c(b$chromosome, b$position, b$ref, b$alt, sep= "_")
dup <- b$combine[duplicated(b$combine)]


# Write file --------------------------------------------------------------

write.table(c, file = "D:/OneDrive - BOOZ ALLEN HAMILTON/Projects/MVP - GENISIS, Annotation/Projects/2019-06-03_wgsa/DATA/DATA_1000G_cv1_cv2_SNPs.tsv",
            sep = "\t", quote = FALSE, row.names = FALSE)


# Clean file for alt/ref errors -------------------------------------------

DATA_1000G_cv1_cv2_SNPs <- read_delim("D:/OneDrive - BOOZ ALLEN HAMILTON/Projects/MVP - GENISIS, Annotation/Projects/2019-06-03_wgsa/DATA/DATA_1000G_cv1_cv2_SNPs.tsv", 
                                      "\t", escape_double = FALSE, trim_ws = TRUE)


DATA_1000G_cv1_cv2_SNPs.tmp <- dplyr::filter(DATA_1000G_cv1_cv2_SNPs, ref != "-") #12,476 where ref = '-'
DATA_1000G_cv1_cv2_SNPs.tmp <- dplyr::filter(DATA_1000G_cv1_cv2_SNPs.tmp, alt != "-") #31,072 where alt = '-'
DATA_1000G_cv1_cv2_SNPs.tmp <- dplyr::filter(DATA_1000G_cv1_cv2_SNPs.tmp, ref != ".") #11 where ref = '.'

DATA_1000G_cv1_cv2_SNPs.tmp = DATA_1000G_cv1_cv2_SNPs.tmp %>% 
  dplyr::filter(!is.na(chromosome)) %>%
  dplyr::filter(!is.na(position)) %>% 
  dplyr::filter(!is.na(ref)) %>%
  dplyr::filter(!is.na(alt))

DATA_1000G_cv1_cv2_SNPs.tmp <- dplyr::filter(DATA_1000G_cv1_cv2_SNPs.tmp, !grepl("<", alt)) #57,628 where alt = <X>
DATA_1000G_cv1_cv2_SNPs.tmp <- dplyr::filter(DATA_1000G_cv1_cv2_SNPs.tmp, !grepl(",", alt)) #41,4423 where alt = <X>

DATA_1000G_cv1_cv2_SNPs.tmp1 = dplyr::distinct(DATA_1000G_cv1_cv2_SNPs.tmp)

write.table(DATA_1000G_cv1_cv2_SNPs.tmp, 
            file = "D:/OneDrive - BOOZ ALLEN HAMILTON/Projects/MVP - GENISIS, Annotation/Projects/2019-06-03_wgsa/DATA/DATA_1000G_cv1_cv2_SNPs_v2.tsv",
            sep = "\t", quote = FALSE, row.names = FALSE)
