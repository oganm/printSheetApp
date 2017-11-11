
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#






shinyServer(function(input, output) {
    
    # pretty download
    output$downloadNew = downloadHandler(
        filename = 'charSheetPretty.pdf',
        content = function(file){
            characterFile = input$xmlExport$datapath
            # fix windows paths
            characterFile %<>% gsub(pattern = '\\\\',replacement ='/',x = .)
            char = importCharacter(file = characterFile)
            prettyPDF(char = char,file = file)
        })
    
    # ugly download
    output$download <- downloadHandler(
        filename = 'charSheet.pdf',
        content = function(file) {
            sheet = system.file('rmarkdown/templates/CharacterSheet/skeleton/skeleton.rmd',package = 'import5eChar')
            
            req(input$xmlExport)
            characterFile = input$xmlExport$datapath
            print("########### File Accepted ###########")
            print(characterFile)
            # fix windows paths
            characterFile %<>% gsub(pattern = '\\\\',replacement ='/',x = .)
            
            # characterFile <- system.file("Tim_Fighter5", package = "import5eChar")
            
            print("########### Reading and replacing the PATH ###########")
            # sheet = readLines('sheet.Rmd')
            sheet = readLines(sheet)
            
            print(sheet[32])
            sheet = sub(pattern = " characterFile", replace = paste0('"',characterFile,'"'), x = sheet,fixed = TRUE)
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
