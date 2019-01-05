
shinyServer(function(input, output, session) {
    # pretty download
    output$downloadNew = downloadHandler(
        filename = 'charSheetPretty.pdf',
        content = function(file){
            withProgress(message = 'Making pdf',value = 1,{
                characterFile = input$xmlExport$datapath
                # fix windows paths
                characterFile %<>% gsub(pattern = '\\\\',replacement ='/',x = .)
                char = importCharacter(file = characterFile)
                prettyPDF(char = char,file = file)
                saveCharacter(characterFile,input$consent, paste0(input$fingerprint,'_',input$ipid))
            })
        })
    
    # ugly download
    output$download = downloadHandler(
        filename = 'charSheet.pdf',
        content = function(file) {
            withProgress(message = 'Making pdf',value = 1,{
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
                
                saveCharacter(characterFile,input$consent, paste0(input$fingerprint,'_',input$ipid))
            })
            # knit(tempFile,'lolo.pdf',)
        }
    )
    
    output$avraeOut = renderUI({
        input$avrae
        isolate({
            characterFile = input$xmlExport$datapath
            if(!is.null(characterFile)){
                p = Progress$new()
                p$set(value = 1,message = 'Creating google drive sheet')
                characterFile %<>% gsub(pattern = '\\\\',replacement ='/',x = .)
                char = importCharacter(file = characterFile)
                saveCharacter(characterFile,input$consent, paste0(input$fingerprint,'_',input$ipid))
                
                # sheet = avraeSheet(char)
                
                future({avraeSheet(char)}) %...>%
                {
                    tagList(wellPanel(h4('Google Drive Sheet'),
                                      p('Get your file ',
                                        a(href=.$drive_resource[[1]]$webViewLink,target= '_blank', 'here.')),
                                      p('Please copy the file to your own drive to prevent data loss')))
                } %T>%  finally(~p$close())
                
            }
        })
    })
    
    
    output$textOut = renderUI({
        input$impInit
        isolate({
            characterFile = input$xmlExport$datapath
            if(!is.null(characterFile)){
                withProgress(message = 'Making JSON',value = 1,{
                    characterFile %<>% gsub(pattern = '\\\\',replacement ='/',x = .)
                    char = importCharacter(file = characterFile)
                    json = improvedInitiativeJSON(char)
                    saveCharacter(characterFile,input$consent, paste0(input$fingerprint,'_',input$ipid))
                    
                    tagList(wellPanel(h4("JSON for improved initiative"),
                                      rclipButton("iiclip", "Copy to Clipboard", json, icon("clipboard")),
                                      code(json, style= 'display:block;white-space:pre-wrap')))
                })
            }
        })
        
    })
    
    
    
    # show a warning if directly connected to shinyapps.io
    observe({
        query = parseQueryString(session$clientData$url_search)
        if(!is.null(query$valid) && query$valid==TRUE){
            showModal(
                modalDialog(title = "We are moving!",
                            p("This app is moving. You can now access it from ", 
                              a(href="https://oganm.com/shiny/printSheetApp",target= '_blank', 'oganm.com/shiny/printSheetApp'),'.'),
                            p("This link will continue to work but you will get this annoying message every time."),
                            easyClose = FALSE)
            )
        }
    }
    )
})
