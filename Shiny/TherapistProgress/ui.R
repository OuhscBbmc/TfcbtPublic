#Starting with http://shiny.rstudio.com/gallery/basic-datatable.html
library(shiny)

library(ggplot2)
# browser()

# Define the overall UI
shinyUI(
  fluidPage(tabsetPanel( type = "tabs",
    tabPanel(
      title = "Client Progress", 
      titlePanel("Client Progress"),            
      # Create a new Row in the UI for selectInputs
      fluidRow(
        column(width=4, 
          selectInput(inputId="client_progress_therapist_id_rc", label="Therapist Identifier in REDCap:", 
            choices=c("All", unique(as.character(dsClientProgress$therapist_id_rc)))
          )
        ),
        column(width=4, 
          selectInput(inputId="client_progress_client_number", label="Therpist's Client Number:", 
            choices=c("All", unique(as.character(dsClientProgress$client_number)))
          )
        )        
      ), #End fluid row with the dropdown boxes
      # Create a new row for the table.
      fluidRow(
        dataTableOutput(outputId="ClientProgressTable")
      ) #End fluid row with the Group Call table
    ), #End the (first) tab with the Group Call table
    tabPanel(
      title = "Group Call", 
      titlePanel("Group Call"),            
      # Create a new Row in the UI for selectInputs
      fluidRow(
        column(width=4, 
               selectInput(inputId="group_call_survey_number", label="Survey Number:", 
                           choices=c("All", unique(as.character(dsGroupCall$survey_number)))
               )
        ),
        column(width=4, 
               selectInput(inputId="group_call_therapist_identifier", label="Therapist Identifier:", 
                           choices=c("All", unique(as.character(dsGroupCall$therapist_identifier)))
               )
        ),
        column(width=4, 
               selectInput(inputId="group_call_session_month", label="Session Month:", 
                           choices=c("All", unique(as.character(dsGroupCall$session_month)))
               )
        )        
      ), #End fluid row with the dropdown boxes
      # Create a new row for the table.
      fluidRow(
        dataTableOutput(outputId="GroupCallTable")
      ) #End fluid row with the Group Call table
    ) #End the (second) tab with the Group Call table
  )) #End the tabsetPanel and fluidPage
) #End the shinyUI
