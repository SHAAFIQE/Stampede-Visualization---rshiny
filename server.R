library(shiny)
library(dplyr)
library(plotly)
library(DT)
library(ggcorrplot)
library(shinycssloaders)
library(ggplot2)
library(maps)
library(leaflet)


function(input, output, session){
  
# Load data
my_data <- read.csv("human_stampedes.csv")

# Define server function

  #Structure
  output$structure <- renderPrint(
    my_data %>% 
      str()
  )
  
  #Summary 
  output$summary <- renderPrint(
    my_data %>% 
      summary()
      
  )
  
  #Data Table 
  output$dataT <- renderDataTable(
   my_data 
      
  )
  #viz
  output$histplot <- renderPlotly({
    p1 = my_data %>% 
      plot_ly() %>% 
      add_histogram(x=~get(input$var1)) %>% 
      layout(xaxis = list(title = paste(input$var1)))
    
    
    p2 = my_data %>%
      plot_ly() %>%
      add_boxplot(x=~get(input$var1)) %>% 
      layout(yaxis = list(showticklabels = F))
    
    # stacking the plots on top of each other
    subplot(p2, p1, nrows = 2, shareX = TRUE) %>%
      hide_legend() %>% 
      layout(title = "Distribution chart - Histogram and Boxplot",
             yaxis = list(title="Frequency"))
  })
  
  #Scatter 
  output$scatter <- renderPlotly({
    p = my_data %>% 
      ggplot(aes(x=get(input$var3), y=get(input$var4))) +
      geom_point() +
      geom_smooth(method=get(input$fit)) +
      labs(title = paste("Relationship between Country and Deaths", input$var3 , "and" , input$var4),
           x = input$var3,
           y = input$var4) +
      theme(  plot.title = element_textbox_simple(size=10,
                                                  halign=0.5))
    
    
    # applied ggplot to make it interactive
    ggplotly(p)
  })
  
 
  
  ### Bar Charts - State wise trend
  output$bar <- renderPlotly({
    my_data %>% 
      plot_ly() %>% 
      add_bars(x=~Country, y=~get(input$var2)) %>% 
      layout(title = paste("Countrywise Death rate for", input$var2),
             xaxis = list(title = "Country"),
             yaxis = list(title = paste(input$var2, "Death per 100,000 population")) )
  })
  
  #Rendering the box header 
  output$head1 <- renderText(
    paste("7 Countries with high rate of Death")
  )
  
  output$head2 <- renderText(
    paste("7 Countries with low rate of Death")
  )
  
  
  output$top7 <- renderTable({
    my_data %>% 
      select(Country, input$var2) %>% 
      arrange(desc(get(input$var2))) %>% 
      head(7)
    
  })
  output$low7 <- renderTable({
    my_data %>% 
      select(Country, input$var2) %>% 
      arrange(get(input$var2)) %>% 
      head(7)
  })
  
  map_data <- map_data("world")
  
  # Join data frames
  new_join <- left_join(map_data, my_data, by = c("region" = "Country"))
  
  # # Plot choropleth map
  # output$map_plot <- renderPlot({
  #   ggplot(new_join, aes(x=long, y=lat, fill=get(input$Country), group = group)) +
  #     geom_polygon(color="black", size=0.4) +
  #     scale_fill_gradient(low="#73A5C6", high="#001B3A", name = paste(input$Country, "Death rate")) +
  #     theme_void() +
  #     labs(title = paste("Choropleth map of", input$Country , " Death per 100,000 residents ")) +
  #     theme(
  #       plot.title = element_textbox_simple(face="bold", 
  #                                           size=18,
  #                                           halign=0.5),
  #       legend.position = c(0.2, 0.1),
  #       legend.direction = "horizontal"
  #     ) +
  #     geom_text(aes(x=x, y=y, label=country), size = 4, color="white")
  # })
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = 0, lat = 0, zoom = 2) %>%
      addMarkers(lng = 0, lat = 0, popup = "Center of the world")
  })
  

}


