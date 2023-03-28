# bulk upload shiny component
library(shiny)
library(DT)


tableTab <- tabPanel(
    title = tags$b("Upload data"),
    value = "bulkDataUpload",
      # Sidebar layout with input and output definitions ----
  sidebarLayout(
    # Sidebar panel for inputs ----
      sidebarPanel(
        width = 2,

            # Input: Select a file ----
        fileInput("file1", "Choose CSV/Excel File",
                  multiple = FALSE,
                  accept = c("text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv",
                          ".xlsx")),

        # Horizontal line ----
        tags$hr(),

        # Input: Checkbox if file has header ----
        checkboxInput("header", "Header", TRUE),

        # Input: Select separator ----
        radioButtons("sep", "Separator",
                    choices = c(Comma = ",",
                                Semicolon = ";",
                                Tab = "\t"),
                    selected = ","),

        # Input: Select quotes ----
        radioButtons("quote", "Quote",
                    choices = c(None = "",
                                "Double Quote" = '"',
                                "Single Quote" = "'"),
                    selected = '"'),
        
        actionButton('runBulk', "Calculate NPM scores", icon = icon("nutritionix"),
              style = "color: white; background-color: teal", width = '100%')
      ),

      # Main panel for displaying outputs ----
      mainPanel(
        # Output: Data file ----
        DTOutput("bulkTable", height = "500px")
      )
    ),


)



resultTab <- tabPanel(tags$b("Results"), value = "bulkResult",
                      h3("Results"),
                      fluidRow(column(8, 
                               downloadButton("downloadData", "Download"),
                               plotOutput("bulkResultPlot", height = 200) )
                      ),
                      DTOutput("bulkResultTable", 
                      height = "500px"),
                      )

# the main tab constructor

bulkTab <- tabPanel("Table Calculator",
                    value = "bulkCalc",
                    tabsetPanel(type = "tabs", 
                                shinyjs::useShinyjs(), 
                                id ="calc2",
                                tableTab,
                                resultTab
                    )
)