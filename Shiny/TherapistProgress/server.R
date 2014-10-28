library(shiny)
library(ggplot2)
library(magrittr)

source("../.././Manipulation/GroomClientSummary.R") #Load the `GroomClientSummary()` function
source("../.././Manipulation/GroomItemProgress.R") #Load the `GroomClientProgress()` function
# getwd()
#####################################
#' LoadPackages

#####################################
#' DeclareGlobals

# pathSessionSurvey <- "./DataPhiFree/Raw/SessionSurvey.csv" #This is for testing when the working directory isn't changed by Shiny
pathSessionSurvey <- "../.././DataPhiFree/Raw/SessionSurvey.csv"

paletteDark <- RColorBrewer::brewer.pal(n=3, name="Dark2")[c(1,3,2)]
paletteLight <- adjustcolor(paletteDark, alpha.f=.5)

#####################################
#' LoadData
dsSessionSurvey <- read.csv(pathSessionSurvey, stringsAsFactors=FALSE)
dsClientSummary <- GroomClientSummary(pathSessionSurvey=pathSessionSurvey)
dsItemProgress <- GroomItemProgress(pathSessionSurvey=pathSessionSurvey)

#####################################
#' TweakData

dsSessionSurvey <- plyr::rename(dsSessionSurvey, replace=c(
  #   "survey_number" = "therapist_id_rc"
))

# Define a server for the Shiny app
shinyServer( function(input, output) {
  
  #######################################
  ### Set any sesion-wide options
  options(shiny.trace=TRUE)
  
  #######################################
  ### Call source files that contain semi-encapsulated functions.
  
  # Filter Client Progress data based on selections
  output$ClientProgressTable <- renderDataTable({
    if (input$client_progress_therapist_id_rc != "All")
      dsClientSummary <- dsClientSummary[dsClientSummary$therapist_id_rc == input$client_progress_therapist_id_rc,]
    if (input$client_progress_client_number != "All")
      dsClientSummary <- dsClientSummary[dsClientSummary$client_number == input$client_progress_client_number,]

    dsClientSummary <- plyr::rename(dsClientSummary, replace=c(
      "therapist_id_rc" = "Therapist ID in REDCap",
      "client_number" = "Client Number",
      "session_count" = "Session Count"
    ))
    
    return( as.data.frame(dsClientSummary) )
  })
  
  # Filter SessionSummary data based on selections
  output$SessionSummaryTable <- renderDataTable({
#     pathSessionSurvey <- "../.././DataPhiFree/Raw/SessionSurvey.csv"
#     exists <- file.exists(pathSessionSurvey)
#     dsSessionSurvey <- read.csv(pathSessionSurvey, stringsAsFactors=FALSE)
#     dsSessionSurvey
#     data.frame("eeeeeeeeeeeee", exists)
    if (input$group_call_survey_id != "All")
      dsSessionSurvey <- dsSessionSurvey[dsSessionSurvey$survey_id == input$group_call_survey_id,]
    if (input$group_call_therapist_identifier != "All")
      dsSessionSurvey <- dsSessionSurvey[dsSessionSurvey$therapist_identifier == input$group_call_therapist_identifier,]
    if (input$group_call_session_ym != "All")
      dsSessionSurvey <- dsSessionSurvey[dsSessionSurvey$session_ym == input$group_call_session_ym,]

    return( dsSessionSurvey )
  })
  
})
