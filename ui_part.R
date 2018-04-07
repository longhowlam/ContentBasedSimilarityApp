ui <- dashboardPage(
  dashboardHeader(title = "Videoland Movies Network", titleWidth = "330px"),
  dashboardSidebar(width = 200,
                   
                   sidebarMenu(
                     menuItem("Introduction", tabName = "Introduction", icon = icon("euro")),
                     menuItem("Movies Network", tabName = "ArtistNetwork2", icon = icon("link")),
                     numericInput("distance", "Max distance", 0.8, min=0.01, max=1, step=0.02),
                     checkboxInput("force","Force network"),
                     selectInput("networks", "layout", choices = grep("^layout\\.", ls("package:igraph"), value=TRUE))
                   ) 
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "Introduction",
              titlePanel("Introduction"),
              mainPanel(
                htmlOutput("intro")
              )
      ),
      
      tabItem(
        tabName = "ArtistNetwork2",
        mainPanel( width = 12,
          fluidRow(
            column(8, visNetworkOutput("MovieLinks", height = "700px", width = "1100px")),
            column(4, htmlOutput("MovieTable"))
          )
        )
      )
    )
  )
)
