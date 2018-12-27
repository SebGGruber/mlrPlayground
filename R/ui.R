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
  fluidPage(
    fluidRow(
      actionButton("taskBut", "Set task"),
      selectInput("learner", label = "Select learner", choices = as.list(mlr::listLearners()$name[mlr::listLearners()$type == "classif"])),
      actionButton("paramBut", "Change parameters"),
      plotOutput("distPlot"),
      bsModal(
        "modalExample", "Task selection", "taskBut", size = "large",
        fluidRow(
          selectInput(
            "tasktype",
            label = "Select task type",
            choices = list("Regression", "Classification", "Clustering", "Multilabel", "Survival")
          ),
          radioButtons("task", label = "Select task", choices = list("Dataset 1", "Dataset 2", "Dataset 3"))
        )
      )
    )
  )
)
