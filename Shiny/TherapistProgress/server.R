library(shiny)
library(ggplot2)

# Define a server for the Shiny app
shinyServer( function(input, output) {
  
  #######################################
  ### Set any sesion-wide options
  # options(shiny.trace=TRUE)
  
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
    if (input$group_call_survey_id != "All")
      dsSessionSurvey <- dsSessionSurvey[dsSessionSurvey$survey_id == input$group_call_survey_id,]
    if (input$group_call_therapist_identifier != "All")
      dsSessionSurvey <- dsSessionSurvey[dsSessionSurvey$therapist_identifier == input$group_call_therapist_identifier,]
    if (input$group_call_session_ym != "All")
      dsSessionSurvey <- dsSessionSurvey[dsSessionSurvey$session_ym == input$group_call_session_ym,]

    return( dsSessionSurvey )
  })
  
})
