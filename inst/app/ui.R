# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("Shard Analysis"),

   # Sidebar with a slider input for number of bins
   sidebarLayout(
      sidebarPanel(

        fileInput("file", "Import Data"),

        ##Data Transformations for clustering
        sliderInput('k',
                    "Number of clusters:",
                    min = 1,
                    max = 10,
                    value = 3),

        sliderInput('num_pc',
                    "# of Principle Components:",
                    min = 2,
                    max = 50,
                    value = 5),


        radioButtons('cluster_method', 'Clustering Method', choiceNames = c("GMM", "K-means"),
                     choiceValues = c('gmm', 'kmeans'), selected = 'gmm' ),


        radioButtons('avg_readings', 'Average Readings', choiceNames = c("True", "False"),
                     choiceValues = c(TRUE, FALSE), selected = TRUE ),

        radioButtons('standardize_cluster', 'Standardize', choiceNames = c("True", "False"),
                     choiceValues = c(TRUE, FALSE), selected = TRUE ),

        selectInput("transform_cluster",
                    'Data Transformation Method',
                    choices = list('None' = 'none', 'Log' = 'log',  'Log-Ratio Analysis' = 'lra' )),

        #Analysis Transformation
        selectInput("transform_plot",
                    "Visualization Transformation Method",
                    choices = list('None' = 'none', 'Log' = 'log',  'Log-Ratio Analysis' = 'lra' ),
                    selected = 'log'),

        radioButtons('standardize_plot', 'Standardize', choiceNames = c("True", "False"),
                     choiceValues = c(TRUE, FALSE), selected = FALSE ),

         downloadButton("exportData", 'Export Data')

        #downloadButton("exportPlot", 'Export Plot')
      ),

      # Show a plot of the generated distribution
      mainPanel(

        tabsetPanel( type = "tabs",
                     tabPanel("Histogram",
                              uiOutput('element'),
                              plotOutput("distPlot"),
							  downloadButton('downDistPlot', 'Export Plot')),

                     tabPanel("Box Plots",
								uiOutput('element_choice_box'),
                              plotOutput("boxPlot"),
							  downloadButton('downBoxPlot', 'Export Plot')),

                      tabPanel('Cluster Plot',
                               plotOutput("clusterPlot"),
							   downloadButton('downClusterPlot', 'Export Plot')),

                     tabPanel('Scatter Plot',
						uiOutput('element1'),
						uiOutput('element2'),
                        plotOutput("scatterPlot"),
						downloadButton('downScatterPlot', 'Export Plot')),

                     tabPanel('Cluster Concentrations',
                              uiOutput('element_choice_bar'),
                              plotOutput("clusterBar"),
							  downloadButton('downClusterBar', 'Export Plot'))
                     )
      )
   )
)
