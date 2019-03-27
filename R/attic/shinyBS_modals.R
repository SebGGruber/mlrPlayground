app = shinyApp(
    ui =
      fluidPage(
          sidebarLayout(
              sidebarPanel(
                  sliderInput("bins",
                                                         "Number of bins:",
                                                         min = 1,
                                                         max = 50,
                                                         value = 30),
                  #actionButton("tabBut", "View Table")
                  uiOutput("btn")
                ),

                mainPanel(
                    plotOutput("distPlot"),
                    uiOutput("modal")
                  )
            )
        ),
    server =
      function(input, output, session) {

        output$btn <- renderUI({
          actionButton("tabBut", "View Table")
        })

        lapply(1, function(i) {
          observeEvent(input$tabBut, {
            toggleModal(session, "modalExample", "open")
          })

        })

        output$modal <- renderUI({
          bsModal("modalExample", "Data Table", "tabBut", size = "large",
                  dataTableOutput("distTable"))
        })


            output$distPlot <- renderPlot({

                  x    <- faithful[, 2]
                  bins <- seq(min(x), max(x), length.out = input$bins + 1)

                    # draw the histogram with the specified number of bins
                    hist(x, breaks = bins, col = 'darkgray', border = 'white')

                  })

              output$distTable <- renderDataTable({

                    x    <- faithful[, 2]
                    bins <- seq(min(x), max(x), length.out = input$bins + 1)

                      # draw the histogram with the specified number of bins
                      tab <- hist(x, breaks = bins, plot = FALSE)
                    tab$breaks <- sapply(seq(length(tab$breaks) - 1), function(i) {
                        paste0(signif(tab$breaks[i], 3), "-", signif(tab$breaks[i+1], 3))
                      })
                    tab <- as.data.frame(do.call(cbind, tab))
                    colnames(tab) <- c("Bins", "Counts", "Density")
                    return(tab[, 1:3])

                    }, options = list(pageLength=10))

            }
   )

runApp(app)
