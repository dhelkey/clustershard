element_names = c("Li","Be","Na","Mg","Al","Si","P","S","K","Ca","Sc","Ti","V","Cr","Mn","Fe","Co","Ni",
                  "Cu","Zn","As","Rb","Sr","Y","Zr","Ag","Cd","Sn","Sb","Cs","Ba","La","Ce","Pr","Nd",
                  "Sm","Eu","Gd","Tb","Dy","Ho","Er","Tm","Yb","Lu","Hf","Ta","W","Au", "Tl","Pb","Bi",
                  "Th","U")




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
                    "Analysis Transformation (Visualizations )",
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
                     tabPanel("Histogram", selectInput("element", "Element",
                                                       choices = element_names),
                              plotOutput("distPlot")),

                     tabPanel("Box Plots",
                              selectInput("element_choice_box", "Select Elements",
                                  choices = element_names, multiple = TRUE, selected = element_names[1:10]),
                              plotOutput("boxPlot")),

                      tabPanel('Cluster Plot',
                               plotOutput("clusterPlot")),

                     tabPanel('Scatter Plot', selectInput("element1", "Element",
                                                          choices = element_names,
                                                          selected = "Li"),
                              selectInput("element2", "Element",
                                          choices = element_names, selected = "Be"),
                              plotOutput("scatterPlot")),

                     tabPanel('Cluster Concentrations',
                              selectInput("element_choice", "Select Elements",
                                          choices = element_names, multiple = TRUE, selected = 'Li'),
                              plotOutput("clusterBar"))
                     )
      )
   )
)
