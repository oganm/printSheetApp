
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
        if(is.null(query$valid) || query$valid!=TRUE){
            showModal(
                modalDialog(title = "You are using the wrong link!",
                            p("You are connecting to my hosting service diretly instead of using the real link for the site:", 
                              a(href="https://oganm.github.io/printSheetApp/",target= '_blank', 'oganm.github.io/printSheetApp'),'.'),
                            p("If you continue to use this link, this site can go down without warning if the hosting service changes 
                              or it can have an out of date version with unfixed bugs if I don't take it down. Don't trust this link. 
                              Use the officially supported one."),
                            easyClose = TRUE)
            )
        }
    }
    )
})
