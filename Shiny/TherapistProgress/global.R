# knitr::stitch_rmd(script="./global.R", output="./Data/StitchedOutput/global.md")
# rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. 

# ---- load-sources  -----------------------------------

# ---- load-packages  -----------------------------------
library("magrittr")
requireNamespace("readr")

# ---- declare-globals  -----------------------------------

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


# col_types_item_progress <- readr::cols(
#   description_short        = readr::col_character(),
#   client_number            = readr::col_integer(),
#   item                     = readr::col_character(),
#   description_long         = readr::col_character(),
#   variable_index           = readr::col_integer(),
#   agency_name              = readr::col_character(),
#   call_group_code          = readr::col_character(),
#   session_01               = readr::col_logical(),
#   session_02               = readr::col_logical(),
#   session_03               = readr::col_logical(),
#   session_04               = readr::col_logical(),
#   session_05               = readr::col_logical(),
#   session_06               = readr::col_logical(),
#   session_07               = readr::col_logical(),
#   session_08               = readr::col_logical(),
#   session_09               = readr::col_logical(),
#   session_10               = readr::col_logical(),
#   session_11               = readr::col_logical(),
#   session_12               = readr::col_logical(),
#   session_13               = readr::col_logical(),
#   session_14               = readr::col_logical(),
#   session_15               = readr::col_logical(),
#   session_16               = readr::col_logical(),
#   session_17               = readr::col_logical(),
#   session_18               = readr::col_logical(),
#   session_19               = readr::col_logical(),
#   session_20               = readr::col_logical(),
#   session_21               = readr::col_logical(),
#   session_22               = readr::col_logical(),
#   session_23               = readr::col_logical(),
#   session_24               = readr::col_logical(),
#   session_25               = readr::col_logical(),
#   session_26               = readr::col_logical(),
#   session_27               = readr::col_logical(),
#   session_28               = readr::col_logical(),
#   session_29               = readr::col_logical(),
#   session_30               = readr::col_logical(),
#   session_31               = readr::col_logical(),
#   session_32               = readr::col_logical(),
#   session_33               = readr::col_logical(),
#   session_34               = readr::col_logical(),
#   session_35               = readr::col_logical(),
#   session_36               = readr::col_logical(),
#   session_37               = readr::col_logical(),
#   session_38               = readr::col_logical(),
#   session_39               = readr::col_logical(),
#   session_40               = readr::col_logical(),
#   session_41               = readr::col_logical(),
#   session_42               = readr::col_logical(),
#   session_43               = readr::col_logical(),
#   session_44               = readr::col_logical(),
#   session_45               = readr::col_logical(),
#   description_html         = readr::col_character(),
#   therapist_tag            = readr::col_character(),
#   branch_item              = readr::col_integer()
# )

load_session_survey <- function( ) {
  dSessionSurvey <- read.csv(file.path(determine_directory(), "SessionSurvey.csv"), stringsAsFactors=FALSE)
  
  dSessionSurvey$trauma_score_caregiver <- as.integer(dSessionSurvey$trauma_score_caregiver)
  dSessionSurvey$trauma_score_child <- as.integer(dSessionSurvey$trauma_score_child)
  dSessionSurvey$session_date <- as.Date(dSessionSurvey$session_date)
  return( dSessionSurvey )
}

load_item_progress <- function ( ) {
  # dItemProgress <- readr::read_csv(file.path(determine_directory(), "ItemProgress.csv"), col_types=col_types_item_progress) #GroomItemProgress(pathSessionSurvey=pathSessionSurvey)
  dItemProgress <- readr::read_rds(file.path(determine_directory(), "ItemProgress.rds"))
  dItemProgress <- dItemProgress %>%
    tidyr::drop_na(therapist_tag) %>%
    dplyr::filter(nchar(therapist_tag)>0)
  return( dItemProgress )
}

load_therapist <- function ( ) {
  d_therapist <- read.csv(file.path(determine_directory(), "therapist.csv"), stringsAsFactors=FALSE) 
  d_therapist <- d_therapist[!is.na(d_therapist$therapist_tag) & nchar(d_therapist$therapist_tag)>0, ]
  return( d_therapist )
}

# load_data   -----------------------------------
system.time({
dsSessionSurvey <- load_session_survey()
dsItemProgress <- load_item_progress()
ds_therapist <- load_therapist()
})
