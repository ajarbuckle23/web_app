library(shiny)

positions = c("Boss", "Manager", "Intern") 
matches = c("Strong only", "Good and above", "All")

ui <- fluidPage(
  titlePanel("Internal Slate"),
  sidebarLayout(
    sidebarPanel(helpText("Find out which employees have matched with different 
                          open positions."),
                 selectInput(inputId = "positions", label = "Seniority Level", 
                             choices = positions), 
                 selectInput(inputId = "matches", label = "Match Strength", 
                             choices = matches),
                 fileInput(inputId = "file", label = "Choose a CSV File"),
                 actionButton(inputId = "go", label = "Show Results"),
                 img(src = "VertexLogo.png", height = 100, width = 150, align 
                     = "center")), 
    mainPanel(textOutput(outputId = "text"), 
              textOutput(outputId = "text2"), 
              tableOutput(outputId = "table"))
  )
)

# Generate list of employees who match open position with specified strength 
# level; first use job query, then find employees who match it at all, then 
# filter down based on strength level 

server <- function(input, output) {
  # Outputting the position after hitting the button
  positiondata <- eventReactive(input$go, {
    input$positions
  })
  output$text <- renderText({
    positiondata()
  })
  
  # Outputting the match strength after hitting the button
  matchdata <- eventReactive(input$go, {
    input$matches
  })
  output$text2 <- renderText({
    matchdata()
  })
  
  # Outputting the specified CSV information 
  filedata <- eventReactive(input$go, {
    read.csv(input$file$datapath)
  })
  output$table <- renderTable({
    filedata()
  })
}

shinyApp(ui = ui, server = server)