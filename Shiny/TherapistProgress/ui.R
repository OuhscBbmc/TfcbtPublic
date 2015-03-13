#Starting with http://shiny.rstudio.com/gallery/basic-datatable.html
library(shiny)
library(shiny)
library(ggplot2)

# library(ShinyDash) # To install, run devtools::install_github('ShinyDash', 'trestletech') #See https://groups.google.com/forum/#!topic/shiny-discuss/V7WUQA7aAiI

# Define the overall UI
shinyUI(fluidPage(theme="bootstrap_lumen.css",
  shiny::tags$head(
    includeCSS("./www/styles.css"), # Include our custom CSS
    #;font-family:courier
#     tags$style('
#       h1 { color:#7D647D; }
#       .accent { color:#7D647D; }
#       body { background-image:url("images/bg2c.jpg"); }
#       .table.dataTable th { background-color:#7D647D; color:white;  }
#       .table.dataTable tr.odd { background-color: white; }
#       .table.dataTable tr.even{ background-color: #eee; }
#       .table .session { font-size:80%; text-align:center; }
#       .table .smallish { font-size:100%; text-align:center; }
#       .table .semihide { color:#dddddd; }
#       .table .quasihide { color:#cccccc; font-size:10%; }
#       .alignLeft { text-align:left; }
#       .outcome { text-align:center; }
#       .hanging { padding-left:2em; text-indent:-2em; margin:0; }
#       .flush { padding-left:0em; text-indent:0em; margin:0; }
#     ') #Right align the columns of this class (in the DataTables). http://stackoverflow.com/questions/22884224/how-to-right-align-columns-of-datatable-in-r-shiny
#   # .table .alignRight { text-align:right; font-size:80%; }
  
      tags$style('
        h1 { color:#7D647D; }
        .accent { color:#7D647D;  }
        body { background-image:url("images/bg2c.jpg"); }
        .table.dataTable th { background-color:#7D647D; color:white; }
        .table.dataTable tr.odd { background-color: white; }
        .table.dataTable tr.even{ background-color: #eee; }
        .table .session { font-size:80%; padding:0px; text-align:center; }
        .table .smallish { font-size:100%; padding:0px 10px 0px 0px ; }
        .table .alignRight { text-align:right; font-size:80%; padding:0px; }
        .table .semihide { color:#dddddd; padding:0px; }
        .table .quasihide { color:#cccccc; font-size:10%; padding:0px; }
        .hanging { padding-left:3em; text-indent:-2em; margin:0; }
        .flush { padding-left:1em; text-indent:0em; margin:0; }
        .alignLeft { text-align:left; }
        .outcome { text-align:center; }
      ')  
#       tags$style('
#         h1 { color:#7D647D; }
#         .accent { color:#7D647D;  }
#         body { background-image:url("images/bg2c.jpg"); }
#         .table.dataTable th { background-color:#7D647D; color:white; }
#         .table.dataTable tr.odd { background-color: white; }
#         .table.dataTable tr.even{ background-color: #eee; }
#         .table .session { font-size:80%; padding:0px; text-align:center; }
#         .table .smallish { font-size:100%; padding:0px; }
#         .table .alignRight { text-align:right; font-size:80%; padding:0px; }
#         .table .semihide { color:#dddddd; padding:0px; }
#         .table .quasihide { color:#cccccc; font-size:10%; padding:0px; }
#         .hanging { padding-left:3em; text-indent:-2em; margin:0; }
#         .flush { padding-left:1em; text-indent:0em; margin:0; }
#       ')
  
  ),#tags$head  
  headerPanel("TF-CBT"),
  HTML('<div id="logo">
				  <a href="http://oklahomatfcbt.org/"><img src="images/cropped-OK_TF-CBT_logo_v9_1_1_a_1.png" width="450" height="150" alt="Oklahoma TF-CBT"/></a>
			  </div>'
  ),

  fluidRow(
    column(width = 9, 
      selectizeInput(
        inputId="agency_names", label="Filter by Agency Name(s):", width="100%", multiple=TRUE,
        choices=c("--All--", sort(unique(as.character(dsItemProgress$agency_name))))        
      )
    ),
    column(width = 3, 
      selectizeInput(
        inputId="call_group_codes", label="Filter by Call Group(s):", width="100%", multiple=TRUE,
        choices=c("--All--", sort(unique(as.character(dsItemProgress$call_group_code))))
      )
    )      
  ), #End fluid row with the agency & call group dropdown boxes
  fluidRow(
    column(width = 9, 
      selectInput(
        inputId="therapist_tag", label="Select Therapist Tag:", width="100%", #selected="kobl",
        choices=c("--Select a Therapist--", sort(unique(as.character(dsItemProgress$therapist_tag))))
      )
    ),
    column(width = 3, 
      selectInput(
        inputId="client_number", label="Select Therapist's Client:", width="100%", #selected=2,
        choices=sort(unique(as.character(dsItemProgress$client_number)))
      )
    )      
  ), #End fluid row with the tag & client_number dropdown boxes
  tabsetPanel( type = "tabs",
    tabPanel(
      title = "TF-CBT Session Tracking", 
      # HTML("<font color='green'><em>{Elizabeth, is there some explanatory text you'd like here?}</em></font>"),
      # Create a new row for the table.
      fluidRow(
        dataTableOutput(outputId = "ItemProgressTable")
      ), #End fluid row with the Group Call table
      HTML('&copy; 2014 <a href="http://oklahomatfcbt.org/" title="Oklahoma TF-CBT" class="accent">Oklahoma TF-CBT</a>'),
      shiny::icon("code"), #This is a little cheat to get the table icons work
      HTML('Software for data collection and reporting developed by <a href="http://www.ouhsc.edu/BBMC/" class="accent">OUHSC BBMC</a> <a href="https://github.com/OuhscBbmc/" class="accent"><i class="fa fa-github"></i></a>')
    ), #End the (first) tab with the Group Call table
    tabPanel(
      title = "Trauma Symptom Tracking", 
      # HTML("<font color='green'><em>{We need to discuss this graph: https://github.com/OuhscBbmc/Tfcbt/issues/10}</em></font>"),
      # titlePanel("Trauma Symptoms"), 
      "Tracking symptom severity over the life of the TF-CBT case. Trainers suggest, at a minimum, administering pre-treatment and post-treatment trauma measures.",
      plotOutput(outputId='trauma_symptoms', width='95%', height='400px'),
      htmlOutput(outputId='path_data_bullet')
    ) #End the (second) tab with the symptoms
  ) #End the tabsetPanel
)) #End the fluidPage and shinyUI
