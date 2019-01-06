app = shinyApp(
    ui =
        fluidPage(
            sidebarLayout(
                sidebarPanel(textInput("num1", NULL, value = 100),
                                              "divided by", textInput("num2", NULL, value = 20),
                                              "equals", textOutput("exampleOutput")),
                mainPanel(
                    bsAlert("alert")
                  )
              )
        ),
    server =
        function(input, output, session) {
            output$exampleOutput <- renderText({
                num1 <- as.numeric(input$num1)
                num2 <- as.numeric(input$num2)

                  if(is.na(num1) | is.na(num2)) {
                      createAlert(session, "alert", "exampleAlert", title = "Oops",
                                                     content = "Both inputs should be numeric.", append = FALSE)
                    } else if(num2 == 0) {
                        createAlert(session, "alert", "exampleAlert", title = "Oops",
                                                       content = "You cannot divide by 0.", append = FALSE)
                      } else {
          closeAlert(session, "exampleAlert")
          return(num1/num2)
        }
      })
    }
)

runApp(app)
