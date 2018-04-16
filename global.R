library(animation)
library(stringr)
library(glue)
library(import5eChar)
library(knitr)
library(rmarkdown)
library(kableExtra)
library(dplyr)
library(magrittr)
library(ogbox)
library(bindrcpp)
library(shinythemes)
library(shinyBS)

saveCharacter = function(characterFile, consent, fingerprint = ''){
    randomName = tools::md5sum(characterFile)
    if(consent){
        dir.create('chars',showWarnings = FALSE)
        file.copy(characterFile, file.path('chars',paste0(fingerprint,'_',randomName)))
    } else {
        dir.create('naysayer',showWarnings = FALSE)
        file.create(file.path('naysayer',paste0(fingerprint,'_',randomName)))
    }
}
