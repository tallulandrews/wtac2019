anno <- read.table("wtac_lane_barcode_metadata.csv", sep=",", header=T)
seq_metadata <- read.table("Lane_output_summary.csv", sep=",", header=T)

head(anno)
head(seq_metadata)

# merge_barcodes in anno
anno$Barcode <- paste(anno$index, anno$index2, sep="-")
sum(anno$Barcode %in% seq_metadata$Barcode)
dim(anno)

Metadata <- merge(seq_metadata, anno)
Metadata <- Metadata[order(Metadata$Tag.Index),]
Metadata
Metadata$CellID <- paste("Cell", Metadata$Tag.Index, sep="")

# Read in counts matrix:
mouse_counts <- read.delim("mouse.counts", header=T, sep="\t")
head(mouse_counts)
rownames(mouse_counts) <- mouse_counts[,1]
mouse_counts<- mouse_counts[,-1]
head(mouse_counts)

# Extract file number (aka "Tag.Index") from the column names.
cellids <- colnames(mouse_counts)
cellids <- sub("X30276_1\\.", "", cellids)
cellids <- sub("_._trimmed", "", cellids)
cellids <- paste("Cell", cellids, sep="")

colnames(mouse_counts) <- cellids;

dim(mouse_counts)
dim(Metadata)
sum(colnames(mouse_counts) %in% Metadata$CellID)

Metadata[!Metadata$CellID %in% colnames(mouse_counts),]



# Read in counts matrix:
human_counts <- read.delim("human.counts", header=T, sep="\t")
head(human_counts)
rownames(human_counts) <- human_counts[,1]
human_counts<- human_counts[,-1]
head(human_counts)

# Extract file number (aka "Tag.Index") from the column names.
cellids <- colnames(human_counts)
cellids <- sub("X30276_1\\.", "", cellids)
cellids <- sub("_._trimmed", "", cellids)
cellids <- paste("Cell", cellids, sep="")

colnames(human_counts) <- cellids;

dim(human_counts)
dim(Metadata)
sum(colnames(human_counts) %in% Metadata$CellID)

Metadata[!Metadata$CellID %in% colnames(human_counts),]




total_mouse <- colSums(mouse_counts)
total_human <- colSums(human_counts)

tidy_res <- Metadata
tidy_res$total_human <- total_human[match(tidy_res$CellID, names(total_human))]
tidy_res$total_mouse <- total_mouse[match(tidy_res$CellID, names(total_mouse))]


# Plotting
colours <- c("red", "forestgreen", "blue")

plot(tidy_res$total_human/tidy_res$N_Reads, tidy_res$total_mouse/tidy_res$N_Reads, col=colours[tidy_res$sample], pch=16, cex=2, xlab="%human", ylab="%mouse")
legend("topright", levels(tidy_res$sample), fill=colours)

