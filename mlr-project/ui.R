require(shiny)
require(shinydashboard)
require(shinyjs)
require(shinyBS)
require(DT)
require(plotly)
require(shinythemes)

ui.files = list.files(path = "./ui",pattern = "*.R")
ui.files = paste0("ui/", ui.files)
for(i in seq_along(ui.files)){
    source(ui.files[i], local = TRUE)
}

shinyUI
    (
        tagList
        (
            div
            (
                id = "app-content",
                navbarPage
                (
                    "new_shiny_logo",
                    # title = div(img(src = "new_shiny_logo.png",height = 35)),
                    # theme = shinytheme("united"), 
                    id = "top-nav",
                    tabPanel
                    (
                        "Import",
                        tabpanel.import
                        # icon = icon("folder-open")
                    ),
                    navbarMenu
                    (
                        "Data",
                        # icon = icon("database"),
                        tabPanel
                            (
                                "Summary"
                                # tabpanel.summary,
                                # icon = ("bar-chart")
                            ),
                        tabPanel
                        (
                            "Preprocessing"
                            # tabpanel.preprocessing,
                            # icon = icon("magic")
                        )
                    ),
                    navbarMenu
                    (
                        "Classification",
                        # tabpanel.task,
                        # icon = icon("flag")
                        tabPanel
                        (
                            "KNN",
                            tabpanel.Classification_KNN
                        ),
                        tabPanel
                        (
                            "Naive Bayes"
                        ),
                        tabPanel
                        (
                            "SVM"
                        ),
                        tabPanel
                        (
                            "Decision Trees"
                        )
                    ),
                    tabPanel
                    (
                        "Record"
                        #tabpanel.record, 
                        
                    )
                )
             )
        )
    )

