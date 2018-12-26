require(shiny)
require(shinyjs)
require(shinythemes)
require(shinyBS)

ui_files = list.files(path = "./ui", pattern = "*.R")
ui_files = paste0("ui/", ui_files)

for (i in seq_along(ui_files)) {
  #  source(ui_files[i], local = TRUE)
}

shinyUI(
  tagList(
    useShinyjs(),
    div(id = "app-content",
        navbarPage(
          title = div(img(src = "mlr_logo.png", height = 30)),
          id = "top-nav",
          windowTitle = "mlrPlayground"
        ),
        fluidPage(
          fluidRow(
            actionButton("taskBut", "Set Task"),
            selectInput("learner", label = "Select learner", choices = as.list(mlr::listLearners()$name[mlr::listLearners()$type == "classif"])),
            actionButton("paramBut", "Change parameters"),
            plotOutput("distPlot"),
            bsModal(
              "modalExample", "Data Table", "taskBut", size = "large",
              dataTableOutput("distTable"))
            )
          )
        )
    )
  )
)
