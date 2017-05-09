#NodesDF = readRDS("data/NodesDF.RDs")
#RelatedMovies = readRDS("data/RelatedMovies.RDs")

afstandenFrame = readRDS("data/afstandenFrame.RDs")
FILMS_ONLY = readRDS("data/FILMS_ONLY.RDs")

server = function(input, output, session) {
  
  ##### reactive functions ########################
  
  RelatedMovies <- reactive({
    afstandenFrame %>% 
      filter(
        dist > 0, 
        dist <= input$distance,
        from != to
      ) %>%
      left_join(
        FILMS_ONLY %>% select(id,title, description),
        by = c("from"="id")
      ) %>%
      left_join(
        FILMS_ONLY %>% select(id,title, description),
        by = c("to"="id")
      ) %>% 
      mutate(
        value = 100*(1-dist),
        title = round(dist,2))
    
  })
  
  NodesDF <- reactive({
    RelatedMovies = RelatedMovies()
    NodesDF = data.frame(id = unique(c(RelatedMovies$from, RelatedMovies$to))) %>%
      left_join (FILMS_ONLY) %>%
      rename(group = genre1, label = title) %>%
      mutate(
        group = as.character(forcats::fct_lump(group, n=8)),
        group = ifelse(isAdult == "True", "Adult", group),
        
        #value = 100 , #value * 10,
        title = paste0(
          "<h5>",
          label,
          "</h5> <br>",
          "<h5>Runtime ",
          runtime,
          " Genre ",
          group,
          "</h5>",
          "<img src='" ,
          boxart,
          "'  height='166' width='120'>"
        )
      )
    
    
    NodesDF %>% arrange(label)
  })
  
  
  ##### Introduction TAB #################################################################################
  
  output$intro <- renderUI({
    list(
     
      h4("Content based similarities of movies on Videoland, based on their similarities"),
      img(src="vl.png")
      
      
      )
    
  })
  
  ##### Network tab ###########################################

  output$MovieLinks <- renderVisNetwork({
    
    RelatedMovies = RelatedMovies()
    
    NodesDF = NodesDF()
    
   VN =  visNetwork(
      nodes = NodesDF, 
      edges = RelatedMovies,  
      main = "network of movies close to each other"
    ) %>% 
    visOptions(
      highlightNearest = list(enabled = T, degree = 0, hover = FALSE),
      nodesIdSelection = TRUE
    ) %>%
    visInteraction(
      navigationButtons = TRUE
    ) %>%
    visEdges(smooth = FALSE) %>%
    visGroups(
     groupname = "Adult", shape = "icon", 
      icon = list(code = "f225", size = 75, color = "red")
    ) %>% 
    visGroups(
      groupname = "Actie", color = "blue"
    ) %>%
     visGroups(
       groupname = "Kinderfilm", color = "green"
     ) %>%
    visLegend() %>%
    addFontAwesome()
   
    if(!input$force)
    {
      VN = VN %>% 
      visIgraphLayout(
        layout = "layout_with_drl", options=list(simmer.attraction=0),
        physics=FALSE
      ) 
    }else{
      VN = VN %>% 
        visPhysics(
          maxVelocity = 50,  solver = "forceAtlas2Based", stabilization = FALSE,
          forceAtlas2Based = list(gravitationalConstant = -300)
        )
   }
   VN
    
      
    
  })
  
  output$MovieTable <- renderUI({
    movies  = input$MovieLinks_selected
    if (is.null(movies)){
      print("No movie selected")
    }
    else{
     eenfilm = NodesDF() %>% 
        filter(id == as.numeric(movies)) %>% 
        select(label, description, runtime)
      
    print(eenfilm$description)
    }
  })
 
}