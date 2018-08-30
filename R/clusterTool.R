clusterTool = function(element_start_column = 3,
                       width =  960,
                       height = 960,
                       point_size = 4, #Maker size on plot
                       pointsize = 36, #Font size
                       cex = 1
                       ){
  appDir = system.file("app", package = 'clustershard')


  #Element names from periodic table and set other global variables
  data(elements)
  shinyOptions(element_names= elements$symbol)
  shinyOptions(element_start_column=element_start_column)
  shinyOptions(width=width)
  shinyOptions(height=height)
  shinyOptions(pointsize=pointsize)
  shinyOptions(point_size=point_size)
  shinyOptions(cex=cex)

  #Example Code to extract variables
  # element_start_column = getShinyOption('element_start_column')

  shiny::runApp(appDir)
}


