# rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. 
# library(lubridate)
library(dplyr)

# dsSessionSurvey <- read.csv("./DataPhiFree/Raw/SessionSurvey.csv", stringsAsFactors=FALSE)
GroomClientSummary <- function( pathSessionSurvey = "./DataPhiFree/Raw/SessionSurvey.csv") {
  #' LoadData
  if( !file.exists(pathSessionSurvey) ) stop("The file `", normalizePath(pathSessionSurvey, mustWork=FALSE), "` does not exist.")
  dsSessionSurvey <- read.csv(pathSessionSurvey, stringsAsFactors=FALSE)
  
  #####################################
  #' Tweak Session Data
    
  dsSessionSurvey <- plyr::rename(dsSessionSurvey, replace=c(
#     "survey_number" = "therapist_id_rc"
  ))
  
#   # Extract client sequence
#   client1 <- grepl(pattern="^session",  dsSessionSurvey$redcap_event_name)
#   client2 <- grepl(pattern="^c2_session",  dsSessionSurvey$redcap_event_name)
#   dsSessionSurvey$client_sequence <- NA_integer_
#   dsSessionSurvey$client_sequence[client1] <- 1L
#   dsSessionSurvey$client_sequence[client2] <- 2L
#   rm(client1, client2)
  
  #####################################
  #' Aggregate on Therapist
  SummarizeClient <- function( d ) {
    data.frame(
      session_count = nrow(d)
    )
  }    
  # SummarizeClient(dsSessionSurvey)

  dsClientSummary <- dsSessionSurvey %>%
    dplyr::filter(!is.na(client_number)) %>%
    dplyr::group_by(therapist_id_rc, client_number) %>%
    dplyr::do(SummarizeClient(.))
  
  return( dsClientSummary)
}

# ds <- GroomClientSummary()
# ds
# write.csv(ds, file="./DataPhiFree/Derived/ClientSummary.csv", row.names=F) #ClientSummary.csv

#' Questions
#' * If there's a record, but no date, did the therapist attend the call?
