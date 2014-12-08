rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

library(shiny)
# devtools::install_github("rstudio/shinyapps")

# server <- (Sys.info()["nodename"] == "Lucky1304")
# server <- FALSE
shiny::runApp('./Shiny/TherapistProgress', launch.browser=TRUE, port=6149)
# To stop the Shiny server, click the red stop sign in the 'Console window.

# Deploy the **master** branch shinyapps.io if the change is stable.  See https://github.com/rstudio/shinyapps/blob/master/guide/guide.md
# shinyapps::deployApp(account="melinae")
shinyapps::deployApp(account="wibeasley", appDir='./Shiny/TherapistProgress')
# devtools::install_github("rstudio/shinyapps")
# shinyapps::showLogs(account="wibeasley")
# shinyapps::taskLog(taskId=17795, account="wibeasley")

# shinyapps::terminateApp(account="melinae", appName="prediction-app-demo")
# shinyapps::terminateApp(account="wibeasley", appName="prediction-app-demo")
