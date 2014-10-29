# knitr::stitch_rmd(script="./global.R", output="./Data/StitchedOutput/global.md")
# rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. 

############################
#+ LoadSources
# getwd()
source("../.././Manipulation/GroomClientSummary.R") #Load the `GroomClientSummary()` function
# source("../.././Manipulation/GroomItemProgress.R") #Load the `GroomClientProgress()` function
# # getwd()
#####################################
#' LoadPackages
library(magrittr)

#####################################
#' DeclareGlobals

# pathSessionSurvey <- "./DataPhiFree/Raw/SessionSurvey.csv" #This is for testing when the working directory isn't changed by Shiny
pathSessionSurvey <- "../.././DataPhiFree/Raw/SessionSurvey.csv"
pathItemProgress <- "../.././DataPhiFree/Derived/ItemProgress.csv"

paletteDark <- RColorBrewer::brewer.pal(n=3, name="Dark2")[c(1,3,2)]
paletteLight <- adjustcolor(paletteDark, alpha.f=.5)

#####################################
#' LoadData
dsSessionSurvey <- read.csv(pathSessionSurvey, stringsAsFactors=FALSE)
dsClientSummary <- GroomClientSummary(pathSessionSurvey=pathSessionSurvey)
dsItemProgress <- read.csv(pathItemProgress, stringsAsFactors=FALSE) #GroomItemProgress(pathSessionSurvey=pathSessionSurvey)

#####################################
#' TweakData

dsSessionSurvey <- plyr::rename(dsSessionSurvey, replace=c(
#   "survey_number" = "therapist_id_rc"
))
