require("igraph")

source("scripts/BDM1D.R")
source("scripts/BDM2D.R")
source("scripts/compressionLength.R")
source("scripts/loadGraph.R")
source("scripts/edgeAndVertexKnockout.R")
source("scripts/relabelTables.R")

source("scripts/listEdges.R")


shinyServer(function(input, output, session) {
  
###### Perturbation Analysis Tab

#runs once, when server starts
g <- loadGraphPA("./data/m88.csv")
pv <- calculatePerturbationByVertexDeletion(g, 4, 1)
pe <- calculatePerturbationByEdgeDeletion(g, 4, 1)
g  <- setGraphColors(g, pv, pe)

#all of these must be cleared and updated when a new graph is loaded

sizeOfHistory <- vcount(g) + ecount(g)

graphHistory    <- list()

pvHistory       <- list()

peHistory       <- list()

delEventHistory <- vector("list", 
                          sizeOfHistory)

graphHistory[[1]]    <- g
pvHistory[[1]]       <- relabelVertexTable(pv)
peHistory[[1]]       <- relabelEdgeTable(pe)
delEventHistory[[1]] <- "Initial state of the network"

#starts with 1 even though the network hasn't been changed at the start
perturbationCounter <- as.integer(1)

my <- reactiveValues(g = g,
                     pv = pv,
                     pe = pe,
                     perturbationCounter = perturbationCounter, 
                     sizeOfHistory       = sizeOfHistory,
                     graphHistory        = graphHistory,
                     pvHistory           = pvHistory,
                     peHistory           = peHistory,
                     delEventHistory     = delEventHistory)

observe({
  
  updateSelectInput(session, "vertexToDelete",
                    choices = V(my$g)$label)
  
  updateSelectInput(session, "edgeToDelete",
                    choices = listEdges(my$g))
  
})

observeEvent(input$file2, {
  
  inFile <- input$file2
  
  if (is.null(inFile$datapath)){
    
    
  } else {
    
    g <- loadGraphPA(inFile$datapath)
    my$pv <- calculatePerturbationByVertexDeletion(g, 4, 1)
    my$pe <- calculatePerturbationByEdgeDeletion(g, 4, 1)
    my$g  <- setGraphColors(g, my$pv, my$pe)
    
    my$sizeOfHistory <- vcount(my$g) + ecount(my$g)
    
    my$perturbationCounter <- as.integer(1)
    
    #todo: check if this vector("list", my$sizeOfHistory) 
    #works with list() in Report.Rmd
    graphHistory     <- vector("list", my$sizeOfHistory)
    ptHistory        <- vector("list", my$sizeOfHistory)
    pvHistory        <- vector("list", my$sizeOfHistory)
    delEventHistory  <- vector("list", my$sizeOfHistory) 
    
  }
  
}, ignoreInit = FALSE) 
# ignoreInit = FALSE is default behavior
# these initializations run when the server is first set up

observeEvent(input$goButtonDeleteVertex, {
  
  if(vcount(my$g) > 5){
    
    my$perturbationCounter <- my$perturbationCounter + 1
  
    my$g <- delete_vertices(my$g,
                            input$vertexToDelete)
    
    my$pv <- calculatePerturbationByVertexDeletion(my$g, 4, 1)
    my$pe <- calculatePerturbationByEdgeDeletion(my$g, 4, 1)
    
    my$g  <- setGraphColors(my$g, my$pv, my$pe)
    
    my$graphHistory[[my$perturbationCounter]] <- my$g
    my$pvHistory[[my$perturbationCounter]]    <- relabelVertexTable(my$pv)
    my$peHistory[[my$perturbationCounter]]    <- relabelEdgeTable(my$pe)
    
    my$delEventHistory[[my$perturbationCounter]] <- paste0("Deletion of node ", 
                                                           input$vertexToDelete)    
    
    
  }
  
  else {
    
    output$cantDeleteVertex <- renderText({
      
      "can't delete more nodes"
      
    })
    
  }
  
})

observeEvent (input$goButtonDeleteEdge, {
  
  if(ecount(my$g) > 1){
    
    my$g <- delete_edges(my$g,
                         input$edgeToDelete)
    
    my$pv <- calculatePerturbationByVertexDeletion(my$g, 4, 1)
    my$pe <- calculatePerturbationByEdgeDeletion(my$g, 4, 1)
    
    my$g  <- setGraphColors(my$g, my$pv, my$pe)
    
    my$perturbationCounter <- my$perturbationCounter + 1
    
    my$graphHistory[[my$perturbationCounter]] <- my$g
    my$pvHistory[[my$perturbationCounter]]    <- relabelVertexTable(my$pv)
    my$peHistory[[my$perturbationCounter]]    <- relabelEdgeTable(my$pe)
    
    
    my$delEventHistory[[my$perturbationCounter]] <- paste0("Deletion of link ", 
                                                           input$edgeToDelete) 
    
  } else {
    
    output$cantDeleteLink <- renderText("can't delete more links")
    
  }
  
})

output$graphPlot <- renderPlot({
  
  coords <- layout_(my$g, as_star())
  
  plot(my$g,
       layout = coords,
       edge.arrow.size = 0.4,
       vertex.size = 25,
       vertex.label.family = "Arial Black")
  
})

output$perturbationTable <- renderTable ({
  
  if(input$printTable == "edges"){
    edgeTable <- relabelEdgeTable(my$pe)
    return(edgeTable)
  }
  else {
    
    vertexTable <- relabelVertexTable(my$pv)
    
    return(vertexTable)
    
  }
  
}, digits = 3)


### downloadHandler for HTML report

output$report <- downloadHandler (
  
  filename = "report.html",
  
  content = function(file){
    
    tempReport <- file.path(tempdir(),
                            "report.Rmd")
    
    file.copy("report.Rmd", tempReport,
              overwrite = TRUE)
    
    printG <- my$g
    
    printVT <- relabelVertexTable(my$pv)
    
    printET <- relabelEdgeTable(my$pe)
    
    params <- list(graphHistory = my$graphHistory,
                   pvHistory = my$pvHistory,
                   peHistory = my$peHistory,
                   perturbationCounter = my$perturbationCounter,
                   delEventHistory = my$delEventHistory)
    
    rmarkdown::render(tempReport, 
                      output_file = file,
                      params = params,
                      envir = new.env(globalenv()))
    
  }
  
)

})#end shinyServer function
