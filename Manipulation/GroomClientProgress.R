rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. 
# library(lubridate)
library(dplyr)

# dsSession <- read.csv("./DataPhiFree/Raw/TherapistCall.csv", stringsAsFactors=FALSE)
GroomClientProgress <- function( pathGroupCall = "./DataPhiFree/Raw/TherapistCall.csv") {
  #' LoadData
  if( !file.exists(pathGroupCall) ) stop("The file `", normalizePath(pathGroupCall, mustWork=FALSE), "` does not exist.")
  dsSession <- read.csv(pathGroupCall, stringsAsFactors=FALSE)
  
  #####################################
  #' Tweak Session Data
  dsSession$session_month <- strftime(dsSession$session_date, format = "%Y-%m")
    
  dsSession <- plyr::rename(dsSession, replace=c(
    "survey_number" = "therapist_id_rc"
  ))
  
#   # Extract client sequence
#   client1 <- grepl(pattern="^session",  dsSession$redcap_event_name)
#   client2 <- grepl(pattern="^c2_session",  dsSession$redcap_event_name)
#   dsSession$client_sequence <- NA_integer_
#   dsSession$client_sequence[client1] <- 1L
#   dsSession$client_sequence[client2] <- 2L
#   rm(client1, client2)
  
  #####################################
  #' Aggregate on Therapist
  #   summarizeTherapistClient <- function( d ) {
  #     data.frame(
  #       call_count = nrow(d)
  #     )
  #   }
    
  # summarizeTherapistClient(dsSession)
  dsProgress <- dsSession %>%
    dplyr::filter(!is.na(client_number)) %>%
    dplyr::group_by(therapist_id_rc, client_number) %>%
    # dplyr::do(summarizeTherapistClient)
    dplyr::summarise(
      call_count = sum(!is.na(session_date))
    )
  dsProgress
  return( dsProgress)
}

# ds <- GroomClientProgress()
# ds
# write.csv(ds, file="./DataPhiFree/Derived/ClientProgress.csv", row.names=F)

#' Questions
#' * If there's a record, but no date, did the therapist attend the call?
