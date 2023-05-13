# bulk upload shiny component
library(shiny)
library(DT)

# define a tabPanel for introducing the NPM Table calculator
introTab <- tabPanel(
  title = tags$b("NPM Table Calculator"),
  value = "bulkDataDesc",
  h3("Introducing the NPM Table Calculator"),
  p("At present the Table Calculator is experimental and not guaranteed
  to work against all data. Please use the available template spreadsheet files
  to populate your data against and run with the Table Calculator. This ensures
  the data contains correct column names and categories for steps used by the 
  Table Calculator.",
  class= "alert alert-warning"),
  p("To help with larger datasets of product information
  you want testing against the Nutrient Profile Model we 
  have introduced a new, experimental Table Calculator mode.
  This mode offers the ability to upload a dataset of product
  information and run the entire table through the Nutrient Profile
  Model. It visualises these results and makes it possible to 
  download a copy of your data with the additional columns
  corresponding to the Nutrient Profile Model assessment."),
  p("Once you have prepared your data click Next and move to
  the Upload Data tab. There you can upload your data file 
  which should be either CSV or Excel format. Once uploaded
  your data will be previewed within that tab where you can 
  visually check the data looks correct. When ready click Calculate
  NPM scores to run the Table Calculator against your data. If an error
  occurs during this step a popup will appear that includes some error
  information. If it is unclear how to fix your error please raise an
  issue on ",a(href="https://github.com/Leeds-CDRC/NPM-Calculator/issues/new",
  "GitHub (sign in required) ")," sharing your error information or email the CDRC via ",
  a(href="mailto:info@cdrc.ac.uk", "info@cdrc.ac.uk"),
  " including all error information."),
  p("If this step proceeds without error you will move to the Results
  tab, where you will be able to view a summary of your results and a 
  small preview table of your data showing the result of the NPM 
  calculation. You will also be able to download your dataset as a CSV file
  with additional columns generated during the assessment step."),
  # a centered row that contains anchors for downloading
  # template data files
  fluidRow(style = "text-align:center;",
    column(12,
          a(href="example-NPM-data.xlsx", 
          "Download template Excel file", 
          download=NA, 
          target="_blank",
          class="btn btn-primary"),
        a(href="example-NPM-data.csv", 
          "Download template CSV file", 
          download=NA, 
          target="_blank",
          class="btn btn-primary")
        ),
      ),
      # row containing button to move to next tab
      fluidRow(style = "margin: 1.5%; text-align:center;",
        column(12,
              actionButton('moveBulkTab', "Next", icon = icon("nutritionix"),
              style = "color: white; background-color: teal;", width = '40%'),
        )
      ),
    h3("Input data reference table"),
    p("Below is a reference table for the expected input data frame configuration
    including a description of expected data. This reference table should be used alongside 
    the downloadable template Excel and CSV files used above."),
    tableOutput("bulkExampleTable")
      )


# define a tabPanel for the uploading data tab
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


# define a tabPanel for the results of running the nutrient profiler pipeline
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
# this variable contructs the full tab panel from
# all other tabs defined above
bulkTab <- tabPanel("Table Calculator",
                    value = "bulkCalc",
                    tabsetPanel(type = "tabs", 
                                shinyjs::useShinyjs(), 
                                id ="calc2",
                                introTab,
                                tableTab,
                                resultTab
                    )
)