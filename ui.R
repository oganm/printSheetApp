
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

inputUserid <- function(inputId, value='') {
    #   print(paste(inputId, "=", value))
    tagList(
        singleton(tags$head(tags$script(src = "js/md5.js", type='text/javascript'))),
        singleton(tags$head(tags$script(src = "js/shinyBindings.js", type='text/javascript'))),
        tags$body(onload="setvalues()"),
        tags$input(id = inputId, class = "userid", value=as.character(value), type="text", style="display:none;")
    )
}

inputIp <- function(inputId, value=''){
    tagList(
        singleton(tags$head(tags$script(src = "js/md5.js", type='text/javascript'))),
        singleton(tags$head(tags$script(src = "js/shinyBindings.js", type='text/javascript'))),
        tags$body(onload="setvalues()"),
        tags$input(id = inputId, class = "ipaddr", value=as.character(value), type="text", style="display:none;")
    )
}

shinyUI(fluidPage(theme = shinytheme('cosmo'),
    tags$head(includeScript('www/js/analytics.js')),
    # Application title
    titlePanel("Unofficial Fifth Edition Character Sheet PDF export"),
    rclipboardSetup(),
    inputIp("ipid"),
    inputUserid("fingerprint"),
    wellPanel(p('Export your character to google drive and download the file to your PC.'),
              p('Upload that file here and click Export PDF.'),
              p('Pretty pdf is a fillable character sheets from Wizard\'s. Slightly slower to generate'),
              p('Less pretty pdf is a plain pdf'),
              p('Avrae google drive sheet takes about 2 minutes to generate'),
              p('XML is parsed with ', 
                a(href="https://github.com/oganm/import5eChar",target= '_blank', 'this'), ' R package.'),
              p('Source code for this page is ',
                a(href="https://github.com/oganm/printSheetApp",target= '_blank', 'here'),'.'),
              p('If you encounter mistakes in pdf or unable to get a pdf, open an issue at the source code repo or mail me at', 
                a(href ="mailto:ogan.mancarci@gmail.com",target = '_blank','ogan.mancarci@gmail.com.'),
                'Include the exported character file if you can.'),
              fileInput("xmlExport", "Upload",
                        multiple = FALSE),
              fluidRow(
                  column(8,
                  downloadButton('download','Export less pretty PDF'),
                  downloadButton('downloadNew','Export pretty PDF'),
                  actionButton('impInit','Improved Initiative JSON'),
                  actionButton('avrae','Avrae Google Drive Sheet (~2 mins)'),
                  actionButton('interactiveSheet','Interactive Sheet (External Link)',
                               onclick = "window.open('https://oganm.github.io/5eInteractiveSheet/','_blank')"),
                  actionButton('dndstats','User Statistics (External Link)',
                               onclick = "window.open('https://oganm.github.io/dndstats/','_blank')")),
                  column(4,
                         actionButton('meh','Donate',
                                          icon = icon('gift'),
                                          onclick =
                                              "window.open('https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=NBC57LQVGMAJG', '_blank')",
                                          style = 'float:right;padding:6px 10px;font-size:80%'),
                         bsTooltip('meh',title = "I can afford to keep this up virtually forever as it only costs about 7$/month to run. But if you are feeling generous it\\'s nice for things to pay for themselves")
                         
                             )
                  ),
              fluidRow(
                  column(3,
                  div(id='consentDiv' , checkboxInput(inputId = 'consent',label = 'Can I keep a copy?', value = TRUE))
                  ), style = 'font-size:70%'),
              bsTooltip('consentDiv',
                        title = "If the box is checked I save a copy of the uploaded character sheet. I use these saved sheets as test cases when improving the application. I also plan to use them for some statistical analyses examining character building choices and release this analysis publicly. The characters remain your intellectual property. If you\\'d rather I didn\\'t save your character, uncheck this box. I won\\'t be mad. Only dissapointed")
    ),
    htmlOutput('avraeOut'),
    htmlOutput('textOut')
))
