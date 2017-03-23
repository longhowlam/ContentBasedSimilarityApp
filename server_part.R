NodesDF = readRDS("data/NodesDF.RDs")
RelatedMovies = readRDS("data/RelatedMovies.RDs")

server = function(input, output, session) {
  
  
  ##### Introduction TAB #################################################################################
  
  output$intro <- renderUI({
    list(
     
      h4("Videoland samenvattingen........  beschrijving....")
      
      
      )
    
  })
  
  ##### Network tab ###########################################

  output$MovieLinks <- renderVisNetwork({
  
    NodesDF = NodesDF %>% arrange(label)
    
    visNetwork(
      nodes = NodesDF, 
      edges = RelatedMovies,  
      main = "network of movies close to each other"
    ) %>% 
      visLegend() %>%
      visOptions(
        highlightNearest = list(enabled = T, degree = 0, hover = FALSE),
        nodesIdSelection = TRUE
      ) %>%
      visInteraction(
        navigationButtons = TRUE
      ) %>%
      visIgraphLayout(
        layout = "layout_with_drl", options=list(simmer.attraction=0),
        physics=FALSE
      ) %>%
      visEdges(smooth = FALSE)
    
  })
  
  output$MovieTable <- renderUI({
    movies  = input$MovieLinks_selected
    if (is.null(movies)){
      print("No movie selected")
    }
    else{
     eenfilm = NodesDF %>% 
        filter(id == as.numeric(movies)) %>% 
        select(label, description, runtime)
      
    print(eenfilm$description)
    }
  })
 
}