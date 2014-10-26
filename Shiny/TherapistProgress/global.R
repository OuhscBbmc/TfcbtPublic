# knitr::stitch_rmd(script="./global.R", output="./Data/StitchedOutput/global.md")
# rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. 

############################
#+ LoadSources
# getwd()
source("../.././Manipulation/GroomClientProgress.R") #Load the `GroomClientProgress()` function
# getwd()
#####################################
#' LoadPackages
library(magrittr)

#####################################
#' DeclareGlobals
pathGroupCall <- "../.././DataPhiFree/Raw/TherapistCall.csv"
paletteDark <- RColorBrewer::brewer.pal(n=3, name="Dark2")[c(1,3,2)]
paletteLight <- adjustcolor(paletteDark, alpha.f=.5)

#####################################
#' LoadData
# pathGroupCall <- "./DataPhiFree/Raw/TherapistCall.csv"
dsGroupCall <- read.csv(pathGroupCall, stringsAsFactors=FALSE)
dsClientProgress <- GroomClientProgress(pathGroupCall=pathGroupCall)

#####################################
#' TweakData
