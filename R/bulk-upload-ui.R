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
        width = 3,
        h3("NPM Table Calculator"),
        p("Use the below options to upload a local file.
        If the file is a .csv please specify the additional options below otherwise if using
        and Excel file just proceed to the Calculate button."),

            # Input: Select a file ----
        fileInput("file1", "Choose CSV/Excel File",
                  multiple = FALSE,
                  accept = c("text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv",
                          ".xlsx")),
        
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
                      p("See below for the NPM calculator results on your dataset. 
                      You can also download this updated dataframe via the Download button."),
                      fluidRow(column(8, 
                               downloadButton("downloadData", "Download Data with NPM Assessment"),
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