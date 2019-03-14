min_max_modals = function(parameter, i, learner) {

  id = paste0(parameter$id, i)

  if (!parameter$has.default | !parameter$tunable) {
    # don't know what to do without default (yet) :(
    NULL

  } else if (parameter$type %in% c("integer", "numeric")) {

    mod_id = paste0("mod_", id)
    btn_id = paste0("btn_", id)
    min_id = paste0("min_", id)
    max_id = paste0("max_", id)

    min_value = {
      if (is.infinite(parameter$lower)){
        if (
          parameter$id %in% param_df$param.name[
            param_df$short.name == learner$short.name & !is.na(param_df$new.min)
            ]
        )
          param_df$new.min[param_df$short.name == learner$short.name & !is.na(param_df$new.min)]
        else
          parameter$default - 2 * abs(parameter$default)
      } else {
        parameter$lower
      }
    }

    max_value = {
      if (is.infinite(parameter$upper)){
        #browser()
        if (
          parameter$id %in% param_df$param.name[
            param_df$short.name == learner$short.name & !is.na(param_df$new.max)
          ]
        )
          param_df$new.max[param_df$short.name == learner$short.name & !is.na(param_df$new.max)]
        else
          parameter$default + 2 * abs(parameter$default)
      } else {
        parameter$upper
      }
    }

    bsModal(mod_id, "Set slider boundaries", btn_id, size = "small", fluidRow(
      numericInput(min_id, "Parameter Min", min_value, width = "80%"),
      numericInput(max_id, "Parameter Max", max_value, width = "80%")
    ))

  } else {
    NULL
  }
}

parameter_to_ui = function(parameter, i, learner) {

  id = paste0(parameter$id, i)
  input_width    = 4

  inp_id = paste0("parameter_", id)
  label  = {
    lrn = paste0("learner_", i)
    if (
      parameter$id %in% param_df$param.name[
        param_df$short.name == learner$short.name & param_df$new.name != "NA"
      ]
    )
      param_df$new.name[param_df$short.name == learner$short.name]
    else
      parameter$id
  }
  helpText_col = column(
    4,
    # align the helptext to the right side of the column
    helpText(label, style = "float:right;")
  )

  if (!parameter$has.default | !parameter$tunable) {
    # don't know what to do without default (yet) :(
    NULL

  } else if (parameter$type %in% c("integer", "numeric")) {

    btn_id = paste0("btn_",       id)
    min_id = paste0("min_",       id)
    max_id = paste0("max_",       id)
    step   = if (parameter$type == "integer") 1 else NULL

    fluidRow(
      helpText_col,
      column(
        input_width,
        sliderInput(
          inp_id, NULL, as.integer(input[[min_id]]), as.numeric(input[[max_id]]), parameter$default, step = step
        )
      ),
      actionButton(btn_id, "Min/Max")
    )

  } else if (parameter$type == "discrete") {

    fluidRow(
      helpText_col,
      column(
        input_width,
        selectInput(inp_id, NULL, parameter$values, parameter$default)
      )
    )

  } else if (parameter$type == "logical") {

    fluidRow(
      helpText_col,
      column(
        input_width,
        checkboxInput(inp_id, NULL, parameter$default)
      )
    )

  } else {
    NULL
  }
}

# render bsModals for the min/max values of each slider
output$min_max_modals = renderUI({

  req(learner_amount_enum())
  # for each learner
  lapply(learner_amount_enum(), function(i) {

    lrn = paste0("learner_", i)
    # react to "input" instead of "values" here, because we do only want
    # an execution when the learner name changes - not its hyperparameters
    req(input[[lrn]])
    learner = req(isolate(values[[lrn]]))
#browser()
    lapply(learner$par.set$pars, function(par) min_max_modals(par, i, learner))
  })
})


output$dynamicParameters = renderUI({

  req(learner_amount_enum())
  # for each learner
  lapply(learner_amount_enum(), function(i) {

    lrn = paste0("learner_", i)
    # react to "input" instead of "values" here, because we do only want
    # an execution when the learner name changes - not its hyperparameters
    req(input[[lrn]])
    learner = req(isolate(values[[lrn]]))
    # sort parameter list by parameter type
    par_list = learner$par.set$pars[order(sapply(learner$par.set$pars, function(par) par$type))]
    # for each parameter
    ui_list  = lapply(par_list, function(par) parameter_to_ui(par, i, learner))
    ui_split = {
      # if there are more than 2 parameters, split the UI into 3 columns
      if (length(ui_list) > 4)
        split(ui_list, cut(seq_along(ui_list), 2, labels = FALSE))
      else
        list(ui_list, NULL)
    }
    # compute (hidden) parameter panel
    conditionalPanel(
      paste0("output.showParam", i, " == true"),
      fluidRow(
        # split into two columns
        column(6, ui_split[[1]]),
        column(6, ui_split[[2]])
      ),
      style = "overflow-y:scroll; overflow-x:hidden; max-height: 800px; min-height: 800px"
    )
  })
})

# force loading even when hidden
outputOptions(output, "min_max_modals", suspendWhenHidden = FALSE)
