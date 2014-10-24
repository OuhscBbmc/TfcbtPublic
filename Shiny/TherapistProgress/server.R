library(shiny)

# Load the ggplot2 package which provides
# the 'mpg' dataset.
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
    #     if (input$survey_number != "All"){
    #       dsGroupCall <- dsGroupCall[dsGroupCall$survey_number == input$survey_number,]
    #     }
    #     if (input$therapist_identifier != "All"){
    #       dsGroupCall <- dsGroupCall[dsGroupCall$therapist_identifier == input$therapist_identifier,]
    #     }
    #     if (input$session_month != "All"){
    #       dsGroupCall <- dsGroupCall[dsGroupCall$session_month == input$session_month,]
    #     }
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
