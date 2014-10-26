library(shiny)
library(ggplot2)

# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  #######################################
  ### Set any sesion-wide options
  # options(shiny.trace=TRUE)
  
  #######################################
  ### Call source files that contain semi-encapsulated functions.
  
  # Filter Therapist Progress data based on selections
  output$TherapistProgressTable <- renderDataTable({
    if (input$therapist_progress_therapist_id_rc != "All"){
      dsTherapistProgress <- dsTherapistProgress[dsTherapistProgress$therapist_id_rc == input$therapist_progress_therapist_id_rc,]
    }
    if (input$therapist_progress_client_number != "All"){
      dsTherapistProgress <- dsTherapistProgress[dsTherapistProgress$client_number == input$therapist_progress_client_number,]
    }
    return( dsTherapistProgress )
  })
  
  # Filter Group Call data based on selections
  output$GroupCallTable <- renderDataTable({
    if (input$group_call_survey_number != "All"){
      dsGroupCall <- dsGroupCall[dsGroupCall$survey_number == input$group_call_survey_number,]
    }
    if (input$group_call_therapist_identifier != "All"){
      dsGroupCall <- dsGroupCall[dsGroupCall$therapist_identifier == input$group_call_therapist_identifier,]
    }
    if (input$group_call_session_month != "All"){
      dsGroupCall <- dsGroupCall[dsGroupCall$session_month == input$group_call_session_month,]
    }
    return( dsGroupCall )
  })
  
})
