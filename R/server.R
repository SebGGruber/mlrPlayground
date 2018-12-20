require(mlr)


server_files = list.files(path = "./servers", pattern="*.R")
server_files = paste0("servers/", server_files)

for (i in seq_along(server_files)) {
#  source(server_files[i], local = TRUE)
}

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2)

shinyServer(function(input, output, session) {

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

  session$onSessionEnded(stopApp)
})
