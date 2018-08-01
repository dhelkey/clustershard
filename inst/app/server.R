server <- function(input, output) {

  point_size = 4

  #Server function for the graphical tool

    #Read in data when the input box changes
    datRead = reactive({
      infile = input$file
      if (is.null(infile)){return(NULL)}
      dat = processPotteryDat(infile$datapath)
    })

    #Transform data for clustering
    datVals = reactive({
      dat = datRead()
      if (is.null(dat)){return(NULL)}
      dat_vals = transformDat(dat,
                              avg_readings = input$avg_readings,
                              transformation = input$transform_cluster,
                              standardize = input$standardize_cluster)
      return(dat_vals)
    })

    #Transform data for potting
    datValsPlot = reactive({
      dat = datRead()
      if (is.null(dat)){return(NULL)}
      dat_vals = transformDat(dat,
                              avg_readings = input$avg_readings,
                              transformation = input$transform_plot,
                              standardize = input$standardize_plot)
      return(dat_vals)
    })

    #Cluster
    datCluster = reactive({
      dat_vals = datVals() #Transforms data according to inputs
      if (is.null(dat_vals)){return(NULL)}
      dat_cluster = clusterPotteryDat(dat_vals,
                                  k = input$k,
                                  method = input$cluster_method,
                                  pc_keep = input$num_pc)
      return(dat_cluster) #List with two elements, cluster_id and pc_mat
    })

    #Generate a dataframe for plotting/visualization
    datPlot = reactive({
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


    ##Compute average concentration by cluster for barplots
    ##Barplot,
    datClusterAvg = reactive({
      dat_plot = datPlot()
      if (is.null(dat_plot)){return(NULL)}
      return( datClusterAvgFun(dat_plot, input$element_choice))
    })

   output$distPlot <- renderPlot({
    dat_vals = datVals()
    if (is.null(dat_vals)){
      plotNull()
    } else{
      hist( dat_vals[ ,input$element], main = input$element, xlab = 'value')
    }
   })

   output$boxPlot = renderPlot({
     dat_vals = datVals()
       dat_vals_use = dat_vals[ ,input$element_choice_box]
     if (is.null(dat_vals)){
       plotNull()
     } else{
         boxplot(dat_vals_use, main = 'Element Concentration', ylab = 'Concentration')
       }
   })

   output$clusterPlot = renderPlot({
     dat_plot = datPlot()
     if (is.null(dat_plot)){
       plotNull()
     } else {
       if (input$cluster_method == 'gmm'){
         clusterPlot(dat_plot, point_size, gauss = TRUE)
       } else{
         clusterPlot(dat_plot, point_size)
       }
     }
   })

   output$scatterPlot = renderPlot({
     plotNull()
     dat_plot = datPlot()
     if (is.null(dat_plot)){
       plotNull()
     } else {
        scatterPlot(dat_plot, input$element1, input$element2,
                    point_size = point_size)
     }
   })

   output$clusterBar = renderPlot({
     plotNull()
     dat_cluster_avg = datClusterAvg()
     if (is.null(dat_cluster_avg)){
       plotNULL()
     } else {
        clusterBar(dat_cluster_avg)
     }
   })

   output$exportData = downloadHandler(
     filename = 'out_data.csv',
     content = function(file){
       write.csv( datPlot(), file, row.names =  FALSE)
     }
   )

   output$exportPlot = downloadHandler(
     filename = 'plot.png',
     content = function(file){
       device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
       ggsave(file, device = device)
     }

   )
}
