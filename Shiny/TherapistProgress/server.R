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
    d_session_long <- dsSessionSurvey
    
    if( input$therapist_tag != "response not possible" ) {
      d <- d[d$therapist_tag == input$therapist_tag, ]
      d_session_long <- d_session_long[d_session_long$therapist_tag == input$therapist_tag, ]
    }
    if( input$client_number > 0 ) {
      d <- d[d$client_number == input$client_number, ]
      d_session_long <- d_session_long[d_session_long$client_number == input$client_number, ]
    }
    
    # d$session_01 <- ifelse(d$session_01=="YES&ensp;", '<i class="fa fa-circle-thin"></i><i class="fa fa-check-circle"></i>', '<i class="fa fa-circle-thin"></i><i class="fa fa-circle-thin"></i>')
    for( session_item in sort(grep("^session_(\\d{2})$", colnames(d), value=T, perl=T)) ) {
      # d[, session_item] <- ifelse(d[, session_item]=="YES&ensp;", '&ensp;<i class="fa fa-check-circle"></i>&ensp;', '&ensp;')
      # d[, session_item] <- ifelse(d[, session_item]=="YES&ensp;", '&ensp;<i class="fa fa-check-circle"></i>', '&ensp;<i class="fa fa-fw"></i>')
      d[, session_item] <- ifelse(d[, session_item]=="YES&ensp;", '&ensp;<i class="fa fa-check-circle"></i>', '&ensp;<i class="fa fa-circle-o semihide"  ></i>') #style="color:#dddddd"
      
      if( all(is.na(d[, session_item])) )
        d[, session_item] <- NULL
    }    
            
    d_session_long$session_date <- strftime(d_session_long$session_date, "%m<br/>%d") #"%y<br/>%m<br/>%d"
    #d_session_wide <- reshape2::dcast(d_session_long, session_number ~ session_date)
    d_date <- as.data.frame(t(d_session_long[, c("session_date"), drop=F]))
    colnames(d_date) <- sprintf("session_%02i", d_session_long$session_number)
    d_date$branch_item <- 0L
    d_date$variable_index <- -1L
    d_date$description_html <- "Session Month<br/>Session Day" #"Year<br/>Month<br/>Day"
    
    d <- plyr::rbind.fill(d, d_date)
    d <- d[order(d$variable_index), ]
    
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
    language = list(emptyTable="--<em>Please select a valid therapist-client combination above to populate this table.</em>--"),
    aoColumnDefs = list( #http://legacy.datatables.net/usage/columns
      list(sClass="quasihide", aTargets=-1),
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
    
    if( input$therapist_tag == "--Select a Therapist--" ) {
      return()
    } else {
      dWide <- dWide[dWide$therapist_tag == input$therapist_tag, ]
    }
    if( input$client_number > 0 )
      dWide <- dWide[dWide$client_number == input$client_number, ]
    
    dLong <- reshape2::melt(dWide, id.vars=c("therapist_tag", "client_number", "session_number", "session_date"), variable.name="respondent", value.name="score")
    dLong$respondent <- gsub("^trauma_score_(.*)$", "\\1", dLong$respondent)
    
    dLong <- dLong[!is.na(dLong$score),]

    shape_respondent_dark <- c("child"=21, "caregiver"=25)
    color_respondent_dark <- c("child"="#1f78b4", "caregiver"="#33a02c") #From paired qualitative palette
    color_respondent_light <- grDevices::adjustcolor( c("child"="#a6cee3", "caregiver"="#b2df8a"), alpha.f = .4)
    names(color_respondent_light) <- names(color_respondent_dark)
    
    ggplot(dLong, aes(x=session_date, y=score, color=respondent, fill=respondent, shape=respondent)) +
      geom_point(size=10, na.rm=T) +
      geom_line(na.rm=T) +
      scale_x_date(labels = scales::date_format("%Y-%m-%d")) +
      scale_color_manual(values=color_respondent_dark) +
      scale_fill_manual(values=color_respondent_light) +
      scale_shape_manual(values=shape_respondent_dark) +  
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
