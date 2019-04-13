min_max_modals = function(parameter, i, learner) {
  #' @description Function for transforming a parameter into a modal
  #' This is the window that pops up when the "Min/Max" button in the
  #' parameter UI is pressed
  #' @param parameter mlr parameter object
  #' @param i index of the learner
  #' @param learner learner mlr object
  #' @return UI element or NULL if parameter is invalid for plotting

  # remove "." or tooltips wont work
  id = gsub("\\.", "", paste0(parameter$id, i, learner$id))
  param_df = config$param_df


  if (!parameter$has.default | !parameter$tunable) {
    # don't know what to do without default (yet) :(
    NULL

  } else if (parameter$type %in% c("integer", "numeric")) {

    mod_id = paste0("mod_", id)
    btn_id = paste0("btn_", id)
    min_id = paste0("min_", id)
    max_id = paste0("max_", id)

    min_value = {
      if (
        parameter$id %in% param_df$param.name[
          param_df$short.name == learner$short.name & !is.na(param_df$new.min)
          ]
      ) {
        param_df$new.min[param_df$short.name == learner$short.name & !is.na(param_df$new.min)]

      } else if (is.null(isolate(input[[min_id]]))) {
        parameter$default - 5 * abs(parameter$default)

      } else
        as.numeric(isolate(input[[min_id]]))
    }

    max_value = {
      if (
        parameter$id %in% param_df$param.name[
          param_df$short.name == learner$short.name & !is.na(param_df$new.max)
          ]
      ) {
        param_df$new.max[param_df$short.name == learner$short.name & !is.na(param_df$new.max)]
      } else if (is.null(isolate(input[[max_id]]))) {
        parameter$default + 5 * abs(parameter$default)
      } else
        as.numeric(isolate(input[[max_id]]))
    }

    # only allow input if no lower constraints are given
    minInput = {
      if (is.infinite(parameter$lower)){
        numericInput(min_id, "Parameter Min", min_value, width = "80%")
      } else {
        NULL
      }
    }

    # only allow input if no upper constraints are given
    maxInput = {
      if (is.infinite(parameter$upper)){
        numericInput(max_id, "Parameter Max", max_value, width = "80%")
      } else {
        NULL
      }
    }

    # finally the UI element
    bsModal(mod_id, "Set slider boundaries", btn_id, size = "small", fluidRow(column(
      10,
      minInput,
      maxInput
    )))

  } else {
    # return NULL in all other cases
    NULL
  }
}

parameter_to_ui = function(parameter, i, learner) {
  #' @description function for transforming a mlr parameter into an UI element
  #' @param parameter mlr parameter object
  #' @param i index of the learner
  #' @param learner learner mlr object
  #' @return UI element or NULL if parameter is invalid for plotting

  # remove "." or tooltips wont work
  id = gsub("\\.", "", paste0(parameter$id, i, learner$id))
  input_width    = 4
  helpText_width = 4
  param_df = config$param_df


  inp_id = paste0("parameter_", id)
  # get the label, but consider the config file
  label  = {
    if (
      parameter$id %in% param_df$param.name[
        param_df$short.name == learner$short.name & param_df$new.name != "NA"
      ]
    )
      param_df$new.name[param_df$short.name == learner$short.name]
    else
      parameter$id
  }

  # helpText column
  helpText_col = column(
    helpText_width,
    # align the helptext to the right side of the column
    helpText(label, style = "float:right;")
  )

  tooltip = {
    # use config tooltip if unequal "NA"
    if (
      parameter$id %in% param_df$param.name[
        param_df$short.name == learner$short.name & param_df$tooltip != "NA"
        ]
    )
      param_df$tooltip[param_df$short.name == learner$short.name]

    else {
      # helptext parsing (if not working, return unparsed text)
      text = gsub("\'", "\"", learner$help.list[[parameter$id]])
      text = strsplit(text, "\n\n")
      if (length(text) > 0 && length(text[[1]]) > 1) text[[1]][2]
      else learner$help.list[[parameter$id]]
    }
  }


  if (!parameter$has.default | !parameter$tunable) {
    # missing default values are difficult :(
    # also skip not tunable parameters
    NULL

  # NUMERIC PARAMETERS
  } else if (parameter$type %in% c("integer", "numeric")) {

    btn_id = paste0("btn_", id)
    min_id = paste0("min_", id)
    max_id = paste0("max_", id)
    step   = if (parameter$type == "integer") 1 else NULL

    # don't isolate here cause UI should change with min / max values
    min_bound =
      if (is.infinite(parameter$lower)) as.numeric(req(input[[min_id]])) else parameter$lower

    max_bound =
      if (is.infinite(parameter$upper)) as.numeric(req(input[[max_id]])) else parameter$upper

    default =
      if (is.null(isolate(input[[inp_id]]))) parameter$default else as.numeric(isolate(input[[inp_id]]))

    # UI element
    tags$p(
      helpText_col,
      column(
        input_width,
        sliderInput(
          inp_id, NULL, min_bound, max_bound, default, step = step
        )
      ),
      actionButton(btn_id, "Min/Max"),
      bsTooltip(inp_id, placement = "right", tooltip),
      bsTooltip(btn_id, placement = "right", "Adjust unconstrained minimum/maximum of slider!")
    )

    # DISCRETE PARAMETERS
  } else if (parameter$type == "discrete") {

    default =
      if (is.null(isolate(input[[inp_id]]))) parameter$default else isolate(input[[inp_id]])

    # UI element
    tags$p(
      helpText_col,
      column(
        input_width,
        selectInput(inp_id, NULL, parameter$values, default)
      ),
      br(),
      bsTooltip(inp_id, placement = "right", tooltip)
    )

    # LOGICAL PARAMETERS
  } else if (parameter$type == "logical") {

    default =
      if (is.null(isolate(input[[inp_id]]))) parameter$default else isolate(input[[inp_id]])

    # UI element
    tags$p(
      helpText_col,
      column(
        input_width,
        custom_checkboxInput(inp_id, NULL, default)
      ),
      br(),
      bsTooltip(inp_id, placement = "right", tooltip)
    )

  } else {
    # return NULL if parameter has a different type
    NULL
  }
}


# pop up modals for hyperparameters of learner 1
output$min_max_modals_1 = renderUI({

  # react to "process$learners" instead of "process$updated_learners
  # here, because we do only want
  # an execution when the learner changes - not its hyperparameters
  learner  = req(process$learners[["1"]])
  params   = req(process$params[["1"]])
  # calculate the min/max modals for every hyperparameter (non numerics return NULL)
  lapply(params, function(par) min_max_modals(par, 1, learner))
})


# pop up modals for hyperparameters of learner 2
output$min_max_modals_2 = renderUI({

  # react to "process$learners" instead of "process$updated_learners
  # here, because we do only want
  # an execution when the learner changes - not its hyperparameters
  learner  = req(process$learners[["2"]])
  params   = req(process$params[["2"]])
  # calculate the min/max modals for every hyperparameter (non numerics return NULL)
  lapply(params, function(par) min_max_modals(par, 2, learner))
})


# render parameter selections for learner 1 in the UI
output$dynamicParameters_1 = renderUI({

  # react to "process$learners" instead of "process$updated_learners
  # here, because we do only want
  # an execution when the learner changes - not its hyperparameters
  learner  = req(process$learners[["1"]])
  params   = req(process$params[["1"]])
  # sort parameter list by parameter type
  par_list = params[order(sapply(params, function(par) par$type))]
  # for each parameter
  ui_list  = lapply(par_list, function(par) parameter_to_ui(par, 1, learner))
  # compute (hidden) parameter panel
  conditionalPanel(
    paste0("output.showParam", 1, " == true"),
    fluidRow(
      br(),
      ui_list
    ),
    style = "overflow-y:scroll; overflow-x:hidden; max-height: 800px; min-height: 800px"
  )
})


# render parameter selections for learner 2 in the UI
output$dynamicParameters_2 = renderUI({

  # react to "process$learners" instead of "process$updated_learners
  # here, because we do only want
  # an execution when the learner changes - not its hyperparameters
  learner  = req(process$learners[["2"]])
  params   = req(process$params[["2"]])
  # sort parameter list by parameter type
  par_list = params[order(sapply(params, function(par) par$type))]
  # for each parameter
  ui_list  = lapply(par_list, function(par) parameter_to_ui(par, 2, learner))
  # compute (hidden) parameter panel
  conditionalPanel(
    paste0("output.showParam", 2, " == true"),
    fluidRow(
      br(),
      ui_list
    ),
    style = "overflow-y:scroll; overflow-x:hidden; max-height: 800px; min-height: 800px"
  )
})


# this observer is necessary for the min/max button + modal functionality
observe({
  # react to "process$learners" instead of "process$updated_learners
  # here, because we do only want
  # an execution when the learner changes - not its hyperparameters
  learner  = req(process$learners[["1"]])
  params   = req(process$params[["1"]])

  lapply(params, function(par) {
    if (par$type %in% c("integer", "numeric")) {
      # remove "." or tooltips wont work
      btn_id = gsub("\\.", "", paste0("btn_", par$id, 1, learner$id))
      mod_id = gsub("\\.", "", paste0("mod_", par$id, 1, learner$id))
      observeEvent(req(input[[btn_id]]), {
        toggleModal(session, mod_id, "open")
      })
    }
  })
})


# this observer is necessary for the min/max button + modal functionality
observe({
  # react to "process$learners" instead of "process$updated_learners
  # here, because we do only want
  # an execution when the learner changes - not its hyperparameters
  learner  = req(process$learners[["2"]])
  params   = req(process$params[["2"]])

  lapply(params, function(par) {
    if (par$type %in% c("integer", "numeric")) {
      # remove "." or tooltips wont work
      btn_id = gsub("\\.", "", paste0("btn_", par$id, 2, learner$id))
      mod_id = gsub("\\.", "", paste0("mod_", par$id, 2, learner$id))
      observeEvent(req(input[[btn_id]]), {
        toggleModal(session, mod_id, "open")
      })
    }
  })
})
