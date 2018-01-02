
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyUI(fluidPage(
    tags$head(includeScript('www/js/analytics.js')),
    # Application title
    titlePanel("Unofficial Fifth Edition Character Sheet PDF export"),
    wellPanel(p('Export your character to google drive and download the file to your PC.'),
              p('Upload that file here and click Export PDF.'),
              p('Pretty pdf is a fillable character sheets from Wizard\'s. Slightly slower to generate'),
              p('Less pretty pdf is a plain pdf'),
              p('XML is parsed with ', 
                a(href="https://github.com/oganm/import5eChar",target= '_blank', 'this'), ' R package.'),
              p('Source code for this page is ',
                a(href="https://github.com/oganm/printSheetApp",target= '_blank', 'here'),'.'),
              p('If you encounter mistakes in pdf or unable to get a pdf, open an issue at the source code repo or mail me at', 
                a(href ="mailto:ogan.mancarci@gmail.com",target = '_blank','ogan.mancarci@gmail.com.'),
                'Include the exported character file if you can.'),
              fileInput("xmlExport", "Upload",
                        multiple = FALSE),
              downloadButton('download','Export less pretty PDF'),
              downloadButton('downloadNew','Export pretty PDF')
    )
    
))
