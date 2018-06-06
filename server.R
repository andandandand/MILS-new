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
  g <- loadGraphPA("./data/starGraphAdjMatrix.csv")
  pv <- calculatePerturbationByVertexDeletion(g, 4, 1)
  pe <- calculatePerturbationByEdgeDeletion(g ,4, 1)
  g  <- setGraphColors(g, pv, pe)
  
  
  
  
})