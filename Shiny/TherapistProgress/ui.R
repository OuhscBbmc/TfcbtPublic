#Starting with http://shiny.rstudio.com/gallery/basic-datatable.html
library(shiny)

library(ggplot2)
# browser()

# Define the overall UI
shinyUI(
  fluidPage(tabsetPanel( type = "tabs",
    tabPanel(
      title = "Item Progress", 
      titlePanel("Item Progress"),            
      # Create a new Row in the UI for selectInputs
      fluidRow(
        column(width = 4, 
          selectInput(inputId="item_progress_therapist_id_rc", label="Therapist Identifier in REDCap:", 
            choices=c("All", unique(as.character(dsItemProgress$therapist_id_rc)))
          )
        ),
        column(width = 4, 
          selectInput(inputId="item_progress_client_number", label="Therapist's Client Number:", 
            choices=c("All", unique(as.character(dsItemProgress$client_sequence)))
          )
        )        
      ), #End fluid row with the dropdown boxes
      # Create a new row for the table.
      fluidRow(
        dataTableOutput(outputId = "ItemProgressTable")
      ) #End fluid row with the Group Call table
    ), #End the (first) tab with the Group Call table
    tabPanel(
      title = "Client Progress", 
      titlePanel("Client Progress"),            
      # Create a new Row in the UI for selectInputs
      fluidRow(
        column(width = 4, 
          selectInput(inputId="client_progress_therapist_id_rc", label="Therapist Identifier in REDCap:", 
            choices=c("All", unique(as.character(dsClientSummary$therapist_id_rc)))
          )
        ),
        column(width = 4, 
          selectInput(inputId="client_progress_client_number", label="Therapist's Client Number:", 
            choices=c("All", unique(as.character(dsClientSummary$client_number)))
          )
        )        
      ), #End fluid row with the dropdown boxes
      # Create a new row for the table.
      fluidRow(
        dataTableOutput(outputId = "ClientProgressTable")
      ) #End fluid row with the Group Call table
    ), #End the (second) tab with the Group Call table
    tabPanel(
      title = "Session Summary", 
      titlePanel("Session Summary"),            
      # Create a new Row in the UI for selectInputs
      fluidRow(
        column(width = 4, 
          selectInput(inputId="group_call_survey_id", label="Survey ID:", 
            choices=c("All", unique(as.character(dsSessionSurvey$survey_id)))
          )
        ),
        column(width = 4, 
          selectInput(inputId="group_call_therapist_identifier", label="Therapist Identifier:", 
            choices=c("All", unique(as.character(dsSessionSurvey$therapist_identifier)))
          )
        ),
        column(width = 4, 
          selectInput(inputId="group_call_session_ym", label="Session Month:", 
            choices=c("All", unique(as.character(dsSessionSurvey$session_ym)))
          )
        )        
      ), #End fluid row with the dropdown boxes
      # Create a new row for the table.
      fluidRow(
        dataTableOutput(outputId = "SessionSummaryTable")
      ) #End fluid row with the Session Summary table
    ) #End the (second) tab with the Session Summary table
  )) #End the tabsetPanel and fluidPage
) #End the shinyUI
