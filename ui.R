# Automating a Nutrient Profiling Model
# Adapted from https://github.com/VickiJenneson/NPM_Promotional_Restrictions
# 2021, Rosalind Martin, Data Scientist Intern, Leeds Institute for Data Analytics
# Supervisors: Michelle Morris and Vicki Jenneson, University of Leeds
# Modifications by Maeve Murphy Quinlan, 2024

# # License

# The NPM calculator and underlying nutrientprofiler R package provide functions to help assess product information against the UK Nutrient Profiling Model (2004/5) and scope for HFSS legislation around product placement. It is designed to provide low level functions that implement UK Nutrient Profiling Model scoring that can be applied across product datasets.

# Copyright (C) 2025 University of Leeds

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
# us at info@hasp.ac.uk.


# load libraries ----
library(shiny)
library(dplyr)
library(tidyverse)
library(vroom)
library(shinyBS)
library(ggplot2)
library(shinythemes)
library(DT)
library(fresh)

# New HASP Colours
# #0b5126, #24226f, #7cc6fe, #ffffff, #8789c0, #f06449
# Additional colours:
# lighter main: #3f3c84ff
# lighter background: #e2e4ffff 
# Alternative wellpanel style
# background-color:white; border: 2px solid #f06449;


custom_theme <- create_theme(
  theme = "default",
  bs_vars_global(
    body_bg = "#FFFFFF",
    link_color="#24226f",
    grid_gutter_width = "45px",
    link_hover_color = "#0b5126"
  ),
  bs_vars_pills(
  border_radius = NULL,
  active_link_hover_bg = "#24226f",
  active_link_hover_color = NULL
),
  bs_vars_navbar(
    height = "80px",
    padding_horizontal = "15px",
    padding_vertical = "30px",
    # margin_bottom = "10px",
    default_bg = "#FFFFFF",
    default_border = "#FFFFFF",
    default_color = "#24226f",
    default_link_color = "#24226f",
    default_link_active_color = "#FFFFFF",
    default_link_active_bg = "#24226f",
    default_link_hover_color = "#0b5126",
    default_link_hover_bg = NULL,
  ),
  bs_vars_font(
  size_base = "18px",
  family_sans_serif = "'Figtree', cursive"
),
  bs_vars_wells(
    bg = "#e2e4ffff",
    border = "#FFFFFF"
  ),
  bs_vars_panel(
  bg = "#24226f",
  body_padding="15px",
)
)

tagList(
shinyUI(
  fluidPage(
    use_theme(custom_theme),
    use_googlefont("Figtree"),
    lang = "en",
    tags$head(includeHTML("www/google-analytics.html"),
    ui <- fluidPage(
      tags$style(HTML("
        table.dataTable thead th {
          white-space: nowrap;       /* keep text on one line */
          overflow: hidden;          /* hide overflow */
          text-overflow: ellipsis;   /* show '...' */
          max-width: 250px;          /* adjust width as needed */
        }
      ")),
      
      DTOutput("bulkTable")
    ),
    includeCSS("www/branding.css"),
    ), # close
    
    # Home page ----
    navbarPage(title = a(p(strong("NPM", style = "color:#24226f;font-size:40px;text-align: center;vertical-align: middle;"),strong("Calculator", style="font-size:30px;vertical-align: middle; color:#3f3c84ff"), br(),em("Nutrient Profile Model Calculator", style="font-size:16px; color:black")),href="https://npmcalculator.hasp.ac.uk/", style="text-decoration:none"), collapsible=TRUE, 
    fluid=TRUE, id="about",
               tabPanel(p("Home", style = "font-size:25px;", id = "about"),
                        fluidRow(
                          column(1),
                          column(10,
                          h3("NPM Calculator: Simple, consistent and transparent NPM scoring"),
                          ),
                          column(1)
                        ),
                        fluidRow(
                          column(1),
                          column(5,
                          br(),
                          p("Use the NPM Calculator to assess a product's UK Nutrient Profile Model (NPM) score."),
                          strong("✓   Assess one product at a time. Great for on the go."),
                              actionButton('jumpToCalc', "Single product", icon = icon("nutritionix"),
                                        style = "color: white; background-color: #24226f", width = '100%'),
                            
                            br(),
                            br(),

                            strong("✓   Upload a table to calculate the NPM score for many products at once."),
                            actionButton('jumpToBulkHome', "Multiple products", icon = icon("nutritionix"),
                                        style = "color: white; background-color: #24226f", width = '100%'),
                                        br(),
                                        hr(style = "border-top: 3px solid #f06449;"),
                                        # bsCollapsePanel(title=p(icon("up-right-and-down-left-from-center"), strong("Click to show/hide form"), style = "color: white; background-color: #24226f;font-size:20px;text-align: center;vertical-align: middle;", align="center"),
                                        # p("Please tell us the purpose of your assessment.", style = "color: white; background-color: #24226f"), style = "color: white; background-color: #24226f",
                                        # includeHTML("www/responses.html")
                                        # ),
                                        div(style = "text-align: center;",
                                        p("Please tell us how and why you are using this tool:"),
                                        actionButton('infoForm1Home', "Open poll in new tab", icon = icon("square-poll-vertical"),
                                               style = "color: white; background-color: #3f3c84ff;", width = '100%',
                                               onclick ="window.open('https://forms.office.com/e/MDEGQVeR6r', '_blank')"),),
                                        br(),

                                        # ui.accordion(
                                        #   ui.accordion_panel(title="Testing",),
                                        #   open=FALSE,
                                        #   width = '100%',
                                        # ),
                                        

                                        # br(),
              #                           hr(style = "border-top: 3px solid #f06449;"),
              #                           h2("Who is it for?"),
              #  p("The NPM Online Calculator is a quick, easy and transparent way to generate a product's NPM score, and check if it may be captured by The Food (Promotion and Placement) (England) Regulations 2021 ('HFSS legislation'), supporting consistency among:"),
              #  tags$ul(p(tags$span(style ="color:#24226f","✓   Retailers"))),
              #  tags$ul(p(tags$span(style ="color:#24226f","✓   Manufacturers"))),
              #  tags$ul(p(tags$span(style ="color:#24226f","✓   Policymakers"))),
              #  tags$ul(p(tags$span(style ="color:#24226f","✓   Academics"))),
              #  tags$ul(p(tags$span(style ="color:#24226f","✓   NGOs"))),
                          ),
                          column(5,
                          br(),
                          wellPanel(
                            strong("The NPM Calculator supports you to:"), br(), br(),
                          "✓   Quickly calculate a product's UK Nutrient Profile Model (NPM) score based on the 2004/5 NPM model", br(), br(),
                          "✓   Make informed decisions and comply with legislation", br(), br(),
                          "✓   Easily calculate scores at your desk or on the go, via your web browser", br(), br(),
                          "✓   Take a transparent approach to NPM scoring, promoting consistency and confidence in results", br()
                          ),
                          # tags$h5(tags$span(style ="color:#24226f","✓   Quickly calculate a product's UK Nutrient Profile Model (NPM) score"),sep ="",align = "left"),
                          # tags$h5(tags$span(style ="color:#24226f","✓   Support decision-making and compliance with legislation"),sep ="",align = "left"),
                          # tags$h5(tags$span(style ="color:#24226f","✓   Easy to use at your desk or on the go"),sep ="", align = "left"),
                          # tags$h5(tags$span(style ="color:#24226f","✓   Transparent approach, promoting consistency and confidence in results"),sep ="", align = "left"),
                          ),
                          column(1),
                        #   column(6,
                        # # p("Before you begin, please tell us how you'll be using the tool."),
                        # # includeHTML("www/responses.html"),
                        #   ),
                        ),
                        br(), br(),
                        fluidRow(
                          column(1),
                          column(5,
                          wellPanel(
                            h2("Help using the tool"),
                            p("Our tools are designed to be intuitive and easy to use.
                            Please watch our quick 'How To' video for step by step instructions, or read our User Guide for more detailed information."),
                            actionButton('howToVideo1', "How to: single product", icon = icon("play"),
                                               style = "color: white; background-color: #24226f", width = '100%',
                                               onclick ="window.open('https://www.youtube.com/watch?v=_tyd9VRLEEI', '_blank')"),
                                               br(), br(),
                            actionButton('howToVideo2', "How to: multiple products", icon = icon("play"),
                                               style = "color: white; background-color: #24226f", width = '100%',
                                               onclick ="window.open('https://www.youtube.com/watch?v=asFKi9jrr0U', '_blank')"),
                                               br(), br(),
                            actionButton('jumpToGuideHome', "User Guide", icon = icon("book-open"),
                                               style = "color: white; background-color: #24226f", width = '100%'),
                          ),
                          h3("Motivation"),
                          p(tags$a(href="https://onlinelibrary.wiley.com/doi/10.1111/nbu.12486","Our research"), "revealed", tags$a(href="https://onlinelibrary.wiley.com/doi/10.1111/nbu.12468","challenges", target="_blank"), 
                        "and a need for consistency and transparency in NPM calculation.",
                        "Our tool aims to bridge this gap: the tool and underlying code are provided under open-source licenses; the source code can be", tags$a(href="https://github.com/Leeds-CDRC/NPM-calculator","found here.", target="_blank"),),
                        h4("Future Development"),
                        p("We are currently monitoring the policy landscape with regard to the use of the 2004/5 UK NPM in future policy."),
                        p("In 2025, The Government confirmed its commitment to updating the Nutrient Profiling Model in its “Fit for the Future”,",tags$a(href="https://www.gov.uk/government/publications/10-year-health-plan-for-england-fit-for-the-future","10-year Health Plan for England.", target="_blank"),
                        "Once confirmation of the Department of Health and Social Care's chosen model is available we will review and respond."),

               ),
                          column(5,
                          wellPanel( style = "background-color:white; border: 2px solid #f06449;",
                h2("Who is it for?"),
               p("The NPM Online Calculator is a quick, easy and transparent way to generate a product's NPM score, and check if it may be captured by The Food (Promotion and Placement) (England) Regulations 2021 ('HFSS legislation') and The Advertising (Less Healthy Food Definitions and Exemptions) Regulations 2024, supporting consistency among:"),
               br(),
               tags$ul(p(tags$span(style ="color:black","✓   Retailers"))),
               tags$ul(p(tags$span(style ="color:black","✓   Manufacturers"))),
               tags$ul(p(tags$span(style ="color:black","✓   Policymakers"))),
               tags$ul(p(tags$span(style ="color:black","✓   Academics"))),
               tags$ul(p(tags$span(style ="color:black","✓   NGOs"))),
               br(),)),
               column(1)
               ),
                        # fluidRow(column(12, tags$h4(tags$span(style ="color:#24226f","Quickly calculate a product's UK Nutrient Profile Model (NPM) score"),sep ="",align = "center"))
                        #         ), #close fluid row
                        # fluidRow(column(12, tags$h4(tags$span(style ="color:#24226f","Supports decision-making and compliance with legislation"),sep ="",align = "center"))
                        #         ), #close fluid row
                        # fluidRow(column(12, tags$h4(tags$span(style ="color:#24226f","Easy to use at your desk or on the go"),sep ="", align = "center"))
                        #          ), #close fluid row
                        # fluidRow(column(12, tags$h4(tags$span(style ="color:#24226f","Transparent approach, promoting consistency and confidence in results"),sep ="", align = "center"))
                        #          ), #close fluid row
                        
                        # br(),
                        # hr(style = "border-top: 3px solid #f06449;"),
                        # h2("Ready to get started?"),
                        # p("Before you begin, please tell us how you'll be using the tool."),
                        # includeHTML("www/responses.html"),
                        # # selectInput("purpose", label =h3("Select purpose"),
                        # #             choices = list("Enforcement" = 1, "Check compliance" = 2, "Research" = 3,"Policy development"= 4, "Other"= 5),
                        # #             selected = 1),
                        # br(),
                        
                        # actionButton('jumpToCalc', "Start calculation for a single product", icon = icon("nutritionix"),
                        #              style = "color: white; background-color: #24226f", width = '50%'),
                        
                        # br(),
                        # br(),

                        # actionButton('jumpToBulk', "Asses several products at once", icon = icon("nutritionix"),
                        #              style = "color: white; background-color: #24226f", width = '50%'),
                        
                        # br(),
              #  h2("Who is it for?"),
              #  p("The NPM Online Calculator is a quick, easy and transparent way to generate a product's NPM score, and check if it may be captured by The Food (Promotion and Placement) (England) Regulations 2021 ('HFSS legislation'), supporting consistency among:"),
              #  tags$ul(p(tags$span(style ="color:#24226f","Retailers"))),
              #  tags$ul(p(tags$span(style ="color:#24226f","Manufacturers"))),
              #  tags$ul(p(tags$span(style ="color:#24226f","Policymakers"))),
              #  tags$ul(p(tags$span(style ="color:#24226f","Academics"))),
              #  tags$ul(p(tags$span(style ="color:#24226f","NGOs"))),
               
               
              #  fluidRow(column(12,actionButton('jumpToGuide', "Learn more in our User Guide",
              #                                  style = "color: white; background-color: #24226f", width = '100%'), align = "center")),
              #                                  br(),
               
               ),# close tabpanel  
              
               
               navbarMenu(strong("Calculator", style = "font-size:25px;"),
               # Single product assessment tab -----
               tabPanel("Single Product Calculator", value = "calculator", 
                                            
                                            wellPanel(style="background-color:#f7fbfb; border: 2px solid #f06449",
                                            tabsetPanel(type = "pills", shinyjs::useShinyjs(), id ="calc1",
                                                        # SPA calculator ----
                                                        tabPanel(title = tags$b("Enter data"), value = "calc",
                                                                 div(id="form",
                                                                 fluidRow(column(12,
                                                                                 h3("Single Product Calculator"),
                                                                                 p("Use this tool to calculate the Nutrient Profile Model score for a product. Watch our", strong(tags$a(href="https://www.youtube.com/watch?v=_tyd9VRLEEI","'How-To' video", target="_blank")), "for step-by-step guidance."))),
                                                                 # add reset button to clear form
                                                                 actionButton("reset_input", "Clear form"),
                                                                 h3("Step 1. Enter product information", style="color:#24226f"),
                                                                 fluidRow(column(4,textInput("in_prodname", NULL, label = "Name", placeholder = "Product name")),
                                                                          column(4,textInput("in_brand", NULL, label ="Brand", placeholder = "Brand name")),
                                                                          column(4, p("Check if your product is in scope for Promotion, Placement and Advertising Regulations 'HFSS legislation' (optional)"),
                                                                                 selectInput("Cat_dropdown", label = "Select product category",
                                                                                             choices = list("Soft drink" = 1, "Savoury snack" = 2, "Breakfast cereals" = 3,
                                                                                                            "Confectionary" = 4, "Ices" = 5, "Cakes" = 6, "Sweet biscuits and bars"=7,
                                                                                                            "Morning goods" = 8, "Desserts and puddings"= 9, "Yoghurts" = 10,
                                                                                                            "Pizza"= 11, "Potato products"=12, "Ready meals and meal centres"= 13,
                                                                                                            "Other"=14, selected =1)),
                                                                                 
                                                                                 
                                                                                 # add conditions for if soft drink selected 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown ==  '1'",
                                                                                   checkboxGroupInput("SoftDrink", label = "Does the drink contain any of the following? (select all that apply)",
                                                                                                      choices = list("Alcohol (>1.2% ABV)"=1, "No added sugar (check ingredients list)"=2,
                                                                                                                     "Infant milk formula" = 3, "Meal replacement powder"=4,
                                                                                                                     "Drink for medical purposes" = 5)
                                                                                   )
                                                                                 ),
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '1' && input.SoftDrink == ''",
                                                                                   p("Drink in scope for HFSS regulations", style = "color:red"
                                                                                   ),
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '1' && input.SoftDrink != ''",
                                                                                   p("Drink exempt from HFSS regulations", style = "color:green"),
                                                                                 ), 
                                                                                 
                                                                                 # add conditions for if savoury snack selected 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown ==  '2'",
                                                                                   checkboxGroupInput("Savourysnacks", label = "Is the snack any of the following? (select all that apply)",
                                                                                                      choices = list("Nuts or seeds"=1, "Fruit/dried fruit"=2,
                                                                                                                     "Meat jerky" = 3)
                                                                                   )
                                                                                 ),
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '2' && input.Savourysnacks == ''",
                                                                                   p("Snack in scope for HFSS regulations", style = "color:red"
                                                                                   ),
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '2' && input.Savourysnacks != ''",
                                                                                   p("Snack exempt from HFSS regulations", style = "color:green"),
                                                                                 ), 
                                                                                 
                                                                                 # add conditions for if cereals selected 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown ==  '3'",
                                                                                   p("No exemptions for cereals category. Product in scope for HFSS regulations",
                                                                                     style = "color:red"),
                                                                                 ),
                                                                                 
                                                                                 # add conditions for if confectionary selected 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown ==  '4'",
                                                                                   checkboxGroupInput("Confectionary", label = "Is the confectionary product any of the following? (select all that apply)",
                                                                                                      choices = list("Dried fruit"=1, "Sweet/savoury coated nuts (not including chocolate)"=2
                                                                                                      ))
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '4' && input.Confectionary == ''",
                                                                                   p("Confectionary in scope for HFSS regulations", style = "color:red"
                                                                                   ),
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '4' && input.Confectionary != ''",
                                                                                   p("Confectionary exempt from HFSS regulations", style = "color:green"),
                                                                                 ),
                                                                                 
                                                                                 # add conditions for if ices selected 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown ==  '5'",
                                                                                   checkboxGroupInput("Ices", label = "Is the ice cream product any of the following? (select all that apply)",
                                                                                                      choices = list("Alcohol >1.2% ABV"=1, "Toppings, sauces or sprinkles"=2
                                                                                                      ))
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '5' && input.Ices == ''",
                                                                                   p("Ice cream product in scope for HFSS regulations", style = "color:red"
                                                                                   ),
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '5' && input.Ices != ''",
                                                                                   p("Ice cream product exempt from HFSS regulations", style = "color:green"),
                                                                                 ),
                                                                                 
                                                                                 # add conditions for if cakes selected 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown ==  '6'",
                                                                                   checkboxGroupInput("Cakes", label = "Is the cake product any of the following? (select all that apply)",
                                                                                                      choices = list("Cake decorations e.g. sugar sprinkles"=1, "Icing"=2, "Sauces" = 3
                                                                                                      ))
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '6' && input.Cakes == ''",
                                                                                   p("Cake product in scope for HFSS regulations", style = "color:red"
                                                                                   ),
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '6' && input.Cakes != ''",
                                                                                   p("Cake product exempt from HFSS regulations", style = "color:green"),
                                                                                 ), 
                                                                                 
                                                                                 # add conditions for if biscuits selected 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown ==  '7'",
                                                                                   p("No exemptions for biscuits category. Product in scope for HFSS regulations",
                                                                                     style = "color:red"),
                                                                                 ),
                                                                                 
                                                                                 # add conditions for if morning goods selected 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown ==  '8'",
                                                                                   checkboxGroupInput("MorningGoods", label = "Is the morning goods product a savoury bread (except bagels, crumpets or English muffins)?",
                                                                                                      choices = list("Yes"=1, "No"=2
                                                                                                      ))
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '8' && input.MorningGoods == ''",
                                                                                   p("Morning goods product in scope for HFSS regulations", style = "color:red"
                                                                                   ),
                                                                                 ),
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '8' && input.MorningGoods == '1'",
                                                                                   p("Morning goods product exempt from HFSS regulations", style = "color:green"
                                                                                   ),
                                                                                 ),
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '8' && input.MorningGoods == 2",
                                                                                   p("Morning goods product in scope for HFSS regulations", style = "color:red"
                                                                                   ),
                                                                                 ),
                                                                                 
                                                                                 # add conditions for if desserts selected 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown ==  '9'",
                                                                                   checkboxGroupInput("Desserts", label = "Is the Dessert product any of the following? (select all that apply)",
                                                                                                      choices = list("Cream"=1, "Syrup"=2, "Condensed milk/caramel" = 3,
                                                                                                                     "Dessert topping/sauce" =4, "Plain meringue nests" = 5,
                                                                                                                     "Sponge fingers"=6, "Tinned/canned fruit"=7
                                                                                                      ))
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '9' && input.Desserts == ''",
                                                                                   p("Dessert product in scope for HFSS regulations", style = "color:red"
                                                                                   ),
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '9' && input.Desserts != ''",
                                                                                   p("Dessert product exempt from HFSS regulations", style = "color:green"),
                                                                                 ), 
                                                                                 
                                                                                 # add conditions for if yoghurt selected 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown ==  '10'",
                                                                                   checkboxGroupInput("Yoghurt", label = "Check the ingredients list. Does the yoghurt contain any of the following? (select all that apply)",
                                                                                                      choices = list("Added sugar"=1, "Artificial sweetener"=2, "Fruit" = 3
                                                                                                      ))
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '10' && input.Yoghurt == ''",
                                                                                   p("Yoghurt is unsweetened and exempt HFSS regulations", style = "color:green"
                                                                                   ),
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '10' && input.Yoghurt != ''",
                                                                                   p("Yoghurt is sweetened and in scope for HFSS regulations", style = "color:red"),
                                                                                 ),  
                                                                                 
                                                                                 # add conditions for if pizza selected 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown ==  '11'",
                                                                                   checkboxGroupInput("Pizza", label = "Is the product classed as any of the following? (select all that apply)",
                                                                                                      choices = list("Plain pizza base"=1, "Garlic bread/garlic bread with cheese"=2
                                                                                                      ))
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '11' && input.Pizza == ''",
                                                                                   p("Pizza in scope for HFSS regulations", style = "color:red"
                                                                                   ),
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '11' && input.Pizza != ''",
                                                                                   p("Pizza product exempt from HFSS regulations", style = "color:green"),
                                                                                 ), 
                                                                                 
                                                                                 # add conditions for if potato products selected selected 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown ==  '12'",
                                                                                   checkboxGroupInput("Potatoes", label = "Is the potato product any of the following? (select all that apply)",
                                                                                                      choices = list("Plain unprocessed potato"=1, "Sliced or mashed potato (with/without butter)"=2,
                                                                                                                     "Potato salad" = 3
                                                                                                      ))
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '12' && input.Potatoes == ''",
                                                                                   p("Potato product in scope for HFSS regulations", style = "color:red"
                                                                                   ),
                                                                                 ),
                                                                                 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown == '12' && input.Potatoes != ''",
                                                                                   p("Potato product exempt from HFSS regulations", style = "color:green"),
                                                                                 ), 
                                                                                 
                                                                                 # add conditions for if ready meals selected selected 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown ==  '13'",
                                                                                   checkboxGroupInput("Readymeals", label = "Is the ready meal product any of the following? (select all that apply)",
                                                                                                      choices = list("Dried pasta/noodles/rice"=1, "Side dishes/party food"=2,
                                                                                                                     "Self-assembly meal kits e.g. fajitas" = 3, "Savoury pastries/pies/quiches"=4,
                                                                                                                     "Breaded ham/charcuterie"=5, "Plain or marinaded fish/meat/poultry/alternative"=6,
                                                                                                                     "Sandwiches/sushi/ready to go salads"=7
                                                                                                      ))
                                                                                 ),
                                                                                 
                                                                                 # If sandwiches/sushi is selected (regardless of other selections)
                                                                                    conditionalPanel(
                                                                                      condition = "input.Cat_dropdown == '13' && input.Readymeals != null && input.Readymeals.indexOf('7') >= 0",
                                                                                      p("Sandwiches, of any kind, including baguettes, ciabattas, wraps, bagels, filled muffins, filled buns or baps, filled croissants, toasties or paninis are in scope for The Advertising Regulations, but are exempt from Promotion and Placement Regulations.", style = "color:orange"),
                                                                                    ),

                                                                                    # If nothing is selected
                                                                                    conditionalPanel(
                                                                                      condition = "input.Cat_dropdown == '13' && (input.Readymeals == null || input.Readymeals.length == 0)",
                                                                                      p("Ready meal in scope for HFSS regulations", style = "color:red"),
                                                                                    ),

                                                                                    # If other items are selected but NOT sandwiches/sushi
                                                                                    conditionalPanel(
                                                                                      condition = "input.Cat_dropdown == '13' && input.Readymeals != null && input.Readymeals.length > 0 && input.Readymeals.indexOf('7') < 0",
                                                                                      p("Ready meal exempt from HFSS regulations", style = "color:green"),
                                                                                    ),
                                                                                 
                                                                                 # add conditions for if other selected 
                                                                                 conditionalPanel(
                                                                                   condition = "input.Cat_dropdown ==  '14'",
                                                                                   p("Other food products are exempt from HFSS regulations",
                                                                                     style = "color:green"),
                                                                                 ),
                                                                                 bsPopover("Cat_dropdown", "Optional_HFSS", 
                                                                                           "HFSS legislation in England restricts product placement for products in some categories, if they fail the NPM. Check if your product may be in scope.", 
                                                                                           placement = "top", trigger = "hover", options = NULL),
                                                                                 ),
                                                                          
                                                                 ), # close fluidrow
                                                                 hr(style = "border-top: 3px solid #f06449;"),
                                                                 # SPA enter product details ----
                                                                fluidRow(
                                                                   column(4, radioButtons("Type_button", label = "Select product type", choices = list("Food" = FALSE, "Drink" = TRUE),
                                                                                                                    selected = FALSE),
                                                                          conditionalPanel(
                                                                           condition = "input.Type_button == 'TRUE'",
                                                                          checkboxGroupInput("Format", label = "Drink format (select one)",
                                                                                            choices = list("Ready to drink"=1, "Powdered drink"=2, "Cordial/squash"=3)) 
                                                                          ),),
                                                                   column(4, 
                                                                          conditionalPanel(
                                                                            condition = "input.Type_button == 'FALSE'",
                                                                            radioButtons("Unit_button", label = "Select weight/volume unit", choices =
                                                                            list("g" = FALSE, "ml" = TRUE), selected = FALSE)
                                                                     ),
                                                                          conditionalPanel(
                                                                            condition = "input.Type_button == 'TRUE' && input.Format == '1'",
                                                                            checkboxGroupInput("DrinkSG", label = "Select type of drink for appropriate specific gravity conversion",
                                                                                               choices =list("Milk" = 1, "Carbonated/juice drink" = 2,
                                                                                                             "Diet carbonated drink" = 3, "Energy drink" = 4,
                                                                                                             "Cordial/squash (ready to drink)" = 5))
                                                                          ),
                                                                     bsPopover("DrinkSG", "Specific Gravity", "1 ml of pure water weighs 1 g, but most drinks have a higher density. Select the drink type for a more accurate conversion of volume (in ml) to weight (in grams)",
                                                                               placement = "top", trigger = "hover", options = NULL),
                                                                          conditionalPanel(
                                                                            condition = "input.Type_button == 'FALSE' && input.Unit_button == 'TRUE'",
                                                                            checkboxGroupInput("FoodSG", label = "Select type of food for appropriate specific gravity conversion",
                                                                                               choices = list("Ice cream" = 1, "Ice lolly" = 2, "Mayonnaise" = 3,
                                                                                                              "Maple syrup" = 4, "Single cream" = 5, "Double cream" = 6,
                                                                                                              "Whipping cream" = 7, "Evaporated milk" = 8, 
                                                                                                              "Other" = 9))
                                                                          ),
                                                                     bsPopover("FoodSG", "Specific Gravity", "1 ml of pure water weighs 1 g, but most foods have a higher density. Select the food type for a more accurate conversion of volume (in ml) to weight (in grams)",
                                                                               placement = "top", trigger = "hover", options = NULL),
                                                                          conditionalPanel(
                                                                            condition = "input.Type_button =='TRUE' && input.Format == '2'",
                                                                            checkboxGroupInput("Pow_sold", label = "How is nutrition information presented?",
                                                                                               choices = list("As consumed (diluted)" = 1,
                                                                                                              "As sold (preparation instructions given)" = 2,
                                                                                                              "As sold (preparation instructions not given)" = 3)),
                                                                            bsPopover("Pow_sold", "Specific Gravity", "1 ml of pure water weighs 1 g. The density of cordial will be used to convert the volume (in ml) to weight (in grams).",
                                                                            placement = "top", trigger = "hover", options = NULL),                                                                        ),
                                                                          conditionalPanel(
                                                                            condition = "input.Type_button == 'TRUE' && input.Format == '3'",
                                                                            checkboxGroupInput("Cor_sold", label = "How is nutrition information presented?",
                                                                                               choices = list("As consumed (diluted)" = 1,
                                                                                                              "As sold (preparation instructions given)" = 2,
                                                                                                              "As sold (preparation instructions not given)" = 3)),
                                                                          )
                                                                          ),
                                                                   bsPopover("Cor_sold", "Specific Gravity", "1 ml of pure water weighs 1 g. The density of cordial will be used to convert the volume (in ml) to weight (in grams).",
                                                                             placement = "top", trigger = "hover", options = NULL),
                                                                   column(4, 
                                                                          conditionalPanel(
                                                                            condition = "input.Type_button == 'FALSE' && input.Unit_button == 'FALSE'",
                                                                            HTML("<b>Enter weight (g)</b> for which nutrient information is given. E.g. per 100g or per portion (enter portion size)"),
                                                                          numericInput("Food_wt", label = NULL, value = 100)
                                                                          ),
                                                                          conditionalPanel(
                                                                            condition = "input.Type_button == 'FALSE' && input.Unit_button == 'TRUE'",
                                                                            HTML("<b>Enter volume (ml)</b> for which nutrient information is given. E.g. per 100ml or per portion (enter portion size)"),
                                                                            numericInput("Food_vol", label = NULL, value = 100)
                                                                          ),
                                                                          conditionalPanel(
                                                                            condition = "input.Type_button == 'TRUE' && input.Format == '1'",
                                                                            HTML("<b>Enter volume (ml)</b> (as consumed) for which nutrient information is given. E.g. per 100ml or per portion (enter portion size)"),
                                                                            numericInput("Vol", label = NULL, value = 100)
                                                                          ),
                                                                          conditionalPanel(
                                                                            condition = "input.Type_button =='TRUE' && input.Format == '2'
                                                                            && input.Pow_sold == '1'",
                                                                            HTML("<b>Enter volume (ml)</b> (as consumed) for which nutrient information is given. E.g. per 100ml or per portion (enter portion size)"),
                                                                            numericInput("PowVol", label = NULL, value = 100)
                                                                          ),
                                                                          conditionalPanel(
                                                                            condition = "input.Type_button =='TRUE' && input.Format == '2'
                                                                            && input.Pow_sold == '2'",
                                                                            numericInput("Powder", label = "Weight of powder (g)", value = 0),
                                                                            numericInput("Liquid", label = "Volume of liquid (ml)", value = 0)
                                                                          ),
                                                                          conditionalPanel(
                                                                            condition = "input.Type_button =='TRUE' && input.Format == '2'
                                                                            && input.Pow_sold == '3'",
                                                                            numericInput("WtPow", label = "Weight of powder (g)", value = 0),
                                                                            p("WARNING: the NPM must be applied to drink products as consumed.",style = "color:red"),
                                                                            p("NPM score will still be calculated but should be interpreted with caution.",style = "color:red")
                                                                          ),
                                                                          conditionalPanel(
                                                                            condition = "input.Type_button == 'TRUE' && input.Format == '3'
                                                                            && input.Cor_sold == '1'",
                                                                            numericInput("CorVol", label = "Volume of cordial (ml)", value = 100),
                                                                          ),
                                                                          conditionalPanel(
                                                                            condition = "input.Type_button == 'TRUE' && input.Format == '3'
                                                                            && input.Cor_sold == '2'",
                                                                            numericInput("Cordial", label = "Volume of cordial (ml)", value = 0),
                                                                            numericInput("Water", label = "Volume of water (ml)", value = 0)
                                                                          ),
                                                                          conditionalPanel(
                                                                            condition = "input.Type_button == 'TRUE' && input.Format == '3'
                                                                            && input.Cor_sold == '3'",
                                                                            numericInput("VolCor", label = "Volume of cordial (ml)", value = 0),
                                                                            p("WARNING: the NPM must be applied to drink products as consumed.",style = "color:red"),
                                                                            p("NPM score will still be calculated but should be interpreted with caution.",style = "color:red")
                                                                          ),
                                                                          htmlOutput("Gequiv"),
                                                                          
                                                                          ),
                                                                   
                                                                   
                                                                 ), # close fluid row
                                                        
                                                        hr(style = "border-top: 3px solid #f06449;"),
                                                        
                                                        # SPA A-points ----
                                                        h3("Step 2. Enter nutrient values to calculate A-points", style="color:#24226f"),
                                                        tags$i("(A-points are the 'less healthy' components that the NPM aims to discourage)"),
                                                        br(),
                                                        htmlOutput("Entervol"),
                                                        br(),
                                                        fluidRow(
                                                          column(4, numericInput("in_E", label = "Energy", value = 0)),
                                                          column(4, p("Select unit"),
                                                                 radioButtons("Energy_button", label = NULL, choices = list("KJ"= FALSE, "kcal" = TRUE),
                                                                              selected = FALSE)),
                                                          column(4, p("Energy points"),
                                                                 verbatimTextOutput("Energy_points"))
                                                          
                                                        ), # close fluid row
                                                        
                                                        fluidRow(
                                                          column(4, numericInput("in_sugar", label = "Total sugar (g)", value = 0)),
                                                          column(4, p("")),
                                                          column(4, p("Sugar points"),
                                                                 verbatimTextOutput("Sugar_points"))
                                                        ), # close fluid row
                                                        
                                                        fluidRow(
                                                          column(4, numericInput("in_satfat", label = "Saturated fat (g)", value = 0)),
                                                          column(4, p("")),
                                                          column(4, p("Saturated fat points"),
                                                                 verbatimTextOutput("Satfat_points"))
                                                          
                                                        ), # close fluid row
                                                        
                                                        fluidRow(
                                                          column(4,numericInput("in_NA", label = "Sodium/salt", value = 0)),
                                                          column(4, p("Select unit"),
                                                                 radioButtons("salt_button", label = NULL, choices = list("Sodium mg" = FALSE, "Salt g"=TRUE),
                                                                              selected = FALSE)),
                                                          column(4, p("Sodium points"),
                                                                 verbatimTextOutput("Sodium_points"))
                                                          
                                                        ), # close fluid row
                                                        hr(style = "border-top: 3px solid #f06449;"),
                                                        
                                                        # SPA C-points ----
                                                        h3("Step 3. Enter nutrient values to calculate C-points", style="color:#24226f"),
                                                        tags$i("(C-points are the 'healthier' components that the NPM aims to encourage)"),
                                                        br(),
                                                        fluidRow(
                                                          column(4,numericInput("in_fib", label = "Fibre (g)", value = 0)),
                                                          column(4, p("Select  unit"),
                                                                 radioButtons("fibre_button",label = NULL, choices = list("NSP" = FALSE, "AOAC" = TRUE),
                                                                              selected = TRUE)),
                                                          bsPopover("fibre_button", "Fibre type", "NSP = Non starch polysaccharides, AOAC includes non-digestible. If unknown, assume AOAC."),
                                                          column(4, p("Fibre points"),
                                                                 verbatimTextOutput("Fib_points"))
                                                        ), #close fluid row
                                                        
                                                        fluidRow(  
                                                          column(4,numericInput("in_protein", label = "Protein (g)", value = 0)),
                                                          column(4, p("")),
                                                          column(4, p("Protein points"),
                                                                 verbatimTextOutput("protein_points"))
                                                          
                                                        ), # close fluid row
                                                        
                                                        fluidRow(
                                                          column(4,numericInput("in_FVNper", label = "Fruit, veg and nuts (% of total product weight)", value = 0)),
                                                          column(4, p("")),
                                                          column(4, p("FVN points"),
                                                                 verbatimTextOutput("FVN_points"),
                                                          bsPopover("in_FVNper", "Estimating fruit, veg and nuts %", 
                                                                    "Check ingredients list for %. If no fruit, veg and nuts stated, assume content is zero.", 
                                                                    placement = "top", trigger = "hover", options = NULL)),
                                                        ), # close fluid row
                                                        actionButton('jumpToResult', "Step 4. Calculate NPM score", icon = icon("nutritionix"),
                                                                     style = "color: white; background-color: #24226f", width = '100%'),
                                                        br(),
                                                        ), #close div
                                            ), # close tabpanel
                                            
                                      # open new tabpanel for Results 
                                      # SPA results ----
                                      tabPanel(title = tags$b("View results"), value = "result", 
                                               h3("Results"),
              
                                               wellPanel(style="background-color: white; border: 2px solid #f06449",
                                               htmlOutput("result"),
                                               plotOutput("resultplot", height = 200),
                                               # create conditional panels to display summary text dependent on type of food and score
                                               ),
                                               conditionalPanel(
                                                 condition = "input.Type_button =='FALSE' && output.result =='PASS'",
                                                 p("Food passes the Nutrient Profile Model and is not subject to promotion restrictions",
                                                   style = "color:green")
                                               ),
                                               
                                               conditionalPanel(
                                                 condition = "input.Type_button =='FALSE' && output.result =='FAIL'",
                                                 p("Food fails the Nutrient Profile Model and may be subject to promotion restrictions (check legislation category guidance)",
                                                   style = "color:red")
                                               ), 
                                               
                                               conditionalPanel(
                                                 condition = "input.Type_button =='TRUE' && output.result =='PASS'",
                                                 p("Drink passes the Nutrient Profile Model and is not subject to promotion restrictions",
                                                   style = "color:green")
                                               ),
                                               
                                               conditionalPanel(
                                                 condition = "input.Type_button =='TRUE' && output.result =='FAIL'",
                                                 p("Drink fails the Nutrient Profile Model and may be subject to promotion restrictions (check legislation category guidance)",
                                                   style = "color:red")
                                               ),
                                               h4("Summary"),
                                               
                                               fluidRow(column(4, p("Product name"), htmlOutput("prodname")),
                                                        column(4, p("Brand"), htmlOutput("prodbrand"))
                                               ), #close fluidrow
                                               
                                               
                                               # create conditional panels to display guidance on whether category is likely to be in scope
                                               conditionalPanel(
                                                 condition = "input.Type_button =='TRUE' && input.Cat_dropdown =='1'&& input.SoftDrink == '' ", # drink, soft drink
                                                 HTML("<span style=\"color:red\">You've indicated that the drink is likely to be in scope for HFSS legislation.",
                                                      '<br/>', "Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                   )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='TRUE' && input.Cat_dropdown =='1'&& input.SoftDrink !='' ", # drink, soft drink
                                                HTML("<span style=\"color:green\">You've indicated that the drink is likely to be out of scope for HFSS legislation.",
                                                     '<br/>', "Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='2'&& input.Savourysnacks =='' ", # food, savoury snack
                                                HTML("<span style=\"color:red\">You've indicated that the snack is likely to be in scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                              )),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='2'&& input.Savourysnacks !='' ", # food, savoury snack
                                                HTML("<span style=\"color:green\">You've indicated that the snack is likely to be out of scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                )),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='3'", # food, breakfast cereal
                                                HTML("<span style=\"color:red\">You've indicated that the product is a breakfast cereal, which are in scope for HFSS legislation, there are no exemptions.", 
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                  )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='4'&& input.Confectionary =='' ", # food, confectionary
                                                HTML("<span style=\"color:red\">You've indicated that the confectionary product is likely to be in scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                  )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='4'&& input.Confectionary !='' ", # food, confectionary
                                                HTML("<span style=\"color:green\">You've indicated that the confectionary product is likely to be out of scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='5'&& input.Ices =='' ", # food, ices
                                                HTML("<span style=\"color:red\">You've indicated that the ice cream/lolly is likely to be in scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                  )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='5'&& input.Ices !='' ", # food, ices
                                                HTML("<span style=\"color:green\">You've indicated that the ice cream/lolly is likely to be out of scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='6'&& input.Cakes =='' ", # food, cakes
                                                HTML("<span style=\"color:red\">You've indicated that the cake is likely to be in scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                  )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='6'&& input.Cakes !='' ", # food, cakes
                                                HTML("<span style=\"color:green\">You've indicated that the cake is likely to be out of scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='7'", # food, sweet biscuits and bars
                                                HTML("<span style=\"color:red\">You've indicated that the product is a sweet biscuit/bar, which are in scope for HFSS legislation, there are no exemptions.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                  )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='8'&& input.MorningGoods =='' ", # food, morning goods
                                                HTML("<span style=\"color:red\">You've indicated that the morning goods product is likely to be in scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                  )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='8'&& input.MorningGoods !='' ", # food, morning goods
                                                HTML("<span style=\"color:green\">You've indicated that the morning goods product is likely to be out of scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='9'&& input.Desserts =='' ", # food, desserts/puddings
                                                HTML("<span style=\"color:red\">You've indicated that the dessert/pudding is likely to be in scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                  )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='9'&& input.Desserts !='' ", # food, desserts/puddings
                                                HTML("<span style=\"color:green\">You've indicated that the dessert/pudding is likely to be out of scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                )
                                              ),
                                              
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='10'&& input.Yoghurt =='' ", # food, yoghurt
                                                HTML("<span style=\"color:red\">You've indicated that the yoghurt is likely to be in scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                  )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='10'&& input.Yoghurt !='' ", # food, yoghurt
                                                HTML("<span style=\"color:green\">You've indicated that the yoghurt is likely to be out of scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='11'&& input.Pizza =='' ", # food, pizza
                                                HTML("<span style=\"color:red\">You've indicated that the pizza is likely to be in scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                  )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='11'&& input.Pizza !='' ", # food, pizza
                                                HTML("<span style=\"color:green\">You've indicated that the pizza is likely to be out of scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='12'&& input.Potatoes == '' ", # food, potato products
                                                HTML("<span style=\"color:red\">You've indicated that the potato product is likely to be in scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                  )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='12'&& input.Potatoes != '' ", # food, potato products
                                                HTML("<span style=\"color:green\">You've indicated that the potato product is likely to be out of scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                )
                                              ),
                                              
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='13' && input.Readymeals =='' ", # food, ready meal/meal centre
                                                HTML("<span style=\"color:red\">You've indicated that the ready meal/meal centre is likely to be in scope for HFSS legislation. Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                  )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='13' && input.Readymeals !='' ", # food, ready meal/meal centre
                                                HTML("<span style=\"color:green\">You've indicated that the ready meal/meal centre is likely to be out of scope for HFSS legislation. Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                )
                                              ),
                                              
                                              conditionalPanel(
                                                condition = "input.Type_button =='FALSE' && input.Cat_dropdown =='14'", # food, other food
                                                HTML("<span style=\"color:red\">You've indicated that the product is not in one of the specified categories and is likely to be out of scope for HFSS legislation.",
                                                     '<br/>',"Refer to NPM score and read the legislative guidance on product categories to check compliance.",
                                                  )
                                              ),
                                              br(),
                                              
                                               fluidRow(column(4, p("Total A-points"), htmlOutput("TOTALA")),
                                                        column(4, p("Total C-points"), htmlOutput("TOTALC")),
                                                        column(4, p("Total NPM score"), htmlOutput("Total"))
                                                        ), # close fluidrow
                                               
                                               br(),
                                               p("Please note that multiple adjustments are made to the A and C point scores before the 'A-points - C-points' score calculation.",
                                               class= "alert alert-warning"),
                                               
                                              fluidRow(column(12, actionButton('jumpBack', "Assess again", icon = icon("nutritionix"),
                                                                              style = "color: white; background-color: #24226f", width = '50%'),
                                                                              br(),
                                                                              br(),
                                                                  actionButton('jumpToBulkFromSingle', "Asses several products at once", icon = icon("nutritionix"),
                                                                              style = "color: white; background-color: #24226f", width = '50%'), align="center"),
                                                       ),
                                              
                                               br(),
                                      ), # close tabpanel
                                      
                                            ), # close tabset panel
                                            ), #close wellPanel
                                      
               ), # close tabset panel
               
               bulkTab,),
                           
               # User guide page -----
               tabPanel(p("User guide", style = "font-size:25px;"), value = "Guide",
                        h1("User guide"),
                        p(tags$a(href="https://onlinelibrary.wiley.com/doi/10.1111/nbu.12486","Our research", target="_blank"), "revealed", tags$a(href="https://onlinelibrary.wiley.com/doi/10.1111/nbu.12468","challenges", target="_blank"), 
                        "and a need for consistency and transparency in NPM calculation."),
                        p("The NPM Calculator makes NPM score assessment easy, promoting consistency and transparency."),
                        p("Watch our", strong(tags$a(href="https://www.youtube.com/watch?v=d6zzbmPE-iI","introductory video", target="_blank")), "for step-by-step guidance."),
                        br(),
                        wellPanel(style="background-color:#f7fbfb; border: 2px solid #f06449",
                        tabsetPanel(type = "pills",
                                    tabPanel(title = tags$b("Completing an assessment"),
                                             br(),
                                             fluidRow(
                                              column(1),
                                              column(5,
                                             p(tags$b("The NPM calculator tells you:")),
                                             tags$ul(tags$span(style ="color:black","✓   The NPM score based on the 2004/5 NPM model")),
                                             tags$ul(tags$span(style ="color:black","✓   If the product is likely to be in scope for",tags$a(href="https://www.legislation.gov.uk/uksi/2021/1368/contents/made","The Food (Promotion and Placement) (England) Regulations 2021", style="font-weight:bold", target="_blank")," and The Advertising (Less Healthy Food Definitions and Exemptions) Regulations 2024 which we dub 'HFSS legislation'")),
                                             br(),
                                             p(tags$b("To calculate the NPM score, all you need is:")),
                                             tags$ul(tags$span(style ="color:black","✓   Product nutrition information")),
                                             tags$ul(tags$span(style ="color:black","✓   Ingredients list")),
                                             tags$ul(tags$span(style ="color:black","✓   Our handy calculator")),
                                             br(),
                                             p(tags$b("To assess if a product is in scope for HFSS legislation:")),
                                             tags$ul(tags$span(style ="color:black","✓   You'll need to provide information about the product category")),),
                                             column(5,
                                             wellPanel(style = "padding-left: 50px !important;",
                                              br(),
                                             p(tags$b("Additional information:")),
                                             tags$li("The nutrient panel and ingredients list can be found on the back of packaged products."),
                                             tags$li("If your product isn't packaged, you can refer to the product specification or online information if these are available."),
                                             tags$li("You'll need to know the weight for which nutrient information is given. That's because NPM scores are allocated per 100g of product. "),
                                             tags$li("No need to do any conversions. Just enter the weight and nutrient data - the tool will do the rest."),
                                             tags$li("You can identify the product category based on its name, format and ingredients list."),),
                                             br(),)),
                                             fluidRow(
                                              column(1),
                                              column(10,
                                              hr(style = "border-top: 3px solid #f06449;"),
                                             p(tags$b("Disclaimer:")),
                                             p("The Nutrient Profile Model Calculator was developed by researchers at the University of Leeds, to make NPM score calculation quicker, easier and more consistent."),
                                             p("It is the user's responsibility to check compliance to current legislation by following the", tags$a(href="https://www.gov.uk/government/publications/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price-implementation-guidance", "latest guidance.", target="_blank"),""),
                                             p("The University of Leeds does not accept any responsibility for incorrect promotion of products under current legislation"),
                                    ))),
                                    
                                    tabPanel(title = tags$b("Multiple Product Calculator Guide"),
                                             br(),
                                             fluidRow(
                                              column(1),
                                              column(5,
                                              wellPanel( style = "background-color:white; border: 2px solid #f06449;",
                                             p("The Multiple Product Calculator mode enables you to upload information for multiple products and run the entire table through the Nutrient Profile Model.",
                                             "Please see details on the parameters required at the bottom of this page.",
                                              br(),
                                              br(),
                                              strong("How to use the Multiple Product Calculator mode:")),
                                              tags$ol(
                                                tags$li("Download the template Excel or CSV file."),
                                                tags$li("Prepare your data (according to the Input Parameters below), ensuring you are using the correct column names and categories (the template Excel file contains drop down options for categorical variables)."),
                                                tags$li("Select the ‘Go to Multiple Product Calculator’ button to go to the calculator page, and then click the ‘upload data’ tab."),
                                                tags$li("Upload your Excel or CSV file – once uploaded you can preview to check the data looks correct."),
                                                tags$li("Click ‘Calculate NPM scores’."),
                                                tags$li("The calculator will provide a summary and small preview of the results. Any errors will be flagged at this stage."),
                                                tags$li("Download your full results (CSV file)."),
                                              ),),),
                                              column(5,
                                              p("The template Excel file below contains drop down options for categorical variables to assist you in correctly filling in your dataset.",
                                            class= "alert alert-success"), br(),
                                              actionButton('downloadExcelGuide', "Download template Excel file", icon = icon("download"),
                                                  style = "color: white; background-color: #24226f;", width = '100%',
                                                  onclick ="window.open('NPM calculator template.xlsx', '_blank')"),
                                              br(), br(),
                                              actionButton('downloadCSVGuide', "Download template CSV file", icon = icon("download"),
                                                  style = "color: white; background-color: #24226f;", width = '100%',
                                                  onclick ="window.open('NPM calculator template.csv', '_blank')"),
                                                  br(), br(),
                                              p("If you are ready to assess products using the Multiple Product Calculator mode,
                                              click the button below. Don't forget to refer to the Input Parameters guidance table
                                              at the bottom of this page." ), # to add: If you want more information on using the tool, see the video below."
                                            br(),
                                             actionButton('jumpToBulkFromGuide', "Go to Multiple Product Calculator", icon = icon("nutritionix"),
                                                        style = "color: white; background-color: #24226f", width = '100%'),
                                              br(),
                                              # br(),
                                              # h4("Help using the tool"),
                                              # p("Link will go here to guide video."),
                                              br(),),
                                              column(1),
                                             ), # close fluidRow
                                            #  p("At present the Table Calculator is experimental and not guaranteed
                                            # to work against all data. Please use the available template spreadsheet files
                                            # to populate your data against and run with the Table Calculator. This ensures
                                            # the data contains correct column names and categories for steps used by the 
                                            # Table Calculator.",
                                            # class= "alert alert-warning"),
                                            # p("The Table Calculator uses the nutrientprofiler R package to calculate
                                            # NPM scores. Find out more about this package here:",a("nutrient profiler documentation",
                                            # href="https://leeds-cdrc.github.io/nutrientprofiler/", style = "color:white;font-weight: bold;", target="_blank")," . This tool currently uses",a("nutrientprofiler version 2.0.0.",
                                            # href="https://github.com/Leeds-CDRC/nutrientprofiler/releases/tag/v1.0.0", style = "color:white;font-weight: bold;", target="_blank"),"Please note this alongside your analysis. ",class= "alert alert-success"),
                                            # p("To help with larger datasets of product information
                                            # you want testing against the Nutrient Profile Model we 
                                            # have introduced a new, experimental Table Calculator mode.
                                            # This mode offers the ability to upload a dataset of product
                                            # information and run the entire table through the Nutrient Profile
                                            # Model. It visualises these results and makes it possible to 
                                            # download a copy of your data with the additional columns
                                            # corresponding to the Nutrient Profile Model assessment."),
                                            # p("The Table Calculator allows you to upload your data file 
                                            # which should be either CSV or Excel format. Once uploaded
                                            # your data will be previewed within the same tab where you can 
                                            # visually check that the data looks correct. When ready click Calculate
                                            # NPM scores to run the Table Calculator against your data. If an error
                                            # occurs during this step a popup will appear that includes some error
                                            # information. If it is unclear how to fix your error please raise an
                                            # issue on ",a(href="https://github.com/Leeds-CDRC/NPM-Calculator/issues/new",
                                            # "GitHub (sign in required) ")," sharing your error information or email the CDRC via ",
                                            # a(href="mailto:info@cdrc.ac.uk", "info@cdrc.ac.uk"),
                                            # " including all error information."),
                                            # p("If this step proceeds without error you will move to the Results
                                            # tab, where you will be able to view a summary of your results and a 
                                            # small preview table of your data showing the result of the NPM 
                                            # calculation. You will also be able to download your dataset as a CSV file
                                            # with additional columns generated during the assessment step."),
                                            # hr(style = "border-top: 3px solid #f06449;"),
                                            # p("If you are ready to assess products using the Table Calculator mode,
                                            # click the button below. If you want more information on the data file required,
                                            # see the Input Parameters table below, or download the template data files
                                            # at the bottom of the page."),
                                            # br(),
                                            #  actionButton('jumpToBulk', "Asses several products at once", icon = icon("nutritionix"),
                                            #             style = "color: white; background-color: #24226f", width = '50%'),
                                             br(),
                                             wellPanel( style = "background-color:white; border: 2px solid #f06449;",
                                             h3("Input Parameters"),
                                             DTOutput('BulkGuideTable'),),
                              
                                                br(),
                                             p("Visit",tags$a(href="https://www.gov.uk/government/publications/the-nutrient-profiling-model","the NPM guidance", target="_blank"),"for full details."),
                                             ),

                                    tabPanel(title = tags$b("About the NPM"),
                                             br(),
                                             fluidRow(
                                              column(1),
                                              column(10,
                                             h2("What is the NPM?"),
                                             p(tags$a(href="https://www.gov.uk/government/publications/the-nutrient-profiling-model","The UK Nutrient Profile Model", target="_blank"), "was developed by the Food Standards Agency in 2004-2005 to assess the 'healthiness' of products by assigning a score based on nutritional information."),
                                             p("The NPM score underpins:"),
                                             tags$ul(tags$span(style ="color:black","Product advertising (on TV, online, on the Transport For London network and more)")),
                                             tags$ul(tags$span(style ="color:black","Product promotions in stores and online shopping platforms")),
                                             hr(style = "border-top: 3px solid #f06449;"),
                                             h3("How is the NPM score calculated?"),
                                             p("Points are assigned to components, according to their amounts per 100g of product.
                                             Points are grouped into", em("A-points"), "and", em("C-points.")),
                                             wellPanel( style = "background-color:white; border: 2px solid #f06449;",
                                             h4("A-points"),
                                             p("These are the 'less healthy' components which the model discourages"),
                                             DTOutput('APointsTable'),),
                                            #  (img(src="A-points_thresholds.png", height =250)
                                            #  ),
                                             br(),
                                             wellPanel( style = "background-color:white; border: 2px solid #f06449;",
                                             h4("C-points"),
                                             p("These are the 'healthier' components which the model encourages."),
                                             DTOutput('CPointsTable'),),
                                            #  (img(src="C-points_thresholds.png", height =150)
                                            #  ),
                                             br(),
                                            
                                             h4("Scoring"),
                                             p("The scores for C-points are then deducted from the scores for A-points, to give the overall score."),
                                             p("If a product scores 11 or more for A-points then it cannot score points for protein, unless it also scores 5 points for fruit, vegetables and nuts."),
                                             p("For drinks, if a product scores 1 or higher, the product is classed as 'less healthy' and is said to FAIL the NPM."),
                                             p("For foods, if a product scores 4 or higher, the product is classed as 'less healthy' and is said to FAIL the NPM."),
                                             p("Products which fail the NPM may be subject to certain restrictions on advertising and promotions, depending on the type of product and the specifics of the legislation."),
                                             hr(style = "border-top: 3px solid #f06449;"),
                                             p("Visit",tags$a(href="https://www.gov.uk/government/publications/the-nutrient-profiling-model","the NPM guidance", target="_blank"),"for full details."),
                                    ),
                                    column(1),),),
                                    
                                    
                                    tabPanel(title = tags$b("About HFSS legislation"), 
                                             br(),
                                             fluidRow(
                                              column(1),
                                              column(10,
                                             h3("What is HFSS legislation?"),
                                             p("HFSS stands for 'High in Fat, Sugar or Salt'.", "This tool is designed to support implementation and enforcement of ",tags$a(href="https://www.legislation.gov.uk/uksi/2021/1368/contents/made","The Food (Promotion and Placement) (England) Regulations 2021", target="_blank"),"and The Advertising (Less Healthy Food Definitions and Exemptions) Regulations 2024, which we dub 'HFSS legislation'.",
                                             "Since October 2022, the placement of HFSS products in stores and online is restricted, removing them from prime locations like store entrances, the ends of aisles, and at the checkouts. From October 2025, volume price promotions (e.g. “buy one get one free”, and “50% extra free”) are banned for HFSS products. From January 2026, advertising restrictions will be introduced, placing a 9pm watershed on television advertising and a ban on paid for advertising online, for HFSS products.",
                                             "Guidance for the ",
                                             tags$a(href="https://www.gov.uk/government/publications/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price-implementation-guidance", "Promotion and Placement", target="_blank"),
                                             "legislation, and ",
                                             tags$a(href="https://www.gov.uk/government/publications/restricting-advertising-of-less-healthy-food-or-drink-on-tv-and-online-products-in-scope/restricting-advertising-of-less-healthy-food-or-drink-on-tv-and-online-products-in-scope#food-or-drink-products-in-scope","Advertising Regulations", target="_blank"),
                                             " is available online."),
                                             br(),
                                             p("Under",tags$a(href="https://www.gov.uk/government/publications/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price-implementation-guidance","the guidance", target="_blank"),", a product is considered HFSS if it",
                                             "falls into one of the 13 categories listed in the table below, and if it fails the UK NPM.",
                                             "The NPM Calculator will let you know the HFSS status of foods you enter.",
                                             "Please note, there is a slight difference in in-scope products in category 13 between the Promotion and Placement Regulations, and The Advertising Regulations, as outlined in the table below."),
                                             p("Please note that restrictions on promotions only apply to packaged products sold in eligible retailers.",
                                             "This tool is not designed to assess retailer eligibility."),
                                             p("Make sure you're up to date with",tags$a(href="https://www.gov.uk/government/publications/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price-implementation-guidance","the rules", target="_blank"),"."),
                                             hr(style = "border-top: 3px solid #f06449;"),
                                             wellPanel( style="background-color:white; border: 1px solid #f06449;",
                                             h4("HFSS categories in The Food (Promotion and Placement) (England) Regulations 2021 and The Advertising (Less Healthy Food Definitions and Exemptions) Regulations 2024"),
                                             tableOutput('CategoryTable'),)),
                                             column(1),
                                             )),
                                    tabPanel(title = tags$b("NPM Calculator assumptions"),
                                    fluidRow(
                                      column(1),
                                      column(10,
                                             h3("Specific gravity"),
                                             p("Nutrient values for drinks, and some foods, are typically presented per 100ml of product. But the NPM applies per 100g of product."),
                                             p("A specific gravity conversion factor can be applied to convert the volume in ml to weight in grams. This accounts for the density of the product."),
                                             p("While pure water has a specific gravity of 1, meaning that 1ml or pure water weighs 1g, most drinks will have a higher density."),
                                             p("For ease for the user, this calculator uses pre-set specific gravity conversion factors, which will be applied according to the type of product you select."),
                                             p("Specific gravity values are listed in the table below. Selecting the correct product type will ensure the most appropriate specific gravity value is used."),
                                             br(),
                                             fluidRow(
                                              column(3),
                                              column(6,
                                             wellPanel( style = "background-color:white; border: 2px solid #f06449;",
                                             h4("Specific gravity values"),
                                             tableOutput('SGTable'),),),
                                             column(3)),
                                             p("Specific gravity values are taken from", tags$a(href="https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/694145/Annex__A_the_2018_review_of_the_UK_nutrient_profiling_model.pdf","The 2018 review of the UK Nutrient Profiling Model Appendix A"),", pages 95-96. For products not listed, a specific gravity of 1 is applied"),
                                             h3("Fruit, Veg and Nuts"),
                                             p("The NPM calculator isn’t currently designed to assist with the calculation of the percentage of fruits, vegetables and nuts. It is only designed to take a user-inputted percentage value, which assumes that the user has already consulted the", tags$a(href="https://assets.publishing.service.gov.uk/media/5a7cdac7e5274a2c9a484867/dh_123492.pdf","NPM technical guidance", target="_blank"), "and calculated the fruit, vegetable and nut percentage correctly. Fruit, vegetable and nut percentages should be calculated as a proportion of the total product by weight."),
                                    ), column(1))),
                                    ),# close tabsetpanel
                        ),
                       
                        ),# close tabpanel           
              
               
               # Acknowledgements page -----                     
               tabPanel(p("About", style = "font-size:25px;"),
                fluidRow(
                column(1),
                column(10,
                wellPanel(
                  p("The Nutrient Profile Model online calculator tool is provided by the Healthy and Sustainable Places Data Service (ES/Z504336/1), originally produced by the Consumer Data Research Centre (ES/LO11840/1; ES/LO11891/1).",
                  "Should you experience any difficulties using the NPM Calculator, please contact ", a(href="mailto:hasp@leeds.ac.uk", "hasp@leeds.ac.uk", style = "font-weight: bold;color:black", .noWS = "outside"),
                  ". If you encountered an error, please include a screenshot of the error message and the dataset that prompted the error (if possible).",
                  "Please also contact us with any questions or suggestions for improvement to the webapp.", .noWS = c("after-begin", "before-end"))
                ), ),column(1),),
                        # p("The Nutrient Profile Model online calculator tool was developed by the Consumer Data Research Centre, University of Leeds."),
                        # h4("Cite the Nutrient Profile Model Calculator"),
                        # p("Project team, Dr Vicki Jenneson , Rosalind Martin (Data Scientist Intern at the Leeds Institute for Data Analytics (LIDA)), and Dr Michelle Morris"),
                        # br(),
                        # p("The NPM Calculator is based on the MSc work of Vicki Jenneson. The original code for that project
                        # can be found", a(href="https://github.com/VickiJenneson/NPM_Promotional_Restrictions", "on GitHub"), ", and  
                        # was previously tested on a retail product dataset from Dietary
                        # Assessment Ltd."),
                        # p("Current code for the NPM Calculator can be found on the", a(href="https://github.com/Leeds-CDRC/NPM-Calculator","CDRC GitHub")," page"),
                        # br(),
                        # p("An overview of the calculator's development is available in our blog,", 
                        # a(href="https://lida.leeds.ac.uk/news/automating-a-nutrient-profiling-model/", "Automating a Nutrient Profiling
                        # Model"), ".")
                        
                fluidRow(
                  column(1),
                  column(5,
                  wellPanel(style = "background-color:white; border: 2px solid #f06449;",
                  h3("Used our tool? Cite us"),
                  p('If you have used our tool and are presenting the results, please cite us as shown below.'),
                  p('Jenneson, V., Martin, R., Morris, M., Baudains, P., Coleman, A., Foley, Z., & Murphy Quinlan, M. (2025). "NPM Calculator (Version 2.0)",', a(href='https://npmcalculator.hasp.ac.uk/', 'https://npmcalculator.hasp.ac.uk/', .noWS = 'outside'),'. Data asset provided by the Healthy & Sustainable Places Data Service (ES/Z504336/1), originally produced by the CDRC (ES/L011840/1;ES/L011891/1).', a(href='https://doi.org/10.5281/zenodo.7100435', 'https://doi.org/10.5281/zenodo.7100435', target='_blank'), .noWS = c("after-begin", "before-end"), style = "font-size: 1.6rem;color: #24226f;"),
                  HTML('<a href="https://doi.org/10.5281/zenodo.7100435"><img src="https://zenodo.org/badge/525283616.svg" alt="DOI"></a>')
                  ),
                  br(),
                  p("If you haven't already, please let us know how and why you are using our tool. This helps us plan future development:"),
                                        actionButton('infoForm1Guide', "Open poll in new tab", icon = icon("square-poll-vertical"),
                                               style = "color: white; background-color: #24226f", width = '100%',
                                               onclick ="window.open('https://forms.office.com/e/MDEGQVeR6r', '_blank')"),),
                  column(5,
                  h3("Development"),
                  p("The NPM Calculator is based on the MSc work of Vicki Jenneson. The original code for that project
                        can be found ", a(href="https://github.com/VickiJenneson/NPM_Promotional_Restrictions", "on GitHub", target="_blank", .noWS = "outside"), ", and  
                        was previously tested on a retail product dataset from Dietary
                        Assessment Ltd.", .noWS = c("after-begin", "before-end")),
                        p("Current code for the NPM Calculator can be found in our ", a(href="https://github.com/Leeds-CDRC/NPM-Calculator","GitHub repository", target="_blank", .noWS = "outside"),".", .noWS = c("after-begin", "before-end")),
                        p("Under the hood, the Multiple Product Calculator uses the nutrientprofiler R package to calculate
                        NPM scores. Find out more about this package here: ", a("nutrient profiler documentation",
                        href="https://leeds-cdrc.github.io/nutrientprofiler/", style = "font-weight: bold;", target="_blank", .noWS = "outside"),". This tool currently uses",a("nutrientprofiler version 2.0.0.",
                        href="https://github.com/Leeds-CDRC/nutrientprofiler/releases/tag/v2.0.0", style = "font-weight: bold;", target="_blank"),"Please note this alongside your analysis. ", .noWS = c("after-begin", "before-end")
                        ),
                        p(tags$b("Disclaimer:")),
                                             p("It is the user's responsibility to check compliance to current legislation by following the", tags$a(href="https://www.gov.uk/government/publications/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price-implementation-guidance", "latest guidance.", target="_blank"),""),
                                             p("The University of Leeds does not accept any responsibility for incorrect promotion of products under current legislation"),
                      
                  ), column(1),
                ),

                fluidRow(
                  column(1),
                  column(10,
                  hr(style = "border-top: 2px solid #f06449;"),
                  wellPanel(style="background-color:white; box-shadow: None",
                  h3("Related Publications"),
                  tags$ul(
                    tags$li("Jenneson, V. and Morris, M.A. (2021), Data considerations for the success of policy to restrict in-store food promotions: A commentary from a food industry nutritionist consultation. Nutr Bull, 46: 40-51. ", a(href="https://doi.org/10.1111/nbu.12486", "https://doi.org/10.1111/nbu.12486", style = "font-weight: bold;")),
                    tags$li("Jenneson, V., Greenwood, D.C., Clarke, G.P., Hancock, N., Cade, J.E. and Morris, M.A. (2020), Restricting promotions of ‘less healthy’ foods and beverages by price and location: A big data application of UK Nutrient Profiling Models to a retail product dataset. Nutr Bull, 45: 389-402. ", a(href="https://doi.org/10.1111/nbu.12468", "https://doi.org/10.1111/nbu.12468", style = "font-weight: bold;")),
                  ),
                  ),
                  ),
                  column(1),
                ),

                ),

                tabPanel(img(src="HASPlogo.png", height = 60, style = "margin-left: 20px; margin-top: -15px;", alt = "HASP Logo: colourful semicircles next to the text 'Healthy and Sustainable Places Data Service'.")

                        ), # close tabPanel
                
                # close tabPanel"
               
              #  # open new tabpanel to store logo in
              #  tabPanel(img(src="cropped-CDRC-Col.jpg", height = 70)
              #           ), # close tabPanel
               
tags$footer(
  br(),
  br(),
  wellPanel(fluidRow(
                          column(8,
                          HTML('<small>Designed by researchers at <a href="https://hasp.ac.uk/">HASP</a> at the University of Leeds, originally as part of the <a href="https://www.cdrc.ac.uk/">CDRC</a></small>'),
                          br(),
                          HTML("<small>  Published under the AGPL-3.0 License, Copyright © 2025 HASP, University of Leeds</small>"),
                          br(),
                           HTML('<div><small><a href="https://hasp.ac.uk/privacy/">Privacy and Cookies</a> | <a href="#" id="open_preferences_center">Update cookies preferences</a> </small></div>'),
                          ),
                          column(2,
                          img(src="HASPlogo.png", height = 50, align ='right',
                          alt="HASP Logo: colourful semicircles next to the text 'Healthy and Sustainable Places Data Service'."), br(),),
                          column(2,
                          img(src="UoL_logo.png", height = 50, align ='right',
                          alt="University of Leeds logo: a cartoon graphic of the Parkinson Building clock tower over the text 'University of Leeds' in capital letters."), br(),
                          ),
                        ),
                          style = "color: #24226f; background-color: white; border-color: white; font-size: 12; box-shadow: None"),
)
    )
)) # close fluidLayout and ShinyUI

)# close navbarPage
