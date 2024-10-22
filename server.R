# Automating a Nutrient Profiling Model
# Adapted from https://github.com/VickiJenneson/NPM_Promotional_Restrictions
# 2021, Rosalind Martin, Data Scientist Intern, Leeds Institute for Data Analytics
# Supervisors: Michelle Morris and Vicki Jenneson, Univeristy of Leeds

# load libraries ----
library(shiny)
library(dplyr)
library(tidyverse)
library(vroom)
library(shinyBS)
library(ggplot2)
library(shinyjs)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)

#options(warn=2,shiny.error=recover)

options(shiny.maxRequestSize=30*1024^2) # allow file upload size max 30MB

# define server logic required
shinyServer(function(input, output, session) {

# Define page navigation action buttons ----

    # button to jump from home page to calculator page
    observeEvent(input$jumpToCalc, {
      updateTabsetPanel(session, "about", selected = "calculator")
      }
    )
  
  # button to jump from home page to calculator page
  observeEvent(input$jumpMulti, {
    updateTabsetPanel(session, "about", selected = "Multi")
  })
  
  # button to jump from home page to user guide
  observeEvent(input$jumpToGuide, {
    updateTabsetPanel(session, "about", selected = "Guide")
  })
    
  # button to jump from calculator page to result page
  observeEvent(input$jumpToResult, {
    updateTabsetPanel(session = session, inputId = "calc1", selected = "result")
  })
  
  
  # button to jump from result page to calculator page
  observeEvent(input$jumpBack, {
    updateTabsetPanel(session = session, inputId = "calc1", selected = "calc")
  })

  
# User purpose dropdown ----
  output$purpose <- reactive({input$purpose})

# HFSS category table ----
  
  # create table to house category info
  tab <- matrix(c('1. Soft drinks','Prepared soft drinks containing added sugar ingredients. Includes ready to drink, milks or milk alternatives, powders, syrups, pods and cordials.','No added sugar drinks, alcoholic drinks (>1.2% ABV), infant formula, meal replacements, foods for special medical purposes',
                  '2. Savoury snacks','Savoury snacks, whether consumed alone or as part of a meal, potato products (e.g. crisps), extruded products, crackers, rice cakes, biscuits, pork scratchings.','Nuts and seeds, fruit-based snacks, trail mix (dried fruit and nuts), meat jerky',
                  '3. Breakfast cereals','Breakfast cereals including ready-to-eat cereals, granola, museli, porridge and other oat-based cereals','N/A',
                  '4. Confectionary', 'Confectionary including chocolates, sweets, popcorn, chewing gum, chocolate covered products e.g. pretzels/nuts','Dried fruit, sweet/savoury coated nuts (unless coated in chocolate)',
                  '5. Ices', 'Ice cream, lollies, frozen yoghurts, sorbets, water ices','Accessories/toppings e.g. sprinkles, sauces, wafers (category 7), alcoholic products (>1.2% ABV), roulade and gateaux (category 9)',
                  '6. Cakes and cupcakes', 'All types of cakes, ambient and chilled, including cake mixes','Cake decorations, icing and sauces',
                  '7. Sweet biscuits and bars', 'Sweet biscuits and bars based on one or more of nuts, seeds or cereal','N/A',
                  '8. Morning goods', 'Sweet pastries, buns, morning goods mixes and ready to bake, includes free from and fruited breads, crumpets, bagels, English muffins','Excludes savoury breads',
                  '9. Desserts and puddings', 'All types of ambient (including canned), chilled and frozen puddings, and dessert mixes, including free from','Creams, syrups, condensed caramel, dessert toppings and sauces, plain meringue nests, sponge fingers, tinned or canned fruit',
                  '10. Sweetened yoghurt', 'Includes dairy and non-dairy alternatives. Includes yoghurts sweetened with sweeteners, sugar or fruit', 'Natural unsweetened yoghurts/fromage frais',
                  '11. Pizza', 'All chilled and frozen pizzas','Plain pizza bases, garlic bread and cheese garlic bread, and loaded varieties',
                  '12. Potato products', 'Roast potatoes, chips, wedges, waffles, hash browns, rosties, potato shapes, croquettes, sweet potato products','Plain potatoes, whole, sliced or mashed potatoes with butter, potato salad',
                  '13. Ready meals and meal centres', 'Ready for cooking meals, breaded or battered meal centres, meal centres with a sauce','Breaded/battered cheese-based products intended to be consued as a starter or side. Meats, fish, shellfish or meat alternatives that are plain (e.g. raw plain chicken breasts) or have been smoked (e.g. smoked meat and fish) or are processed meats (e.g. ham, salami and bacon). Food that are not cooked or reheated before consumption (e.g. sandwiches and salads). Meal kits e.g. fajits requiring prep, products intended as a starter or side, dried pasta (requires reconstitution), breaded ham or charcuterie, savoury pastries, plain/marinaded meat, poultry, fish or alternatives, savoury pies, quiches, sandwiches, sushi, ready to go (not cooked/re-heated), party food.'),
                ncol=3, byrow=TRUE)
  colnames(tab) <-c('HFSS category', 'Description', 'Exemptions')
  rownames(tab) <-c('Category 1', 'Category 2', 'Category 3', 'Category 4', 'Category 5',
                    'Category 6', 'Category 7', 'Category 8', 'Category 9', 'Category 10',
                    'Category 11', 'Category 12', 'Category 13')

  # render table which will be displayed
  output$CategoryTable <- renderTable(tab)

  # Specific Gravity table ----
  
  # create table to house specific gravity info
  SGtab <- matrix(c('Semi-skimmed milk', '1.03',
                    'Carbonated drink/fruit juice', '1.04',
                    'Diet carbonated drink', '1.00',
                    'Energy drink', '1.07',
                    'Cordial/squash ready to drink', '1.03',
                    'Cordial/squash undiluted', '1.09',
                    'Ice cream', '1.30',
                    'Ice lolly', '0.90',
                    'Mayonnaise', '0.91',
                    'Maple syrup', '1.32',
                    'Single cream', '1.00',
                    'Double cream', '0.94',
                    'Whipping cream', '0.96',
                    'Evaporated milk', '1.07'),
                ncol=2, byrow=TRUE)
  colnames(SGtab) <-c('Product', 'Specific gravity')
  
  
  # render table which will be displayed
  output$SGTable <- renderTable(SGtab)  
  
    # Single product assessment ----
    
    # clear form button using shinyjs package
    observeEvent(input$reset_input,{
      shinyjs::reset("form")
    })
    
    # create a variable output for each inputted value
    output$pname <- renderPrint({input$in_prodname})
    output$alcohol <- renderPrint({input$in_alc})
    output$ingredients <- renderPrint({input$in_ingredients})
    output$EKJ <- renderPrint({input$in_EKJ})
    output$Ekcal <- renderPrint({input$in_Ekcal})
    output$sugar <- renderPrint({input$in_sugar})
    output$satfat <- renderPrint({input$in_satfat})
    output$salt <- renderPrint({input$in_sal})
    output$sodium <- renderPrint({input$in_NA})
    output$AOACfib <- renderPrint({input$in_AOACfib})
    output$NSPfib <- renderPrint({input$in_NSPfib})
    output$protein <- renderPrint({input$in_protein})
    output$FVN <- renderPrint({input$in_FVNper})
    
    # create output to show whether food or drink was selected
    Type <- reactive({if(input$Type_button == FALSE){ # food
      Type <- "Food"
    }else{ # drink
      Type <- "Drink"
    }})
    
    output$Type <- Type
    
    # create output to show NPM score threshold depending whether food or drink selected
    Threshold <- reactive({if(input$Type_button == FALSE){ # food
      Threshold <- "≥4 = FAIL"
    }else{ # drink
      Threshold <- "≥1 = FAIL"
    }})
    
    output$Threshold <- Threshold
    
    # incorporate user entered weight/volume
    # weight of product
     Pweight <- reactive({if(input$Type_button == FALSE){ # food
       Pweight <- ifelse(input$Unit_button == FALSE,input$Food_wt,
       ifelse(input$Unit_button == TRUE && input$FoodSG == 1, input$Food_vol *1.30, #SG for ice cream
              ifelse(input$Unit_button == TRUE && input$FoodSG == 2, input$Food_vol * 0.90, #SG for ice lollies
                     ifelse(input$Unit_button == TRUE && input$FoodSG == 3, input$Food_vol * 0.91, #SG for mayonnaise
                            ifelse(input$Unit_button == TRUE && input$FoodSG == 4, input$Food_vol * 1.32, #SG for maple syrup
                                   ifelse(input$Unit_button == TRUE && input$FoodSG == 5, input$Food_vol * 1.00,#SG for single cream
                                          ifelse(input$Unit_button == TRUE && input$FoodSG == 6, input$Food_vol * 0.94, #SG for double cream
                                                 ifelse(input$Unit_button == TRUE && input$FoodSG == 7, input$Food_vol * 0.96, #SG for whipping cream
                                                        ifelse(input$Unit_button == TRUE && input$FoodSG == 8, input$Food_vol *1.07, #SG for evaporated milk
                                                               ifelse(input$Unit_button == TRUE, input$Food_vol))))))))))
     }else{
       ifelse(input$Format == 1 && input$DrinkSG == 1, input$Vol * 1.03, #SG for semi-skimmed milk
              ifelse(input$Format == 1 && input$DrinkSG == 2, input$Vol *1.04, #SG for carbonated/fruit juice
                     ifelse(input$Format == 1 && input$DrinkSG == 3, input$Vol * 1.00, #SG for diet carbonated
                            ifelse(input$Format == 1 && input$DrinkSG == 4, input$Vol * 1.07, #SG for energy drinks
                                   ifelse(input$Format == 1 && input$DrinkSG == 5, input$Vol *1.03, # SG for cordial/squash RTD
              ifelse(input$Format == 2 && input$Pow_sold == 2, (input$Powder + input$Liquid)*1.03, # SG for cordial RTD
                     ifelse(input$Format == 2 && input$Pow_sold == 1, input$PowVol * 1.03, # SG for cordial RTD
                            ifelse(input$Format == 2 && input$Pow_sold == 3, input$WtPow,
                     ifelse(input$Format ==3 && input$Cor_sold == 2, (input$Cordial + input$Water)*1.03, # SG for cordial RTD
                            ifelse(input$Format ==3 && input$Cor_sold == 1, input$CorVol *1.03, # SG for cordial RTD
                                   ifelse(input$Format == 3 && input$Cor_sold == 3, input$VolCor *1.09))))))))))) # SG for cordial undiluted
     }
     })
     
     # capture entered weight (not accounting for specific gravity)
     Weight <- reactive({if(input$Type_button == FALSE){ # food
       Pweight <- ifelse(input$Unit_button == FALSE,input$Food_wt,
                         ifelse(input$Unit_button == TRUE && input$FoodSG == 1, input$Food_vol, 
                                ifelse(input$Unit_button == TRUE && input$FoodSG == 2, input$Food_vol, 
                                       ifelse(input$Unit_button == TRUE && input$FoodSG == 3, input$Food_vol,
                                              ifelse(input$Unit_button == TRUE && input$FoodSG == 4, input$Food_vol, 
                                                     ifelse(input$Unit_button == TRUE && input$FoodSG == 5, input$Food_vol,
                                                            ifelse(input$Unit_button == TRUE && input$FoodSG == 6, input$Food_vol, 
                                                                   ifelse(input$Unit_button == TRUE && input$FoodSG == 7, input$Food_vol, 
                                                                          ifelse(input$Unit_button == TRUE && input$FoodSG == 8, input$Food_vol, 
                                                                                 ifelse(input$Unit_button == TRUE, input$Food_vol))))))))))
     }else{
       ifelse(input$Format == 1 && input$DrinkSG == 1, input$Vol, 
              ifelse(input$Format == 1 && input$DrinkSG == 2, input$Vol, 
                     ifelse(input$Format == 1 && input$DrinkSG == 3, input$Vol,
                            ifelse(input$Format == 1 && input$DrinkSG == 4, input$Vol, 
                                   ifelse(input$Format == 1 && input$DrinkSG == 5, input$Vol, 
                                          ifelse(input$Format == 2 && input$Pow_sold == 2, (input$Powder + input$Liquid), 
                                                 ifelse(input$Format == 2 && input$Pow_sold == 1, input$PowVol, 
                                                        ifelse(input$Format == 2 && input$Pow_sold == 3, input$WtPow,
                                                               ifelse(input$Format ==3 && input$Cor_sold == 2, (input$Cordial + input$Water), 
                                                                      ifelse(input$Format ==3 && input$Cor_sold == 1, input$CorVol,
                                                                             ifelse(input$Format == 3 && input$Cor_sold == 3, input$VolCor))))))))))) 
     }
     })
     
   
     output$weight <- Pweight
     
     
     # create reactive text which tells people the weight value for which they should enter nutritional info    
 
     # define the unit for the reactive text
     Punit<-  reactive({
       ifelse(input$Type_button == FALSE && input$Unit_button == FALSE, 
         'g',
         ifelse(input$Type_button == FALSE && input$Unit_button == TRUE,
                'ml',
     ifelse(input$Type_button == TRUE,
       'ml')))
     })
    
   
     # this will be shown if volume (ml)
     output$Entervol<- renderText({
       req(Weight())
       req(Punit())
       paste("<span style=\"color:teal\"> Enter nutrient information per <b>", Weight(), Punit(),"<b> of product as shown on pack. </span> " )
     })
     
     
     # create reactive text which tells people the equivalent weight in grams for ml entered values
     output$Gequiv <- renderText({
       req(Pweight())
       paste("<span style=\"color:teal\"> Equivalent to <b>", Pweight(), "grams of product. </span> ")
       
     })
    
   # SPA A-points calculation ----
     
    # calculate score for each component to be displayed as an output
    # A-points
    # Energy
    # this stores the output of energy points allowing them to be added up and displayed to the user as total A points 
    E_KJ <- reactive({if(input$Energy_button == FALSE){ # KJ entered
    E_KJ <- ifelse(
      (input$in_E/Pweight())*100 >3350, 10, 
      ifelse((input$in_E/Pweight())*100 >3015, 9,
             ifelse((input$in_E/Pweight())*100 >2680, 8,
                    ifelse((input$in_E/Pweight())*100 >2345, 7,
                           ifelse((input$in_E/Pweight())*100 >2010, 6,
                                  ifelse((input$in_E/Pweight())*100 >1675, 5,
                                         ifelse((input$in_E/Pweight())*100 >1340, 4,
                                                ifelse((input$in_E/Pweight())*100 >1005, 3,
                                                       ifelse((input$in_E/Pweight())*100 >670, 2,
                                                              ifelse((input$in_E/Pweight())*100 >335, 1,
                                                                     0))))))))))
    }else{ # kcal entered
      ifelse(
        ((input$in_E/Pweight())*100)*4.184 >3350, 10, 
        ifelse(((input$in_E/Pweight())*100)*4.184 >3015, 9,
               ifelse(((input$in_E/Pweight())*100)*4.184 >2680, 8,
                      ifelse(((input$in_E/Pweight())*100)*4.184 >2345, 7,
                             ifelse(((input$in_E/Pweight())*100)*4.184 >2020, 6,
                                    ifelse(((input$in_E/Pweight())*100)*4.184 >1675, 5,
                                           ifelse(((input$in_E/Pweight())*100)*4.184 >1340, 4,
                                                  ifelse(((input$in_E/Pweight())*100)*4.184 >1005, 3,
                                                         ifelse(((input$in_E/Pweight())*100)*4.184 >670, 2,
                                                                ifelse(((input$in_E/Pweight())*100)*4.184 >335, 1,
                                                                       0))))))))))
    }})
    
    # create reactive output
    output$Energy_points <- reactive({E_KJ()})
    
    # Sugar
     # Stored value
    Sug <- reactive({ifelse(
      (input$in_sugar/Pweight())*100 >45, 10, 
      ifelse((input$in_sugar/Pweight())*100 >40, 9,
             ifelse((input$in_sugar/Pweight())*100 >36, 8,
                    ifelse((input$in_sugar/Pweight())*100 >31, 7,
                           ifelse((input$in_sugar/Pweight())*100 >27, 6,
                                  ifelse((input$in_sugar/Pweight())*100 >22.5, 5,
                                         ifelse((input$in_sugar/Pweight())*100 >18, 4,
                                                ifelse((input$in_sugar/Pweight())*100 >13.5, 3,
                                                       ifelse((input$in_sugar/Pweight())*100 >9, 2,
                                                              ifelse((input$in_sugar/Pweight())*100 >4.5, 1,
                                                                     0))))))))))
    })
    # create reactive output
    output$Sugar_points <- reactive({Sug()})
    
    # Saturated fat

    # Add tolerance to avoid floating point error
    epsilon <- 0.00000001
      # stored value
    SatF <- reactive({ifelse(
      (input$in_satfat/Pweight())*100 >10, 10, 
      ifelse((input$in_satfat/Pweight())*100 >9, 9,
             ifelse((input$in_satfat/Pweight())*100 >8, 8,
                    ifelse((input$in_satfat/Pweight())*100 >7 + epsilon, 7,
                           ifelse((input$in_satfat/Pweight())*100 >6, 6,
                                  ifelse((input$in_satfat/Pweight())*100 >5, 5,
                                         ifelse((input$in_satfat/Pweight())*100 >4, 4,
                                                ifelse((input$in_satfat/Pweight())*100 >3, 3,
                                                       ifelse((input$in_satfat/Pweight())*100 >2, 2,
                                                              ifelse((input$in_satfat/Pweight())*100 >1, 1,
                                                                     0))))))))))
    })
    # create reactive output
    output$Satfat_points <- reactive({SatF()})
    
    # Sodium
    # convert salt to sodium ----
      Sod <- reactive({if(input$salt_button == FALSE){ # NA entered
      Sod <- ifelse(
      (input$in_NA/Pweight())*100 >900, 10, 
      ifelse((input$in_NA/Pweight())*100 >810, 9,
             ifelse((input$in_NA/Pweight())*100 >720, 8,
                    ifelse((input$in_NA/Pweight())*100 >630, 7,
                           ifelse((input$in_NA/Pweight())*100 >540, 6,
                                  ifelse((input$in_NA/Pweight())*100 >450, 5,
                                         ifelse((input$in_NA/Pweight())*100 >360, 4,
                                                ifelse((input$in_NA/Pweight())*100 >270, 3,
                                                       ifelse((input$in_NA/Pweight())*100 >180, 2,
                                                              ifelse((input$in_NA/Pweight())*100 >90, 1,
                                                                     0))))))))))
    
      } else { # salt entered
        Sod <- ifelse(
          (((input$in_NA/2.5)*1000)/Pweight())*100 >900, 10, 
          ifelse((((input$in_NA/2.5)*1000)/Pweight())*100 >810, 9,
                 ifelse((((input$in_NA/2.5)*1000)/Pweight())*100 >720, 8,
                        ifelse((((input$in_NA/2.5)*1000)/Pweight())*100 >630, 7,
                               ifelse((((input$in_NA/2.5)*1000)/Pweight())*100 >540, 6,
                                      ifelse((((input$in_NA/2.5)*1000)/Pweight())*100 >450, 5,
                                             ifelse((((input$in_NA/2.5)*1000)/Pweight())*100 >360, 4,
                                                    ifelse((((input$in_NA/2.5)*1000)/Pweight())*100 >270, 3,
                                                           ifelse((((input$in_NA/2.5)*1000)/Pweight())*100 >180, 2,
                                                                  ifelse((((input$in_NA/2.5)*1000)/Pweight())*100 >90, 1,
                                                                         0))))))))))
        }})
      
  
    
     
    # create reactive output
    output$Sodium_points <- reactive({Sod()})
    
    
    # calculate total A-points

    totalA <- reactive({E_KJ() + Sug() + SatF() + Sod()})
    output$totalA <- totalA
    # stored value for use in total score calc
    TOT_A <- reactive({E_KJ() + Sug() + SatF() + Sod()})
    # to use in html output
    output$TOTALA <- renderText({
      req(totalA())
      paste("<span style=\"color:teal\"> <b><h1>",totalA(),"<h1><b> </span>")
    }) 
    
     
    # SPA C-points calculation ----
    
    # C-points
    # FVN
    # stored value
    FVN_P <- reactive({ifelse(input$in_FVNper > 80,5,
                                          ifelse(input$in_FVNper > 60,2,
                                                 ifelse(input$in_FVNper > 40,1,0)
                                          )
    )})
    # create reactive output
    output$FVN_points <- reactive({FVN_P()})

    # Fibre
    # stored value
    FIB <- reactive({if(input$fibre_button == FALSE){ #NSP fibre entered
      FIB <- ifelse((input$in_fib/Pweight())*100 > 3.5,5,
                                          ifelse((input$in_fib/Pweight())*100 > 2.8,4,
                                                 ifelse((input$in_fib/Pweight())*100 > 2.1,3,
                                                        ifelse((input$in_fib/Pweight())*100 > 1.4,2,
                                                               ifelse((input$in_fib/Pweight())*100 > 0.7,1,0)
                                                        )
                                                 )
                                          )
    )
    }else{ # AOAC fibre entered
      FIB <- ifelse((input$in_fib/Pweight())*100 > 4.7,5, 
                    ifelse((input$in_fib/Pweight())*100 > 3.7,4,
                           ifelse((input$in_fib/Pweight())*100 > 2.8,3,
                                  ifelse((input$in_fib/Pweight())*100 > 1.9,2,
                                         ifelse((input$in_fib/Pweight())*100 > 0.9,1,0)
                                  )
                           )
                    )
      )
    }})
    
    
    
    # create reactive output
    output$Fib_points <- reactive({FIB()})  
    
    
    # protein
    # stored value
    Prot <- reactive({ifelse((input$in_protein/Pweight())*100 > 8,5,
                                       ifelse((input$in_protein/Pweight())*100 > 6.4,4,
                                              ifelse((input$in_protein/Pweight())*100 > 4.8,3,
                                                     ifelse((input$in_protein/Pweight())*100 > 3.2,2,
                                                            ifelse((input$in_protein/Pweight())*100 > 1.6,1,0)
                                                     )
                                              )
                                       )
    )
    })
    # create reactive output
    output$protein_points <- reactive({Prot()})  
    
    # calculate total C-points
    
    totalC <- reactive({FVN_P() + Prot()+ FIB()})
    output$totalC <- totalC
    #stored value for use in total score calc
    TOT_C <- reactive({FVN_P() + Prot()+ FIB()})
    # to use in html output
    output$TOTALC <-renderText({
      req(totalC())
      paste("<span style=\"color:teal\"> <b><h1>",totalC(),"<h1><b> </span>")
    })
    
    
    # SPA Total NPM points calculation ----
    
    # Calculate total NPM points
    Total_NPM <- reactive({ifelse((TOT_A())<11,
                               (TOT_A()) - (TOT_C()),
                               ifelse((TOT_A())>=11 && FVN_P()>=5,
                                      (TOT_A()) - (TOT_C()),
                               (TOT_A()) - (FVN_P() + FIB())))
    })
    
    output$Total <- renderText({
      req(Total_NPM())
      paste("<span style=\"color:teal\"> <b><h1>",Total_NPM(),"<h1><b> </span>")
    })
    
    Result <- reactive({if(input$Type_button == FALSE){ # food
      Result <- ifelse(Total_NPM() >= 4, "FAIL", "PASS")
    }else{ # drink
      Result <- ifelse(Total_NPM() >= 1, "FAIL", "PASS")
    }})
    
   
    # create result output
    output$result <-renderText({
      req(Result())
      paste("<span style=\"color:teal\"> <b><h1>",Result(),"<h1><b> </span>")
    })
    
  
    # create category output
    Prodcat <- reactive({
      req(input$Cat_dropdown)
    })
    
    output$Prodcat <- Prodcat
    
    # create product name output
    Pname <- reactive({input$in_prodname})
    
    output$prodname <- renderText({
      req(Pname())
      paste("<span style=\"color:teal\"> <b><h3>",Pname(),"<h3><b> </span>")
    })
      
    
    # create brand output
    Brand <- reactive({input$in_brand})
    
    output$prodbrand <- renderText({
      req(Brand())
      paste("<span style=\"color:teal\"> <b><h3>",Brand(),"<h3><b> </span>")
    })
    
    
   # create plots
    observe({
      if(req(input$Type_button) == FALSE){
      output$resultplot <- renderPlot({
        barplot(Total_NPM(),
                xlab = "NPM score (red line indicates threshold, 4)",
                horiz = TRUE, 
                xlim = c(0,40),
                col = ifelse(Total_NPM()<4,"#69b3a2","tomato2"))+ 
          abline(v=4, col = "red")
        
      })
      
    } else {
      output$resultplot <- renderPlot({
        barplot(Total_NPM(),
                xlab = "NPM score (red line indicates threshold, 1)",
                horiz = TRUE, 
                xlim = c(0,40),
                col = ifelse(Total_NPM()<1,"#69b3a2","tomato2"))+ 
          abline(v=1, col = "red")
        
      })
    }
    })
    

   
}) # close shinyServer
