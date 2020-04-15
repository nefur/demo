library(ggbio)
set.seed(1)
N <- 100
require(GenomicRanges)
## ======================================================================
##  simmulated GRanges
## ======================================================================
gr <- GRanges(seqnames =
                sample(c("chr1", "chr2", "chr3"),
                       size = N, replace = TRUE),
              IRanges(
                start = sample(1:300, size = N, replace = TRUE),
                width = sample(70:75, size = N,replace = TRUE)),
              strand = sample(c("+", "-", "*"), size = N,
                              replace = TRUE),
              value = rnorm(N, 10, 3), score = rnorm(N, 100, 30),
              sample = sample(c("Normal", "Tumor"),
                              size = N, replace = TRUE),
              pair = sample(letters, size = N,
                            replace = TRUE))


## ======================================================================
##  default
## ======================================================================
ggplot(gr) + geom_alignment()
## or
ggplot() + geom_alignment(gr)

## ======================================================================
##  facetting and aesthetics
## ======================================================================
ggplot(gr) + geom_alignment(facets = sample ~ seqnames, aes(color = strand, fill = strand))

## ======================================================================
##  stat:stepping
## ======================================================================
ggplot(gr) + geom_alignment(stat = "stepping", aes(group = pair))

## ======================================================================
##  group.selfish controls when
## ======================================================================
ggplot(gr) + geom_alignment(stat = "stepping", aes(group = pair), group.selfish = FALSE)

## =======================================
##  main/gap geom
## =======================================
ggplot(gr) + geom_alignment(range.geom = "arrowrect", gap.geom = "chevron")

## =======================================
##  For TxDb
## =======================================
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
data(genesymbol, package = "biovizBase")
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
## made a track comparing full/reduce stat.
ggbio() + geom_alignment(data = txdb, which = genesymbol["RBM17"])
p1 <- ggplot(txdb) + geom_alignment(which = genesymbol["RBM17"])
p1
p2 <- ggplot(txdb) + geom_alignment(which = genesymbol["RBM17"], stat = "reduce")
tracks(full = p1, reduce = p2, heights = c(3, 1))
tracks(full = p1, reduce = p2, heights = c(3, 1)) + theme_tracks_sunset()
tracks(full = p1, reduce = p2, heights = c(3, 1)) +
  theme_tracks_sunset(axis.line.color = NA)
## change y labels
ggplot(txdb) + geom_alignment(which = genesymbol["RBM17"], names.expr = "tx_id:::gene_id")