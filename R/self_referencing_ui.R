library(shiny)

omega_nr <- 0

# Define the UI
myui <- basicPage(
  actionButton("btn", "Add"),
  uiOutput('Dynamic')
)

# Define the server code
myserver <- function(input, output, session) {

  omega <- reactive({
    #invalidateLater(1000, session)
    input$btn
    return(1:omega_nr)
  })

  # update non reactive value
  observe({
    omega()
    omega_nr <<- omega_nr+1
  })


  selected = reactive({

    selection = lapply(omega(), function (i) {
      input[[paste0("learner", i)]]
    })

    return(unlist(selection))
  })


  output$Dynamic <- renderUI({

    dynamic_selection_list <- lapply(omega(), function(i) {
      selectInput(
        inputId = paste0("learner",i),
        label = paste("Learner",i),
        choices = c("A", "B", "C"),
        selected = isolate(selected()[i])
      )
    })

    do.call(tagList, dynamic_selection_list)
  })
}


# Return a Shiny app object
shinyApp(ui = myui, server = myserver)
