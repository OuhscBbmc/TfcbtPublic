#Starting with http://shiny.rstudio.com/gallery/basic-datatable.html
library(shiny)

library(ggplot2)
# browser()

# Define the overall UI
shinyUI(
  fluidPage(
    titlePanel("Group Call"),
          
    # Create a new Row in the UI for selectInputs
    fluidRow(
      column(4, 
          selectInput("survey_number", 
                      "Survey Number:", 
                      c("All", 
                        unique(as.character(dsGroupCall$survey_number))))
      ),
      column(4, 
          selectInput("therapist_identifier", 
                      "Therapist Identifier:", 
                      c("All", 
                        unique(as.character(dsGroupCall$therapist_identifier))))
      ),
      column(4, 
          selectInput("session_month", 
                      "Session Month:", 
                      c("All", 
                        unique(as.character(dsGroupCall$session_month))))
      )        
    ),
    # Create a new row for the table.
    fluidRow(
      dataTableOutput(outputId="GroupCallTable")
    )    
  )  
)
