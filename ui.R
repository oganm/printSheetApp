
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Unofficial Fifth Edition Character Sheet PDF export"),
  wellPanel(p('Export your character to google drive and download the file to your PC. Upload that file here and click Export PDF'),
            p('XML is parsed with ', 
              a(href="https://github.com/oganm/import5eChar",target= '_blank', 'this'), ' R package'),
    fileInput("xmlExport", "Upload",
                      multiple = FALSE),
            downloadButton('download','Export PDF')
            )
  
))
