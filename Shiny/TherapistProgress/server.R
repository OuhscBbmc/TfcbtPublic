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
    return( as.data.frame(d) )
  },
    options = list(rowCallback = I('
        function(nRow, aData) {
          // Bold cells for with the `branch_item` column equal to 1
          if (aData[aData.length-1] == "1")
            $("td", nRow).css("font-weight", "bold");
        }')
      )
  )
  
  output$ClientProgressTable <- renderDataTable({
    # Filter Client Progress data based on selections
    if (input$client_progress_therapist_id_rc != "All")
      dsClientSummary <- dsClientSummary[dsClientSummary$therapist_id_rc == input$client_progress_therapist_id_rc,]
    if (input$client_progress_client_number != "All")
      dsClientSummary <- dsClientSummary[dsClientSummary$client_number == input$client_progress_client_number,]

    dsClientSummary <- plyr::rename(dsClientSummary, replace=c(
      "therapist_id_rc" = "Therapist ID in REDCap",
      "client_number" = "Client Number",
      "session_count" = "Session Count"
    ))
    
    return( as.data.frame(dsClientSummary) )
  })
  
  output$SessionSummaryTable <- renderDataTable({
    # Filter SessionSummary data based on selections
    if (input$group_call_survey_id != "All")
      dsSessionSurvey <- dsSessionSurvey[dsSessionSurvey$survey_id == input$group_call_survey_id,]
    if (input$group_call_therapist_identifier != "All")
      dsSessionSurvey <- dsSessionSurvey[dsSessionSurvey$therapist_identifier == input$group_call_therapist_identifier,]
    if (input$group_call_session_ym != "All")
      dsSessionSurvey <- dsSessionSurvey[dsSessionSurvey$session_ym == input$group_call_session_ym,]

    return( dsSessionSurvey )
  })
  
})
