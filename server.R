require("igraph")

source("scripts/BDM1D.R")
source("scripts/BDM2D.R")
source("scripts/compressionLength.R")
source("scripts/loadGraph.R")
source("scripts/edgeAndVertexKnockout.R")
source("scripts/relabelTables.R")
source("scripts/listEdges.R")


shinyServer(function(input, output, session) {
  
  
  ## MILS 2D tab
  
  #g is an igraph graph, not an adjacency matrix
  g <- loadGraphPA("./data/starGraphAdjMatrix.csv")
  pv <- calculatePerturbationByVertexDeletion(g, blockSize=4, offset = 1)
  #print(pv)
  pe <- calculatePerturbationByEdgeDeletion(g, blockSize = 4, offset = 1)
  #print(pe)
  
  # TODO: define a graph coloring different 
  # from the one used in perturbation analysis
  # g  <- setGraphColors(g, pv, pe)
  
  #TODO: rename to "deletionsCounter"
  perturbationCounter <- as.integer(1)
  
  reactiveData <- reactiveValues(g = g,
                                 pv = pv,
                                 pe = pe,
                                 perturbationCounter = perturbationCounter)
  
  #changed from observe
  observeEvent(input$numberOfElements, {

    elems <- 0
    if(input$elementsToDelete == "vertices"){ 
      #number of vertices  
      elems <- vcount(reactiveData$g)
    } 
    else{
      #ecount takes into account directed edges
      elems <- ecount(reactiveData$g)
    }
    
    print(elems)
     
     updateSliderInput(session,
                       "numberOfElements",
                       max = elems)
     
    
  })
  
  ## deconvolve's solution  
  # observeEvent(input$n_components, {
  #   
  #   updateSliderInput(session,
  #                     "n_components",
  #                     max = vcount(react_graph$g))
  # })
  
  output$graphPlot <- renderPlot({
    
    coords <- layout_(reactiveData$g, as_star())
    
    plot(reactiveData$g,
         layout = coords,
         edge.arrow.size = 0.4,
         vertex.size = 25,
         vertex.label.family = "Arial Black")
    
  }) 

})