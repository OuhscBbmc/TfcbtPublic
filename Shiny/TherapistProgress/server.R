library(shiny)
library(ggplot2)

# Define a server for the Shiny app
shinyServer( function(input, output) {
  
  #######################################
  ### Set any sesion-wide options
  # options(shiny.trace=TRUE)
  
  #######################################
  ### Call source files that contain semi-encapsulated functions.
  

  output$ItemProgressTable <- renderDataTable({
    # Filter Client Progress data based on selections
    d <- dsItemProgress
    
    if (input$item_progress_therapist_id_rc != "All")
      d <- d[d$therapist_id_rc == input$item_progress_therapist_id_rc,]
    if (input$item_progress_client_number != "All")
      d <- d[d$client_sequence == input$item_progress_client_number,]
    
    colnames(d) <- gsub("^session_(\\d{2})$", "\\1", colnames(d)) #This strips out the "session_" prefix.
    d <- plyr::rename(d, replace=c(
      "item" = "Item",
      "therapist_id_rc" = "Therapist ID in REDCap",
      "client_sequence" = "Client Number",
      "branch_item" = "Branch Item"
    ))
    return( as.data.frame(d) )
  },
  options = list(
    pageLength = length(unique(dsItemProgress$item)), #34,
    aoColumnDefs = list(list(sClass="alignRight", aTargets=ncol(dsItemProgress)-1)),
    rowCallback = I('
      function(nRow, aData) {
      // Emphasize rows where the `branch_item` column equals to 1
        if (aData[aData.length-1] == "1") {
          $("td:eq(0)", nRow).css("font-weight", "bold");
          $("td", nRow).css("background-color", "#aaaaaa");
          $("td:eq(0)", nRow).css("font-size", "large");
        }
      }')
    )
  )
  
  output$ClientProgressTable <- renderDataTable({
    # Filter Client Progress data based on selections
    d <- dsClientSummary
    
    if (input$client_progress_therapist_id_rc != "All")
      d <- d[d$therapist_id_rc == input$client_progress_therapist_id_rc,]
    if (input$client_progress_client_number != "All")
      d <- d[d$client_number == input$client_progress_client_number,]

    d <- plyr::rename(d, replace=c(
      "therapist_id_rc" = "Therapist ID in REDCap",
      "client_number" = "Client Number",
      "session_count" = "Session Count"
    ))
    
    return( as.data.frame(d) )
  })
  
  output$SessionSummaryTable <- renderDataTable({
    # Filter SessionSummary data based on selections
    d <- dsSessionSurvey
    
    if (input$group_call_survey_id != "All")
      d <- d[d$survey_id == input$group_call_survey_id,]
    if (input$group_call_therapist_identifier != "All")
      d <- d[d$therapist_identifier == input$group_call_therapist_identifier,]
    if (input$group_call_session_ym != "All")
      d <- d[d$session_ym == input$group_call_session_ym,]

    return( d )
  })
  
})
