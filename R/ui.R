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
    useShinyjs(),
    div(id = "app-content",
      navbarPage(title = div(img(src = "new_shiny_logo.png", height = 35)),
        theme = shinytheme("united"), id = "top-nav", windowTitle = "shinyMlr"
      )
    )
  )
)
