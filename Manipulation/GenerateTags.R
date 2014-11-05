subjectCount <- 1000L

DrawTag <- function( tagLength=4L, urn=c(0:9, letters) ) {
  paste(sample(urn, size=tagLength, replace=T), collapse="")
}

DrawTag()
dsTag <- data.frame(
  Tag = sapply(rep(4L, subjectCount), DrawTag),
  stringsAsFactors = FALSE
)

write.csv(dsTag, file="./DataPhiFree/Derived/TagList.csv")
