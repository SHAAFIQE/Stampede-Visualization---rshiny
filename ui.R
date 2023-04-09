library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(plotly)
library(leaflet)
library(shinycssloaders)




dashboardPage(
  skin = c("purple"),
  dashboardHeader(title= "Stampede Estimation 1800 - 2021",
                  titleWidth = 380,
                  tags$li(class="dropdown", tags$a(href="https://github.com/SHAAFIQE", icon("github"), "My GITHUB", target = "_blank")),
                  tags$li(class="dropdown", tags$a(href="https://www.linkedin.com/in/shaafiqe-m-2a0051249", icon("linkedin"), "My LINKEDIN", target = "_blank"))
                  
                  ),
  dashboardSidebar(
    #sidebarmenu
    sidebarMenu(
      id = "sidebar",
      
      #first menuitem
      menuItem("Dataset", tabName = "data", icon = icon("database")),
      menuItem(text= "Visualization", tabName = "viz", icon = icon("chart-line")),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'distro'", selectInput(inputId = "var1" , label ="Select the Variable" , choices = c1)),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'trends' ", selectInput(inputId = "var2" , label ="Select the Country" , choices = c2)),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'relation' ", selectInput(inputId = "var3" , label ="Select the X variable" , choices = c1, selected = "Country")),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'relation' ", selectInput(inputId = "var4" , label ="Select the Y variable" , choices = c1, selected = "Number of Deaths")),
      menuItem(text= "Map", tabName = "map", icon = icon("map"))
      
    )
  ),
  
  dashboardBody(
    tabItems(
      #first tab item 
      tabItem(tabName = "data",
              #tab box
              tabBox(id = "t1", width = 12,
                     tabPanel("About", icon = icon("address-card"), h6("When a crowd of people moves in the same direction at the same time, some may collide and pile up against or on top of each other. This can get very dangerous very quickly. Experts refer to such an incident as a stampede, crowd surge, or crowd crush.")),
                     # column(width=8, img(src="crowd.jp", width = 400, height = 200),
                     #        tags$br(),
                     #        tags$a("Photo by Pedestrian"), align = "center"),
                     # column(width = 6, tags$br(),
                     #        tags$p("A stampede by a crowd refers to a situation in which a large group of people, typically in a confined space, start running or pushing in a panicked or frenzied manner, often resulting in injuries or deaths. Stampedes can occur in various situations, such as at sporting events, concerts, religious gatherings, or during emergency evacuations.")
                     # ),
                     tabPanel(title= "Data", icon = icon("address-card"), dataTableOutput("dataT")),
              tabPanel(title= "Structure", icon = icon("address-card"), verbatimTextOutput("structure")),
              tabPanel(title= "Summary stats", icon = icon("address-card"), verbatimTextOutput("summary")
                     
              )),
              
          ),
      
      #Second tab Item or Landing Page 
      tabItem(tabName = "viz",
              tabBox(id="t2", width = 12,
                     tabPanel(title = "Stampede trend by Country", value = "trend", 
                              fluidRow(tags$div(align="center", box(tableOutput("top7"), title = textOutput("head1") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE)),
                                       tags$div(align="center", box(tableOutput("low7"), title = textOutput("head2") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE))
                                       
                              ), plotlyOutput("bar")
                             
                          ),
                     tabPanel(title = "Distribution", value = "distro", plotlyOutput("histplot")),  
                     # tabPanel(title = "Correlation Matrix", plotlyOutput("cor")),  
                     tabPanel(title = "View Relationships", value = "relation",
                      radioButtons(inputId ="fit" , label = "Select smooth method" , choices = c("loess", "lm"), selected = "lm" , inline = TRUE),          
                      plotlyOutput("scatter")) 
                     
              )
      ),
      # Third Tab Item
      tabItem(
        tabName = "map", 
        box(      selectInput("Country","Select Country", choices = c("United States","United Kingdom","India","Israle"), selected="India", width = 250)),
                  # withSpinner(plotOutput("map_plot")), width = 12)
        leafletOutput("map",  width = 1500, height = 600)
    )
  )
)
)
