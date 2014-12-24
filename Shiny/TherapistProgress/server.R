library(shiny)
library(ggplot2)
library(grid)
library(magrittr)

# Define a server for the Shiny app
shinyServer( function(input, output, session) {
  
  #######################################
  ### Set any sesion-wide options
  # options(shiny.trace=TRUE)
  
  #######################################
  ### Call source files that contain semi-encapsulated functions.
  
  #######################################
  ### Create the DataTables objects (a jQuery library): http://www.datatables.net/
  
  # Display only the therapists in the selected agencies and call groups (if any are specified)
  observe({    
    d_pool <- dsItemProgress
    
    if( (is.null(input$agency_names)) | ("--All--" %in% input$agency_names) ) {
      #Don't filter the pool based on agency if nothing or everything is specified.
    } else {
      d_pool <- d_pool %>%
        dplyr::filter(agency_name %in% input$agency_names)
    }   
    
    if( (is.null(input$call_group_codes)) | ("--All--" %in% input$call_group_codes) ) {
      #Don't filter the pool based on call_group_codes if nothing or everything is specified.
    } else {
      d_pool <- d_pool %>%
        dplyr::filter(call_group_code %in% input$call_group_codes)
    }
    
    remaining_tags <- d_pool %>%
      `$`('therapist_tag') %>%
      unique() %>%
      sort()
    
    remaining_tags <- c("--Select a Therapist--", remaining_tags)
    
    #stillSelected <- isolate(input$call_group_code[input$call_group_code %in% call_group_codes])
    # stillSelected <- isolate(
    #   ifelse(
    #     length(call_group_codes)==0,
    #     input$call_group_code,
    #     input$call_group_code[input$call_group_code %in% call_group_codes]
    #   )
    # )
    
    updateSelectInput(session, "therapist_tag", choices=remaining_tags)#, selected="--Select a Therapist--")
  })
  
  #Update the clients available for the selected therapist
  observe({ 
    if( is.null(input$therapist_tag) | (length(input$therapist_tag)==0) | (nchar(input$therapist_tag)==0) | (input$therapist_tag=="--Select a Therapist--") ) {
      #Don't display any clients if tag is specified.
      updateSelectInput(session, "client_number", choices="--Select Therapist First--")
    } else {
      clients <- dsItemProgress %>%
        dplyr::filter(therapist_tag == input$therapist_tag) %>%
        `$`('client_number') %>%
        unique() %>%
        sort()
      updateSelectInput(session, "client_number", choices=clients) 
    }
  })
  
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

    for( session_item in sort(grep("^session_(\\d{2})$", colnames(d), value=T, perl=T)) ) {
      d[, session_item] <- ifelse(d[, session_item], '<i class="fa fa-check-circle accent"></i>', '<i class="fa fa-circle-o semihide"></i>') #style="color:#dddddd"
      
      if( all(is.na(d[, session_item])) )
        d[, session_item] <- NULL
    }    
    
    if( length(d[!d$branch_item, "description_html"]) > 0 )
      d[!d$branch_item, "description_html"] <- paste0('<span class="tab accent">', d[!d$branch_item, "description_html"], '</a>')
    
            
    d_session_long$session_date <- strftime(d_session_long$session_date, "%m<br/>%d") #"%y<br/>%m<br/>%d"
    
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
    d$agency_name <- NULL
    d$call_group_code <- NULL
    d$item <- NULL
    d$description_short <- NULL
    d$description_long <- NULL
    d$variable_index <- NULL
    d$therapist_email <- NULL
    
    d <- plyr::rename(d, replace=c(
      "description_html" = "TF-CBT PRACTICE Component",
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
      labs(title=NULL, x="Session Date", y="Trauma Score", colour=NULL, fill=NULL, shape=NULL)
  }) #trauma_symptoms plot
  
})
