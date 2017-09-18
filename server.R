
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(import5eChar)
library(knitr)
library(rmarkdown)
library(kableExtra)
library(dplyr)
library(magrittr)
library(ogbox)
library(bindrcpp)

shinyServer(function(input, output) {
  
  output$download <- downloadHandler(
    filename = 'charSheet.pdf',
    content = function(file) {
      req(input$xmlExport)
      characterFile = input$xmlExport$datapath
      print("########### File Accepted ###########")
      print(characterFile)
      # fix windows paths
      characterFile %<>% gsub(pattern = '\\\\',replacement ='/',x = .)
      
      # characterFile <- system.file("Tim_Fighter5", package = "import5eChar")
      
      print("########### Reading and replacing the PATH ###########")
      sheet = readLines('sheet.Rmd')
      print(sheet[32])
      sheet = sub(pattern = "PUTCHARFILEHERE", replace = paste0('"',characterFile,'"'), x = sheet)
      print(sheet[32])
      tempFile = paste0(tempfile(),'.Rmd')
      print("########### This is the temp file ###########")
      print(tempFile)
      
      writeLines(sheet,tempFile)
      
      print("########### Attempt to render ###########")
      # browser()
      
      render(tempFile,output_file =  file, 
             params = params,
             envir = new.env(parent = globalenv()))
      # knit(tempFile,'lolo.pdf',)
    }
  )
})
