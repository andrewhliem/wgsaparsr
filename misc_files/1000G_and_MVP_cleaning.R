library(readr)
a <- read_delim("D:/OneDrive - BOOZ ALLEN HAMILTON/Projects/MVP - GENISIS, Annotation/Projects/wgsa/1000G_and_MVP_snp_sorted.txt", 
                "\t", escape_double = FALSE, col_names = FALSE, 
                trim_ws = TRUE)
colnames(a) <- c("chromosome", "position", "ref", "alt")
dim(a)
#[1] 85525185        4
unique(a$chromosome)
#[1]  1 10 11 12 13 14 15 16 17 18 19  2 20 21 22  3  4  5  6  7  8  9 NA

#remove NA
b <- dplyr::filter(a, !is.na(chromosome)) #3,552,041 removed

sum(is.na(b)) #0 NA

#arrange by chromosome than position
c <- arrange(b, chromosome, position)
dim(c)
#write file
write_tsv(c, path = "D:/OneDrive - BOOZ ALLEN HAMILTON/Projects/MVP - GENISIS, Annotation/Projects/wgsa/1000G_and_MVP_snp_sortedR.txt")
