# knitr::stitch_rmd(script="./global.R", output="./Data/StitchedOutput/global.md")
# rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. 

############################
#+ LoadSources
# getwd()
# source("../.././Manipulation/GroomClientSummary.R") #Load the `GroomClientSummary()` function
# source("../.././Manipulation/GroomItemProgress.R") #Load the `GroomClientProgress()` function
# getwd()
#####################################
#' LoadPackages
# library(magrittr)

#####################################
#' DeclareGlobals
directoryServerOutside <- "//bbmc-shiny-public/Anonymous/TfcbtPublic"
directoryServerInside <- "/var/shinydata/TfcbtPublic"
directoryRepo <- "./DataPhiFree"

if( file.exists(directoryServerOutside) ) {
  directoryData <- directoryServerOutside  
} else if( file.exists(directoryServerInside) ) {
  directoryData <- directoryServerInside  
} else {
  directoryData <- directoryRepo
}
rm(directoryServerOutside, directoryServerInside, directoryRepo)

# pathSessionSurvey <- "./DataPhiFree/Raw/SessionSurvey.csv" #This is for testing when the working directory isn't changed by Shiny
pathSessionSurvey <- file.path(directoryData, "SessionSurvey.csv")
# pathItemProgress <- "../.././DataPhiFree/Raw/ItemProgress.csv"
# pathItemProgress <- "./DataPhiFree/ItemProgress.csv"
pathItemProgress <- file.path(directoryData, "ItemProgress.csv")

#####################################
#' LoadData
dsSessionSurvey <- read.csv(pathSessionSurvey, stringsAsFactors=FALSE)
# dsClientSummary <- GroomClientSummary(pathSessionSurvey=pathSessionSurvey)
dsItemProgress <- read.csv(pathItemProgress, stringsAsFactors=FALSE) #GroomItemProgress(pathSessionSurvey=pathSessionSurvey)

# rm(pathSessionSurvey, pathItemProgress)
#####################################
#' TweakData
dsSessionSurvey$trauma_score_caregiver <- as.integer(dsSessionSurvey$trauma_score_caregiver)
dsSessionSurvey$trauma_score_child <- as.integer(dsSessionSurvey$trauma_score_child)
dsSessionSurvey$session_date <- as.Date(dsSessionSurvey$session_date)

dsItemProgress <- dsItemProgress[!is.na(dsItemProgress$therapist_tag) & nchar(dsItemProgress$therapist_tag)>0, ]
