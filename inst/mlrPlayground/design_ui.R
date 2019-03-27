require(shiny)
require(shinyjs)
require(shinythemes)
require(shinyBS)


shinyUI(
  tagList(
    #shinythemes::themeSelector(),
    useShinyjs(),
    div(
      id = "app-content",
      tags$head(
        tags$title("mlrPlayground"),
        tags$meta(charset = "utf-8"),
        tags$meta(name = "viewport", content = "width=device-width, initial-scale=1, user-scalable=no"),
        tags$meta(name = "description", content = ""),
        tags$meta(name = "keywords", content = ""),
        tags$link(rel = "stylesheet", href = "templated-industrious/assets/css/main.css")
      ),
      tags$body(
        class = "is-preload",

        ### HEADER

        tags$header(
          id = "header",
          tags$a(
            class = "logo",
            href = "#menu",
            "mlrPlayground"
          ),
          tags$nav(
            tags$a(
              href = "#menu",
              "Menu"
            )
          )
        ),

        ### NAV

        tags$nav(
          id = "menu",
          tags$ul(
            class = "links",
            tags$li(
              tags$a(
                href = "#menu",
                "Home"
              )
            ),
            tags$li(
              tags$a(
                href = "https://templated.co/",
                "Design"
              )
            ),
            tags$li(
              tags$a(
                href = "https://mlr.mlr-org.com/",
                "Backend"
              )
            )
          )
        ),

        ### BANNER

        tags$section(
          id = "banner",
          tags$div(
            class = "inner",
            tags$h1("mlr Playground"),
            tags$p(
              list(
                "A playground app for quick and interactive comparisons",
                tags$br(),
                "of different machine learning algorithms on different tasks,",
                tags$br(),
                "using the ",
                tags$a(
                  href = "https://mlr.mlr-org.com/",
                  "mlr package"
                ),
                "as backend."
              )
            )
          ),
          tags$video(
            autoplay = NA,
            loop = NA,
            muted = NA,
            playsinline = NA,
            src = "templated-industrious/images/banner.mp4"
          )
        ),

        #### MAIN

        tags$section(
          class = "wrapper",
          tags$div(
            class = "inner",
            tags$div(
              class = "highlights",
              tags$section(
                tags$div(
                  class = "content",
                  tags$a(
                    class = "icon fa-qrcode",
                    style = "font-size: 6.0em !important; height:150px !important; width:150px !important;"
                    #tags$span(
                    #  class = "label",
                    #  "Icon"
                    #)
                  ),
                  tags$br(),
                  tags$button(
                    id = "taskButton",
                    class = "btn",
                    "SELECT TASK"
                  ),
                  tags$br(),
                  tags$br(),
                  tags$p("A preset of different tasks with two covariables and a single (numeric/nominal) target variable")
                )
              ),
              tags$section(
                tags$div(
                  class = "content",
                  tags$a(
                    class = "icon fa-graduation-cap",
                    style = "font-size: 6.0em !important; height:150px !important; width:150px !important;",
                    tags$span(
                      class = "label",
                      "Icon"
                    )
                  ),
                  tags$br(),
                  tags$select(
                    id = "learnerSelection",
                    style = "width: 200px; background-color: white; margin-left: auto; margin-right: auto;",
                    tags$option(value = "", disabled = NA, selected = NA, "SELECT LEARNER"),
                    tags$option(value = "knn", "k-NN"),
                    tags$option(value = "randomforest", "Random Forest"),
                    tags$option(value = "linearmodel", "Linear Model")
                  ),
                  tags$br(),
                  tags$br(),
                  tags$p("A selection of machine learning algorithms for learning the chosen task")
                )
              ),
              tags$section(
                tags$div(
                  class = "content",
                  tags$a(
                    class = "icon fa-cog",
                    style = "font-size: 6.0em !important; height:150px !important; width:150px !important;",
                    tags$span(
                      class = "label",
                      "Icon"
                    )
                  ),
                  tags$br(),
                  tags$button(
                    id = "parameterButton",
                    class = "btn",
                    "CHANGE PARAMETER"
                  ),
                  tags$br(),
                  tags$br(),
                  tags$p("Setting the hyperparameters of the selected algorithm")
                )
              )
            )
          )
        ),

        tags$script(src = "templated-industrious/assets/js/jquery.min.js"),
        tags$script(src = "templated-industrious/assets/js/browser.min.js"),
        tags$script(src = "templated-industrious/assets/js/breakpoints.min.js"),
        tags$script(src = "templated-industrious/assets/js/util.js"),
        tags$script(src = "templated-industrious/assets/js/main.js")
      )
    ),
    fluidPage(
      #theme = shinytheme("flatly"),
      bsModal(
        "modalTask", "Tasks", "taskButton", size = "large",
        radioButtons(
          "taskSelection",
          "Choose a task",
          c("Dataset A", "Dataset B", "Dataset C", "Dataset D", "Dataset E", "Dataset F", "Dataset G", "Dataset H")
        )
      )
    )
  )
)
