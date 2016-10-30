# knitr::stitch_rmd(script="./global.R", output="./Data/StitchedOutput/global.md")
# rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. 

# load_sources  -----------------------------------

# load_packages  -----------------------------------

# declare_globals  -----------------------------------

determine_directory <- function( ) {
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
  return( directoryData )
}

load_session_survey <- function( ) {
  dSessionSurvey <- read.csv(file.path(determine_directory(), "SessionSurvey.csv"), stringsAsFactors=FALSE)
  
  dSessionSurvey$trauma_score_caregiver <- as.integer(dSessionSurvey$trauma_score_caregiver)
  dSessionSurvey$trauma_score_child <- as.integer(dSessionSurvey$trauma_score_child)
  dSessionSurvey$session_date <- as.Date(dSessionSurvey$session_date)
  return( dSessionSurvey )
}

load_item_progress <- function ( ) {
  dItemProgress <- read.csv(file.path(determine_directory(), "ItemProgress.csv"), stringsAsFactors=FALSE) #GroomItemProgress(pathSessionSurvey=pathSessionSurvey)
  dItemProgress <- dItemProgress[!is.na(dItemProgress$therapist_tag) & nchar(dItemProgress$therapist_tag)>0, ]
  return( dItemProgress )
}

load_therapist <- function ( ) {
  d_therapist <- read.csv(file.path(determine_directory(), "therapist.csv"), stringsAsFactors=FALSE) 
  d_therapist <- d_therapist[!is.na(d_therapist$therapist_tag) & nchar(d_therapist$therapist_tag)>0, ]
  return( d_therapist )
}

# load_data   -----------------------------------
dsSessionSurvey <- load_session_survey()
dsItemProgress <- load_item_progress()
ds_therapist <- load_therapist()
