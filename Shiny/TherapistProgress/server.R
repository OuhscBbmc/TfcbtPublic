library(shiny)
library(ggplot2)
library(grid)

# Define a server for the Shiny app
shinyServer( function(input, output) {
  
  #######################################
  ### Set any sesion-wide options
  # options(shiny.trace=TRUE)
  
  #######################################
  ### Call source files that contain semi-encapsulated functions.
  
  #######################################
  ### Create the DataTables objects (a jQuery library): http://www.datatables.net/

  output$ItemProgressTable <- renderDataTable({
    # Filter Client Progress data based on selections
    d <- dsItemProgress
    
    if (input$therapist_tag != "All")
      d <- d[d$therapist_tag == input$therapist_tag, ]
    if (input$client_number != "All")
      d <- d[d$client_number == input$client_number, ]
    
    colnames(d) <- gsub("^session_(\\d{2})$", "\\1", colnames(d)) #This strips out the "session_" prefix.
    
    d$therapist_tag <- NULL
    d$client_number <- NULL
    d$item <- NULL
    d$description_short <- NULL
    d$description_long <- NULL
    d$variable_index <- NULL
    d$therapist_email <- NULL
    
    d <- plyr::rename(d, replace=c(
      # "description_short" = "Variable",
      "description_html" = "TF-CBT PRACTICE Component",
      # "therapist_email" = "Therapist Email",
      # "therapist_id_rc" = "TID",
      # "client_number" = "Client Number",
      "branch_item" = "B"
    ))
    return( as.data.frame(d) )
  },
  options = list(
    # lengthMenu = list(c(length(unique(dsItemProgress$item)), -1), c(length(unique(dsItemProgress$item)), 'All')),
    # pageLength = length(unique(dsItemProgress$item)), #34,
    language = list(emptyTable="--<em>Please select a therapist above to populate this table.</em>--"),
    aoColumnDefs = list( #http://legacy.datatables.net/usage/columns
      list(sClass="semihide", aTargets=-1),
      # list(sClass="alignRight", aTargets=0),
      # list(sClass="session", aTargets=1:length(unique(dsItemProgress$item))),
      list(sClass="smallish", aTargets="_all")
    ),

    # columnDefs = list(list(targets = c(3, 4) - 1, searchable = FALSE)),
    searching = FALSE,
    paging=FALSE,
    sort=FALSE,
    # $("td:eq(0)", nRow).css("font-weight", "bold");
    # $("td:eq(0)", nRow).css("font-size", "large");
    rowCallback = I('
      function(nRow, aData) {
      // Emphasize rows where the `branch_item` column equals to 1
        if (aData[aData.length-1] == "1") {
          $("td", nRow).css("background-color", "#aaaaaa");
        }
      }')
    )
  )
  
  output$trauma_symptoms <- renderPlot({
    #TODO: add filtering based on dropdown boxes
    #(dsSessionSurvey$therapist_id_rc>0) & (dsSessionSurvey$client_number>0)
    dWide <- dsSessionSurvey# [, c("session_date", "trauma_score_caregiver", "trauma_score_child")]   
    
    if (input$therapist_tag != "All")
      dWide <- dWide[dWide$therapist_tag == input$therapist_tag, ]
    if (input$client_number != "All")
      dWide <- dWide[dWide$client_number == input$client_number, ]
    
    dLong <- reshape2::melt(dWide, id.vars="session_date", variable.name="respondent", value.name="score")
    dLong$respondent <- gsub("^trauma_score_(.*)$", "\\1", dLong$respondent)

    shape_respondent_dark <- c("child"=21, "caregiver"=25)
    color_respondent_dark <- c("child"="#1f78b4", "caregiver"="#33a02c") #From paired qualitative palette
    color_respondent_light <- grDevices::adjustcolor( c("child"="#a6cee3", "caregiver"="#b2df8a"), alpha.f = .4)
    names(color_respondent_light) <- names(color_respondent_dark)
    
    ggplot(dLong, aes(x=session_date, y=score, color=respondent, fill=respondent, shape=respondent)) +
      geom_point(size=10, na.rm=T) +
      geom_line(na.rm=T) +
#       scale_color_manual(values=color_respondent_dark) +
#       scale_fill_manual(values=color_respondent_light) +
#       scale_shape_manual(values=shape_respondent_dark) +  
      coord_cartesian(ylim=c(0, 60)) +
      theme_bw() +
      theme(axis.ticks.length = grid::unit(0, "cm")) +
      theme(panel.margin=unit(c(0,0,0,0), "lines")) +
      #   theme(axis.text = element_blank()) +
      #   theme(axis.title = element_blank()) +
      #   theme(panel.grid = element_blank()) +
      #   theme(panel.border = element_blank()) +
      #   theme(plot.margin=unit(c(0,0,0,0), "lines")) +
      theme(legend.position="top") +
      labs(title=NULL, x=NULL, y=NULL, colour=NULL, fill=NULL, shape=NULL)
  }) #trauma_symptoms plot
  
})
