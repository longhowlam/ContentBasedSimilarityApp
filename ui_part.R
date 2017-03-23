ui <- dashboardPage(
  dashboardHeader(title = "Videoland Movies Network", titleWidth = "330px"),
  dashboardSidebar(width = 200,
                   
                   sidebarMenu(
                     menuItem("Introduction", tabName = "Introduction", icon = icon("euro")),
                     menuItem("Movies Network", tabName = "ArtistNetwork2", icon = icon("link"))
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
            column(8, visNetworkOutput("MovieLinks", height = "700px")),
            column(4, htmlOutput("MovieTable"))
          )
        )
      )
    )
  )
)
