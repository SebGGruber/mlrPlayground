source("ui/learner_panel.R",   local = TRUE) # importing: learner_panel
source("ui/parameter_panel.R", local = TRUE) # importing: parameter_panel
source("ui/task_modal.R",      local = TRUE) # importing: task_modal
source("ui/plots_tabset.R",    local = TRUE) # importing: plots_tabset


shinyUI(
  basicPage(
    column(
      6,
      learner_panel,
      parameter_panel,
      task_modal
    ),
    column(
      6,
      plots_tabset
    )
  )
)
