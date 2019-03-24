source("ui/learner_panel.R",   local = TRUE) # importing: learner_panel
source("ui/parameter_panel.R", local = TRUE) # importing: parameter_panel
source("ui/task_modal.R",      local = TRUE) # importing: task_modal
source("ui/plots_tabset.R",    local = TRUE) # importing: plots_tabset


#shinyUI(
#  basicPage(
#    column(
#      6,
#      learner_panel,
#      parameter_panel,
#      task_modal
#    ),
#    column(
#      6,
#      plots_tabset
#    )
#  )
#)


shinyUI(
  tagList(
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
            # src: https://de.videezy.com/hintergrunde/5085-molecular-plex-4k-motion-hintergrundschleife
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
                  conditionalPanel(
                    "output.showLearners == true",
                    tags$a(
                      class = "icon fa-qrcode",
                      style = "font-size: 6.0em !important; height:150px !important; width:150px !important;"
                    ),
                    tags$br(),
                    actionButton("taskBut", "Change task"),
                    #textOutput("taskinfo"), # ugly
                    hr(),
                    tags$a(
                      class = "icon fa-graduation-cap",
                      style = "font-size: 6.0em !important; height:150px !important; width:150px !important;"
                    ),
                    withSpinner(
                      uiOutput("dynamicLearners")
                    ),
                    conditionalPanel(
                      "output.learner_amount < 2",
                      actionButton("addLearner", "add Learner")
                    )
                  ),
                  conditionalPanel(
                    "output.showLearners == false",
                    actionButton("parameterDone", "Back"),
                    # separated for independent reactivity
                    withSpinner(
                      uiOutput("dynamicParameters_1")
                    ),
                    withSpinner(
                      uiOutput("dynamicParameters_2")
                    ),
                    # separated for independent reactivity
                    uiOutput("min_max_modals_1"),
                    uiOutput("min_max_modals_2")
                  )
                )
              ),
              tags$section(
                tags$div(
                  class = "content",
                  plots_tabset
                )
              )
            )
          )
        ),

        # including jquery.min.js makes the app crash
        # consequences of excluding are unknown, so take care
        #tags$script(src = "templated-industrious/assets/js/jquery.min.js"),
        tags$script(src = "templated-industrious/assets/js/browser.min.js"),
        tags$script(src = "templated-industrious/assets/js/breakpoints.min.js"),
        tags$script(src = "templated-industrious/assets/js/util.js"),
        tags$script(src = "templated-industrious/assets/js/main.js")
      )
    ),
    fluidPage(
      task_modal
    )
  )
)
