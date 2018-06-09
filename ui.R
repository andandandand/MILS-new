library(shiny)
library("shinythemes")

orange_slider <- "
.irs-bar,
.irs-bar-edge,
.irs-single,
.irs-grid-pol {
background: #f63;
border-color: #f63;
}"

shinyUI(
  fluidPage(
    theme = shinytheme("united"),
    tags$style(orange_slider),
    
    sidebarLayout(
      
      column(6, 
             tabsetPanel(id = "conditionedPanels",
               tabPanel("For networks",
                        value = 1,
                        
                        h3("MILS for Networks"),
                        
                        div(
                          wellPanel(
                            
                            fileInput(inputId = "file1",
                                      label = "Choose a CSV file",
                                      accept = c('text/comma-separated-values',
                                                 'text/plain',
                                                 'text/csv',
                                                 '.csv')
                                                                    
                            ),
                            
                            radioButtons(inputId="elementsToDelete", 
                                         label = "Elements to delete",
                                         choices = c("vertices", "edges"),
                                         selected = "vertices"),
                            
                            #TODO: update max dynamically on server
                            sliderInput(inputId="numberOfElements",
                                        label = "number of elements",
                                        min = 1, 
                                        max = 10, value = 1, step = 1
                                        ),
                            
                            actionButton(inputId="swapGraphsButton",
                                         label  ="Update evaluated graph")
                          )
                        )
                      ), #en "For networks" tabpanel
               
               tabPanel("For strings",
                        value=2,
                        h3("MILS for Strings")
                        
                        )
             )
      ),
      
      mainPanel(
        #withMathJax(),
        conditionalPanel(condition="input.conditionedPanels==1",
                         
                         br(),

                         fluidRow(
                           column(width = 6,
                                  HTML('<center><h3>Original graph</h3></center>'),
                                  plotOutput("graphPlot")),
                           column(width = 6,
                                  HTML('<center><h3>Reduced graph</h3></center>'),
                                  plotOutput("graphPlot")),
                           div(p("Removed edges: ", 
                                 #textOutput(outputId = "removed_edges")),
                               style = "font-size:120%",
                               align = "center")
                              )
                         ),           
        conditionalPanel(condition="input.conditionedPanels==2",
                         
                         br(),
                         
                         fluidRow(
                           
                         ))                    
              #            h3("Original Graph"),
              #            
              # div(plotOutput("graphPlot"), align="center", style="font-size: 110%"),
              #            
              #            
              #            br(),
              #            
              #            h3("Reduced Graph")

              #div(tableOutput("loadedGraph"), align="center", style="font-size: 110%"),
                         
                         
                         )
        
        
      )  
      
      
    )
   
    
  )

  )

  