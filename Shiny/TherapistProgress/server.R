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
  
  # Filter data based on selections
  output$table <- renderDataTable({
    data <- ds
    if (input$survey_number != "All"){
      data <- data[data$survey_number == input$survey_number,]
    }
    if (input$therapist_identifier != "All"){
      data <- data[data$therapist_identifier == input$therapist_identifier,]
    }
    if (input$session_month != "All"){
      data <- data[data$session_month == input$session_month,]
    }
    data
  })
  
})
