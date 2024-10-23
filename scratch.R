input$in_satfat <- 7
SatF <- reactive({ifelse(
    (input$in_satfat/100)*100 >10.0, 10, 
    ifelse((input$in_satfat/100)*100 >9.0, 9,
            ifelse((input$in_satfat/100)*100 >8.0, 8,
                ifelse((input$in_satfat/100)*100 >7.00000, 7,
                        ifelse((input$in_satfat/100)*100 >6.0, 6,
                                ifelse((input$in_satfat/100)*100 >5.0, 5,
                                        ifelse((input$in_satfat/100)*100 >4.0, 4,
                                            ifelse((input$in_satfat/100)*100 >3.0, 3,
                                                    ifelse((input$in_satfat/100)*100 >2.0, 2,
                                                            ifelse((input$in_satfat/100)*100 >1, 1,
                                                                    0))))))))))