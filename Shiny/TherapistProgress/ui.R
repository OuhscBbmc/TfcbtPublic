#Starting with http://shiny.rstudio.com/gallery/basic-datatable.html
library(shiny)
library(shiny)
library(ggplot2)

# library(ShinyDash) # To install, run devtools::install_github('ShinyDash', 'trestletech') #See https://groups.google.com/forum/#!topic/shiny-discuss/V7WUQA7aAiI

# Define the overall UI
shinyUI(fluidPage(
  shiny::tags$head(
    includeCSS("./www/styles.css"), # Include our custom CSS
    #;font-family:courier
    tags$style("
      .table .session {font-size: 80%;padding: 0px; text-align:center}
      .table .smallish {font-size: 100%;padding: 0px; }
      .table .alignRight {text-align: right;font-size: 80%;padding: 0px;}
      .table .semihide {color: #dddddd;padding: 0px;}
      .table .quasihide {color: #cccccc;font-size: 10%;padding: 0px;}
    ") #Right align the columns of this class (in the DataTables). http://stackoverflow.com/questions/22884224/how-to-right-align-columns-of-datatable-in-r-shiny
  ),#tags$head  
  h1("TF-CBT"),
  fluidRow(
    column(width = 9, 
      selectInput(inputId="agency_name", label="Agency Name:", width="100%", 
        choices=c("--Select an Agency--", sort(unique(as.character(dsItemProgress$agency_name))))
      )
    ),
    column(width = 3, 
      selectInput(inputId="call_group_code", label="Call Group Code:", width="100%", 
                  choices=sort(unique(as.character(dsItemProgress$call_group_code)))
      )
    )      
  ), #End fluid row with the agency & call group dropdown boxes
    fluidRow(
    column(width = 9, 
      selectInput(inputId="therapist_tag", label="Therapist Tag:", width="100%", selected = "kobl",
        choices=c("--Select a Therapist--", sort(unique(as.character(dsItemProgress$therapist_tag))))
      )
    ),
    column(width = 3, 
      selectInput(inputId="client_number", label="Client within Therapist:", width="100%", selected = 2,
                  choices=sort(unique(as.character(dsItemProgress$client_number)))
      )
    )      
  ), #End fluid row with the tag & client_number dropdown boxes
  tabsetPanel( type = "tabs",
    tabPanel(
      title = "TF-CBT Session Tracking", 
      # HTML("<font color='green'><em>{Elizabeth, is there some explanatory text you'd like here?}</em></font>"),
      # titlePanel("Item Progress"),    
      # Create a new Row in the UI for selectInputs
      # Create a new row for the table.
      fluidRow(
        dataTableOutput(outputId = "ItemProgressTable")
      ), #End fluid row with the Group Call table
      shiny::icon("code") #This is a little cheat to get the table icons work
    ), #End the (first) tab with the Group Call table
    tabPanel(
      title = "Trauma Symptom Tracking", 
      # HTML("<font color='green'><em>{We need to discuss this graph: https://github.com/OuhscBbmc/Tfcbt/issues/10}</em></font>"),
      # titlePanel("Trauma Symptoms"), 
      "Tracking symptom severity over the life of the TF-CBT case. Trainers suggest, at a minimum, administering pre-treatment and post-treatment trauma measures.",
      plotOutput(outputId='trauma_symptoms', width='95%', height='400px')
    ) #End the (second) tab with the symptoms
  ) #End the tabsetPanel
)) #End the fluidPage and shinyUI
