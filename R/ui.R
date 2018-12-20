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
    #shinythemes::themeSelector(),
    useShinyjs(),
    div(id = "app-content",
      navbarPage(
        title = div(img(src = "mlr_logo.png", height = 30)),
        theme = "templated-retrospect/assets/css/main.css", #shinytheme("flatly"),
        id = "top-nav",
        windowTitle = "mlrPlayground"
      ),
      fluidPage(
        sidebarLayout(
          sidebarPanel(
            actionButton("taskBut", "Define Task"),
            actionButton("learnerBut", "Define Learner"),
            actionButton("trainBut", "Define Learner")
          ),

          mainPanel(
            plotOutput("distPlot"),
            bsModal("modalExample", "Data Table", "taskBut", size = "large",
                    dataTableOutput("distTable"))
          )
        )
      )
    )
  )
)
