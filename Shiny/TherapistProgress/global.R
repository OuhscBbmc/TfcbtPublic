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
dsSessionSurvey$session_date <- as.Date(dsSessionSurvey$session_date)
dsSessionSurvey <- plyr::rename(dsSessionSurvey, replace=c(
  "caregiver_score" = "trauma_score_caregiver",
  "child_score" = "trauma_score_child"
))

dsSessionSurvey$trauma_score_caregiver <- as.integer(dsSessionSurvey$trauma_score_caregiver)
dsSessionSurvey$trauma_score_child <- as.integer(dsSessionSurvey$trauma_score_child)

dWide <- dsSessionSurvey[(dsSessionSurvey$therapist_id_rc>0) & (dsSessionSurvey$client_number>0), c("session_date", "trauma_score_caregiver", "trauma_score_child")]   
dLong <- reshape2::melt(dWide, id.vars="session_date", variable.name="respondent", value.name="score")
dLong$respondent <- gsub("^trauma_score_(.*)$", "\\1", dLong$respondent)
# dLong

shape_respondent_dark <- c("child"=21, "caregiver"=25)
color_respondent_dark <- c("child"="#1f78b4", "caregiver"="#33a02c")
color_respondent_light <- grDevices::adjustcolor(color_respondent_dark, alpha.f = .2)
names(color_respondent_light) <- names(color_respondent_dark)

ggplot(dLong, aes(x=session_date, y=score, color=respondent, fill=respondent, shape=respondent)) +
  geom_point(size=10) +
  geom_line() +
  scale_color_manual(values=color_respondent_dark) +
  scale_fill_manual(values=color_respondent_light) +
  scale_shape_manual(values=shape_respondent_dark) +  
  coord_cartesian(ylim=c(0, 60))
