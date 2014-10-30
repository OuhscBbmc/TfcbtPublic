#Starting with http://shiny.rstudio.com/gallery/basic-datatable.html
library(shiny)
library(shiny)
library(ggplot2)
# library(ShinyDash) # To install, run devtools::install_github('ShinyDash', 'trestletech') #See https://groups.google.com/forum/#!topic/shiny-discuss/V7WUQA7aAiI

# Define the overall UI
shinyUI(fluidPage(
  shiny::tags$head(
    includeCSS("./www/styles.css"), # Include our custom CSS
    tags$style("
      .table .smallish {font-size: 80%;padding: 0px;}
      .table .alignRight {text-align: right;font-size: 80%;padding: 0px;}
      .table .semihide {color: #cccccc;font-size: 50%;padding: 0px;}
    ") #Right align the columns of this class (in the DataTables). http://stackoverflow.com/questions/22884224/how-to-right-align-columns-of-datatable-in-r-shiny
  ),#tags$head  
  tabsetPanel( type = "tabs",
    tabPanel(
      title = "Item Progress", 
      HTML("<font color='green'><em>{Elizabeth, is there some explanatory text you'd like here?}</em></font>"),
      titlePanel("Item Progress"),    
      # Create a new Row in the UI for selectInputs
      fluidRow(
        column(width = 9, 
          selectInput(inputId="item_progress_therapist_email", label="Therapist Email:", width="100%",
            choices=c("--Select a Therapist--", sort(unique(as.character(dsItemProgress$therapist_email))))
            # elizabeth-risch@ouhsc.edu
          )
        ),
        column(width = 3, 
          selectInput(inputId="item_progress_client_number", label="Client Number within Therapist:", width="100%", 
            choices=c("All", unique(as.character(dsItemProgress$client_sequence)))
          )
        )#,
        # column(width = 3, 
        #   selectInput(inputId="item_progress_therapist_id_rc", label="Therapist Identifier in REDCap:", 
        #     choices=c("All", unique(as.character(dsItemProgress$therapist_id_rc)))
        #   )
        # )        
      ), #End fluid row with the dropdown boxes
      # Create a new row for the table.
      fluidRow(
        dataTableOutput(outputId = "ItemProgressTable")
      ) #End fluid row with the Group Call table
    ), #End the (first) tab with the Group Call table
    tabPanel(
      title = "Trauma Symptoms", 
      HTML("<font color='green'><em>{We need to discuss this graph: https://github.com/OuhscBbmc/Tfcbt/issues/10}</em></font>"),
      titlePanel("Trauma Symptoms"), 
      "Tracking symptom severity over the life of the TF-CBT case. Trainers suggest, at a minimum, administering pre-treatment and post-treatment trauma measures.",
      plotOutput(outputId='trauma_symptoms', width='95%', height='400px')
    ), #End the (second) tab with the symptoms
    tabPanel(
      title = "Client Progress", 
      HTML("<font color='green'><em>{This tab is primarily for development, and won't be shown in the release version.}</em></font>"),
      titlePanel("Client Progress"),            
      # Create a new Row in the UI for selectInputs
      fluidRow(
        column(width = 4, 
          selectInput(inputId="client_progress_therapist_id_rc", label="Therapist Identifier in REDCap:", 
            choices=c("All", unique(as.character(dsClientSummary$therapist_id_rc)))
          )
        ),
        column(width = 4, 
          selectInput(inputId="client_progress_client_number", label="Client Number within Therapist:", 
            choices=c("All", unique(as.character(dsClientSummary$client_number)))
          )
        )        
      ), #End fluid row with the dropdown boxes
      # Create a new row for the table.
      fluidRow(
        dataTableOutput(outputId = "ClientProgressTable")
      ) #End fluid row with the Group Call table
    ), #End the (third) tab with the Group Call table
    tabPanel(
      title = "Session Summary", 
      HTML("<font color='green'><em>{This tab is primarily for development, and won't be shown in the release version.}</em></font>"),
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
    ) #End the (fourth) tab with the Session Summary table
  ) #End the tabsetPanel
)) #End the fluidPage and shinyUI
