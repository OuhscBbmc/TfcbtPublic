# rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. 
library(lubridate)

GroomTherapistProgress <- function( pathIn = "./DataPhiFree/Raw/TherapistProgress.csv") {
  #' LoadData
  if( !file.exists(pathIn) ) stop("The file `", normalizePath(pathIn, mustWork=FALSE), "` does not exist.")
  ds <- read.csv(pathIn, stringsAsFactors=FALSE)
  
  #####################################
  #' TweakData
  ds$session_month <- strftime(ds$session_date, format = "%Y-%m")
    
  #####################################
  #' SaveData

  return( ds)
}

# GroomTherapistProgress()
