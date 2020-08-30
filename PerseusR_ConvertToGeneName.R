
# Parse command line arguments passed in from Perseus,
# including input file and output file paths.
args = commandArgs(trailingOnly=TRUE)
if (length(args) != 2) {
  stop("Do not provide additional arguments!", call.=FALSE)
}
inFile <- args[1]
outFile <- args[2]


# Use PerseusR to read and write the data in Perseus text format.
library(PerseusR)
mdata <- read.perseus(inFile)

# The mdata object can be easily deconstructed into a number of different
# data frames. Check reference manual or help() for full list.
colMatrix <- annotCols(mdata)
#====================================================================================-
library(stringr)
df <- colMatrix

# import UniProt tab file
UniprotDB <- read.delim("~/Perseus_R/uniprot-reviewed_yes+taxonomy_9606.tab")

library(dplyr)
# Leave only the first Gene name of Gene.names column
UniprotDB$Gene_name <- substr(UniprotDB$Gene.names, 1, str_locate(string = UniprotDB$Gene.names, pattern = " |$")-1)
UniprotDB <- select(UniprotDB, Entry, Gene_name)
df <- merge(df, 
            UniprotDB, 
            by.x = "Accession", 
            by.y = "Entry",
            all.x = TRUE)

#Protein without gene name is -
df$Gene_name[is.na(df$Gene_name)] <- "-"
write.perseus(df, outFile)
