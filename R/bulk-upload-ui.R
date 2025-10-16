# # License

# The NPM calculator and underlying nutrientprofiler R package provide functions to help assess product information against the UK Nutrient Profiling Model (2004/5) and scope for HFSS legislation around product placement. It is designed to provide low level functions that implement UK Nutrient Profiling Model scoring that can be applied across product datasets.

# Copyright (C) 2024 University of Leeds

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# A copy of the GNU Affero General Public License is supplied
# along with this program in the `LICENSE` file in the repository.
# You can also find the full text at https://www.gnu.org/licenses.

# You can contact us by raising an issue on our GitHub repository (https://github.com/Leeds-CDRC/NPM-Calculator/issues/new - login required) or by emailing
# us at info@cdrc.ac.uk.
# bulk upload shiny component
library(shiny)
library(DT)

# New HASP Colours
# #0b5126, #24226f, #7cc6fe, #ffffff, #8789c0, #f06449
# Additional colours:
# lighter main: #3f3c84ff
# lighter background: #e2e4ffff 
# Alternative wellpanel style
# background-color:white; border: 2px solid #f06449;


# define a tabPanel for introducing the NPM Multiple Product Calculator
introTab <- tabPanel(
  title = tags$b("NPM Multiple Product Calculator"),
  value = "bulkDataDesc",
  fluidRow(
    column(1),
    column(10,
  h3("NPM Multiple Product Calculator"),
  # p("At present the Multiple Product Calculator is experimental and not guaranteed
  # to work against all data. Please use the available template spreadsheet files
  # to populate your data against and run with the Multiple Product Calculator. This ensures
  # the data contains correct column names and categories for steps used by the 
  # Multiple Product Calculator.",
  # class= "alert alert-warning"),
  # p("The Multiple Product Calculator uses the nutrientprofiler R package to calculate
  # NPM scores. Find out more about this package here:",a("nutrient profiler documentation",
  # href="https://leeds-cdrc.github.io/nutrientprofiler/", style = "color:white;font-weight: bold;", target="_blank")," . This tool currently uses",a("nutrientprofiler version 2.0.0.",
  # href="https://github.com/Leeds-CDRC/nutrientprofiler/releases/tag/v1.0.0", style = "color:white;font-weight: bold;", target="_blank"),"Please note this alongside your analysis. ",
  # class= "alert alert-success"),
  p("The Multiple Product Calculator mode enables you to upload a spreadsheet of information for multiple products and run the entire table through the Nutrient Profile Model.",
  "Note that this calculator is not optimized for mobile use and is recommended for use at a computer. Please use the Single Product Calculator for on-the-go mobile scoring.",
  fluidRow(
    column(6,
    wellPanel(style = "border: 2px solid #f06449;",
    h4("How to use the Multiple Product Calculator:"),
  "1.   Download the template Excel or CSV file provided.", br(), br(),
  "2.   Prepare your data, ensuring you are using the correct column names and categories (the template Excel file contains drop down options for categorical variables).", br(), br(),
  "3.   Select the ‘Upload Data’ tab.", br(), br(),
  "4.   Upload your Excel or CSV file – once uploaded you can preview to check the data looks correct.",br(), br(),
  "5.   Click ‘Calculate NPM scores’",br(), br(),
  "6.   The calculator will provide a summary and small preview of the results. Any errors will be flagged at this stage.",br(), br(),
  "7.   Download your full results (CSV file).",br(), br(),
  ),
    ),
    column(6,
    # a(href="example-NPM-data.xlsx", 
    #       "Download template Excel file", 
    #       download=NA, 
    #       target="_blank",
    #       class="btn btn-primary",),
    #       br(), br(),
    #      a(href="example-NPM-data.csv", 
    #       "Download template CSV file", 
    #       download=NA, 
    #       target="_blank",
    #       class="btn btn-primary"),
    #       br(), br(),
          actionButton('downloadExcelBulk', "Excel template", icon = icon("download"),
              style = "color: white; background-color: #24226f;", width = '100%',
              onclick ="window.open('NPM calculator template.xlsx', '_blank')"),
          br(), br(),
          actionButton('downloadCSVBulk', "CSV file template", icon = icon("download"),
              style = "color: white; background-color: #24226f;", width = '100%',
              onclick ="window.open('NPM calculator template.csv', '_blank')"),
          br(), br(),
  #         actionButton('moveBulkTab', "Next", icon = icon("nutritionix"),
  #             style = "color: white; background-color: #24226f;", width = '100%'),
  #             br(),
  # br(),
  wellPanel(
                            h3("Help using the tool"),
                            p("Our tools are designed to be intuitive and easy to use. Please read our detailed user guide
                            for step-by-step instructions."),
                            actionButton('howToVideo3', "'How To' video", icon = icon("play"),
                                               style = "color: white; background-color: #24226f", width = '100%',
                                               onclick ="window.open('https://www.youtube.com/watch?v=asFKi9jrr0U', '_blank')"),
                                               br(), br(),
                            actionButton('jumpToGuideFromBulk', "User Guide", icon = icon("book-open"),
                                               style = "color: white; background-color: #24226f", width = '100%'),
                          ),

  br(),
  p("Should you experience any difficulties using the NPM Calculator, please contact", a(href="mailto:hasp@leeds.ac.uk", "hasp@leeds.ac.uk", style = "font-weight: bold;"), "including a screenshot of any relevant error messages.",
                                            class= "alert alert-success"),

    actionButton('moveBulkTab', "Next", icon = icon("nutritionix"),
              style = "color: white; background-color: #24226f;", width = '100%'),
          
    ),
  ),
  ),
  # br(),
  # br(),
  # h4("Help using the tool"),
  # p("Link will go here to guide video."),
  # br(),
  # p("Please see the 'Multiple Product Calculator Guide' section of the 'User guide'
  # for more information on the parameters required."),

  # fluidRow(style = "text-align:center;",
  #   column(12,
  #         a(href="example-NPM-data.xlsx", 
  #         "Download template Excel file", 
  #         download=NA, 
  #         target="_blank",
  #         class="btn btn-primary"),
  #       a(href="example-NPM-data.csv", 
  #         "Download template CSV file", 
  #         download=NA, 
  #         target="_blank",
  #         class="btn btn-primary"),
  #       ),
  #     ),
  #     # row containing button to move to next tab
  #     fluidRow(style = "margin: 1.5%; text-align:center;",
  #       column(12,
  #             actionButton('moveBulkTab', "Next", icon = icon("nutritionix"),
  #             style = "color: white; background-color: #24226f;", width = '40%'),
  #       )
  #     ),
  #   p("Should you experience any difficulties using the NPM Calculator, please contact", a(href="mailto:info@cdrc.ac.uk", "info@cdrc.ac.uk", style = "font-weight: bold;"), "including a screenshot of any relevant error messages.",
  #                                           class= "alert alert-success"),
      )))



# define a tabPanel for the uploading data tab
tableTab <- tabPanel(
    title = tags$b("Upload data"),
    value = "bulkDataUpload",
    br(),
      # Sidebar layout with input and output definitions ----
  sidebarLayout(
    # Sidebar panel for inputs ----
      sidebarPanel(
        width = 3,
        h3("NPM Multiple Product Calculator"),
        p("Use the below options to upload a local file.
        You can check your data in the panel to the right, then
        select 'Calculate' below."),

            # Input: Select a file ----
        fileInput("file1", "Choose CSV/Excel File",
                  multiple = FALSE,
                  accept = c("text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv",
                          ".xlsx")),
        
        actionButton('runBulk', " Calculate  ", icon = icon("nutritionix"),
              style = "color: white; background-color: #24226f", width = '100%')
      ),

      # Main panel for displaying outputs ----
      mainPanel(
        h4("Your uploaded data"),
        # Output: Data file ----
        DTOutput("bulkTable", height = "500px"),
        p("Common sources of error include: incorrect or missing column names; missing required parameters; and empty or blank rows. If you receive an error message, please check your input data to ensure no required information is missing.", 
                      class= "alert alert-warning"),
      )
    ),


)


# define a tabPanel for the results of running the nutrient profiler pipeline
resultTab <- tabPanel(tags$b("Results"), value = "bulkResult",
                      h3("Results"),
                      br(),
                      p("See below for the NPM calculator results on your dataset. 
                      You can also download this updated dataframe via the Download button."),
                      fluidRow(column(8, 
                               downloadButton("downloadData", "Download Data with NPM Assessment"),
                               plotOutput("bulkResultPlot", height = 200) )
                      ),
                      p("If one of your data entries returns ERROR instead of an NPM assessment and score (PASS or FAIL), please check that all required parameters have been filled in. Ensure 'fvn_measurement_percent' is set to a value at/between 0 and 100.", 
                      class= "alert alert-warning"),
                      DTOutput("bulkResultTable", 
                      height = "500px"),
                      p("The Multiple Product Calculator uses the nutrientprofiler R package to calculate
                        NPM scores. Find out more about this package here:",a("nutrient profiler documentation",
                        href="https://leeds-cdrc.github.io/nutrientprofiler/", style = "font-weight: bold;", target="_blank")," . This tool currently uses",a("nutrientprofiler version 2.0.0.",
                        href="https://github.com/Leeds-CDRC/nutrientprofiler/releases/tag/v1.0.0", style = "font-weight: bold;", target="_blank"),"Please note this alongside your analysis. ",
                        class= "alert alert-success"),
                      )

# the main tab constructor
# this variable contructs the full tab panel from
# all other tabs defined above
bulkTab <- tabPanel("Multiple Product Calculator",
                    value = "bulkCalc",
                    wellPanel(style="background-color:#f7fbfb; border: 2px solid #f06449",
                    tabsetPanel(type = "pills", 
                                shinyjs::useShinyjs(), 
                                id ="calc2",
                                introTab,
                                tableTab,
                                resultTab
                    ))
)