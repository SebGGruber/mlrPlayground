require(shiny)
require(shinyjs)
require(shinythemes)

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
        theme = shinytheme("flatly"),
        id = "top-nav",
        windowTitle = "shinyMlr",
        fluidPage(
          sidebarLayout(
            sidebarPanel(
              sliderInput("bins",
                          "Number of bins:",
                          min = 1,
                          max = 50,
                          value = 30),
              actionButton("tabBut", "View Table")
            ),

            mainPanel(
              plotOutput("distPlot"),
              bsModal("modalExample", "Data Table", "tabBut", size = "large",
                      dataTableOutput("distTable"))
            )
          )
        )
      )
    )
  )
)
