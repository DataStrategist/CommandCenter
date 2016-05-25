
## Read all the output files of all automated procedures and display whether they failed
## or not
library(syuzhet)
library(dplyr)
library(googleVis)

## Set wd
setwd("PATH TO WORKING DIRECTORY HERE")

df <- data.frame(thing="",lastRun="",SomethinWrong="",runLink="",status="",stringsAsFactors = F)
# df$lastRun <- as.difftime(df$lastRun)
i=0

##--- IDENTIFIER NAME -----------start. Copy this chunk for each job to track 
# Name,Result file,bat file:
DisplayName <- "PUT VISIBLE NAME HERE"
BF   <- "PATH AND FILE TO BAT FILE HERE"
RF   <- "PATH AND FILE TO R FILE HERE"

i=i+1

df[i,"thing"]   <- DisplayName
a <- file.info(RF)
df[i,"lastRun"] <- as.character(Sys.Date()- as.Date(a$mtime))
df[i,"runLink"] <- paste('<a href ="',BF,'" download>link</a>',sep="")
df[i,"SomethinWrong"] <- paste('<a href ="',RF,'"title="DONT click this link... rightClick +copyLink and open from R" >link</a>',sep="")
er <- paste("Errlines:",
            grep("ERROR|Error", 
                 get_sentences(gsub("\\+",".",get_text_as_string(paste(RF,"out",sep="")))) ,value=TRUE),sep="</br>")
er <-gsub("\\.","&#10",er)
if (paste(er,collapse="") == "Errlines:</br>") {
  df[i,"status"] <- '<img border=0 src="green.gif">'
} else {
  df[i,"status"] <- paste('<img border=0 src="red.gif" title="',er,'" >',collapse="")
}
##------------------------------- end. Copy this chunk for each job to track





##-----------------------
#### Plot table and produce output ####
ObsRep <- gvisTable(df)
# plot(ObsRep)
cat(paste('<html><head><title>Command Center 2000!!</title></head><body>',
          '<h1>Command Center 2000!!</h1>',
          '<h2>Report Date: ',Sys.Date(),'</h2>',sep=''),
    ObsRep$html$header,
    ObsRep$html$chart,
    '<a href="CommandCenter.bat" download>Rerun Command center</a>',
    '</body></html>',
    file="CommandCenter.html")
browseURL("CommandCenter.html")

