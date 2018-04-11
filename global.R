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

saveCharacter = function(characterFile, consent){
    if(consent){
        dir.create('chars',showWarnings = FALSE)
        file.copy(characterFile, file.path('chars',tools::md5sum(characterFile)))
    } else {
        dir.create('naysayer',showWarnings = FALSE)
        randomName = tools::md5sum(characterFile)
        file.create(file.path('naysayer',randomName))
    }
}