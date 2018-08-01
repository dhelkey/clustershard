
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


##Set up some things
element_names = c("Li","Be","Na","Mg","Al","Si","P","S","K","Ca","Sc","Ti","V","Cr","Mn","Fe","Co","Ni",
                  "Cu","Zn","As","Rb","Sr","Y","Zr","Ag","Cd","Sn","Sb","Cs","Ba","La","Ce","Pr","Nd",
                  "Sm","Eu","Gd","Tb","Dy","Ho","Er","Tm","Yb","Lu","Hf","Ta","W","Au", "Tl","Pb","Bi",
                  "Th","U")

source("ui.R")
source("server.R")

#TODO questions, order of elements important? Not really easy to add and remove ones, some things are hard coded...
##For scatterplot, we look at TRANSFORMED values. Would you like only untransformed, or both?

##For data out, what transformation (if any) should be saved

#We provide the functionality to download plots individually. Could save commonly used plots
#(e.g. for cetain elements) automacially
##One option would be to put the download buttons

##Can add option to automatically save certain plots with the inputs (k, transformation, etc), IF DESIRED

shinyApp(ui = ui,
         server = server)
