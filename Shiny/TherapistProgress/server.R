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
      dsClientProgress <- dsClientProgress[dsClientProgress$therapist_id_rc == input$client_progress_therapist_id_rc,]
    if (input$client_progress_client_number != "All")
      dsClientProgress <- dsClientProgress[dsClientProgress$client_number == input$client_progress_client_number,]

    dsClientProgress <- plyr::rename(dsClientProgress, replace=c(
      "therapist_id_rc" = "Therapist ID in REDCap",
      "client_number" = "Client Number",
      "call_count" = "Call Count"
    ))
    
    return( as.data.frame(dsClientProgress) )
  })
  
  # Filter Group Call data based on selections
  output$GroupCallTable <- renderDataTable({
    if (input$group_call_survey_number != "All")
      dsGroupCall <- dsGroupCall[dsGroupCall$survey_number == input$group_call_survey_number,]
    if (input$group_call_therapist_identifier != "All")
      dsGroupCall <- dsGroupCall[dsGroupCall$therapist_identifier == input$group_call_therapist_identifier,]
    if (input$group_call_session_month != "All")
      dsGroupCall <- dsGroupCall[dsGroupCall$session_month == input$group_call_session_month,]

    return( dsGroupCall )
  })
  
})
