server <- function(input, output) {
  #Server function for the GUI

  #Extract variables
  id_column = getShinyOption('id_column')
  element_start_column = getShinyOption('element_start_column') #TODO make sure this works
  width = getShinyOption('width')
  height = getShinyOption('height')
  pointsize = getShinyOption('pointsize')
  marker_size = getShinyOption('marker_size')
  cex = getShinyOption('cex')
  element_names = getShinyOption('element_names')


    #Read in data when the input box changes
    datRead = reactive({
      infile = input$file
      if (is.null(infile)){return(NULL)}
      dat = processPotteryDat(infile$datapath,
                              id_column = id_column,
                              element_start_column = element_start_column
                              )$dat
      return(dat)
    })

    datReadElements = reactive({
      infile = input$file
      if (is.null(infile)){return(element_names)}
      element_names = processPotteryDat(infile$datapath,
                                        id_column = id_column,
                                        element_start_column = element_start_column
                                        )$element_names
      return(element_names)
    })

    ##Update elements
    output$element = renderUI({
      element_actual_values = datReadElements()
      selectInput('element',
                  label = 'Element',
                  choices = element_actual_values,
                  selected = 'Li')
    })
    output$element_choice_box = renderUI({
      element_actual_values = datReadElements()
      selectInput('element_choice_box',
                  label = 'Select Elements',
                  choices = element_actual_values,
                  multiple = TRUE,
                  selected = c('Li', 'Na', 'Mg', 'Si'))
    })
    output$element1 = renderUI({
      element_actual_values = datReadElements()
      selectInput('element1',
                  label = 'Element',
                  choices = element_actual_values,
                  selected = 'Li')
    })
    output$element2 = renderUI({
      element_actual_values = datReadElements()
      selectInput('element2',
                  label = 'Element',
                  choices = element_actual_values,
                  selected = 'Be')
    })
    output$element_choice_bar = renderUI({
      element_actual_values = datReadElements()
      selectInput('element_choice_bar',
                  label = 'Element',
                  choices = element_actual_values,
                  multiple = TRUE,
                  selected = element_actual_values[1:5])
    })

    ##Transform data
    datVals = reactive({ #Transform the data for clustering
      dat = datRead()
      elements = datReadElements()
      if (is.null(dat)){return(NULL)}
      dat_vals = transformDat(dat,
                              elements = elements,
                              avg_readings = input$avg_readings,
                              transformation = input$transform_cluster,
                              standardize = input$standardize_cluster)
      return(dat_vals)
    })

    #Transform data for potting
    datValsPlot = reactive({ #Transform data for plotting
      dat = datRead()
      elements = datReadElements()
      if (is.null(dat)){return(NULL)}
      dat_vals = transformDat(dat,
                              elements = elements,
                              avg_readings = input$avg_readings,
                              transformation = input$transform_plot,
                              standardize = input$standardize_plot)
      return(dat_vals)
    })

    datCluster = reactive({ #Cluster observations
      dat_vals = datVals()
      if (is.null(dat_vals)){return(NULL)}
      dat_cluster = clusterPotteryDat(dat_vals,
                                      k = input$k,
                                      method = input$cluster_method,
                                      pc_keep = input$num_pc)
      return(dat_cluster) #List with two elements, cluster_id and pc_mat
    })


    datPlot = reactive({  #Generate a dataframe for plotting/visualization
      dat_cluster = datCluster()
      dat_vals = datValsPlot()
      #Extract
      pc_mat = dat_cluster$pc_mat
      cluster_id = dat_cluster$cluster_id

      if (is.null(dat_cluster)){return(NULL)}
      dat_plot = data.frame(
        pc1 = pc_mat[ ,1],
        pc2 = pc_mat[ ,2],
        cluster_id = cluster_id,
        dat_vals
      )
      return(dat_plot)
    })

    datClusterAvg = reactive({#Compute average concentration by cluster for barplots
      dat_plot = datPlot()
      if (is.null(dat_plot) | is.null(input$element_choice_bar)){return(NULL)}
      return( datClusterAvgFun(dat_plot, input$element_choice_bar))
    })

  ##Distribution Plot
  distPlot = function(){
      dat_vals = datVals()
      if (is.null(dat_vals)){
        p = plotNull()
      } else{
        p = hist( dat_vals[ ,input$element], main = input$element, xlab = 'value')
      }
      return(p)
    }
   output$distPlot <- renderPlot({
    distPlot()
   })
   output$downDistPlot = downloadHandler(
     filename = function(){
       #TODO check on format
       'dist_plot.pdf'
     },
     content = function(file){
       png(file, width = width, height = height, pointsize = pointsize)
       print(distPlot())
       dev.off()
     }
   )
   ##Box Plot
   printBoxPlot = reactive({
     dat_vals = datVals()
     p = plotNull()
     dat_vals_use = dat_vals[ ,input$element_choice_box]
     if (dim(dat_vals_use)[2] > 0){
       dat_vals_use = dat_vals[ ,input$element_choice_box]
       p = boxPlot(dat_vals_use)
     }
     return(p)
   })
   output$boxPlot = renderPlot({
      printBoxPlot()
   })
   output$downBoxPlot = downloadHandler(
     filename = function(){
       'box_plot.png'
     },
     content = function(file){
       png(file, width = width, height = height, pointsize = pointsize)
       print(printBoxPlot())
       dev.off()
     }
   )
   ##Cluster scatter plot
   printclusterPlot = function(){
     dat_plot = datPlot()
     if (is.null(dat_plot)){
       p = plotNull()
     } else {
       if (input$cluster_method == 'gmm'){
         p = clusterPlot(dat_plot, marker_size, gauss = TRUE)
       } else{
         p = clusterPlot(dat_plot, marker_size)
       }
     }
     return(p)
   }
   output$clusterPlot = renderPlot({
      printclusterPlot()
   })
   output$downClusterPlot = downloadHandler(
     filename = function(){
       'cluster_plot.png'
     },
     content = function(file){
       png(file, width = width, height = height, pointsize = pointsize)
       print(printclusterPlot())
       dev.off()
     }
   )
  ##Element concentration scatter plot
   printScatterPlot = function(){
     p = plotNull()
     dat_plot = datPlot()
     if (!is.null(dat_plot) & !is.null(input$element1)){
       p = scatterPlot(dat_plot, input$element1, input$element2,
                   marker_size = marker_size)
     }
    return(p)
   }
   output$scatterPlot = renderPlot({
      printScatterPlot()
   })
   output$downScatterPlot = downloadHandler(
     filename = function(){
       'scatter_plot.png'
     },
     content = function(file){
       png(file, width = width, height = height, pointsize = pointsize)
       print(printScatterPlot())
       dev.off()
     }
   )

   ##Cluster bar
   printClusterBar = function(){
     p = plotNull()
     dat_cluster_avg = datClusterAvg()
     if (!is.null(dat_cluster_avg)){
       p = clusterBar(dat_cluster_avg)
     }
     return(p)
   }

   output$clusterBar = renderPlot({
      printClusterBar()
   })

   output$downClusterBar = downloadHandler(
     filename = function(){
       'cluster_bar.png'
     },
     content = function(file){
       png(file, width = width, height = height, pointsize = pointsize)
       print(printClusterBar())
       dev.off()
     }
   )

   output$exportData = downloadHandler(
     filename = 'out_data.csv',
     content = function(file){
       write.csv( datPlot(), file, row.names =  FALSE)
     }
   )
}
