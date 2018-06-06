library(shiny)


shinyUI(
  fluidPage(
    #titlePanel("Reduction by Minimal Information Loss in Networks and Strings"),
    
    sidebarLayout(
      
      column(6, 
             tabsetPanel(
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
                            
                            #todo: update max dynamically on server
                            sliderInput(inputId="numberOfElements",
                                        label = "number of elements",
                                        min = 1, 
                                        max = 10, value = 1, step = 1
                                        ),
                            
                            actionButton(inputId="swapGraphsButton",
                                         label  ="Update evaluated graph")
                            
                            
                          )
                          
                        )
                        
                  ),
               
               tabPanel("For strings",
                        value=2,
                        h3("MILS for strings")
                        
                        
                        
                        )
               
               
               
               
             )
        
        
        
      ),
      
      mainPanel(
        withMathJax(),
        conditionalPanel(condition="input.conditionedPanels==1",
                         
                         br(),
                         
                         h3("Adjacency Matrix"),
                         
              #div(tableOutput("loadedGraph"), align="center", style="font-size: 110%"),
                         
                         
                         br(),
                         
                         h3("Result of evaluation")

              #div(tableOutput("loadedGraph"), align="center", style="font-size: 110%"),
                         
                         
                         )
        
        
      )  
      
      
    )
   
    
  )
  
  
  
)