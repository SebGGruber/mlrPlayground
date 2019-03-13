min_max_modals = function(parameter, learner_id) {

  id = paste0(parameter$id, learner_id)

  if (!parameter$has.default | !parameter$tunable) {
    # don't know what to do without default (yet) :(
    NULL

  } else if (parameter$type %in% c("integer", "numeric")) {

    mod_id = paste0("mod_",       id)
    btn_id = paste0("btn_",       id)
    min_id = paste0("min_",       id)
    max_id = paste0("max_",       id)

    min_value = {
      if (is.infinite(parameter$lower))
        parameter$default - 2 * abs(parameter$default)
      else
        parameter$lower
    }

    max_value = {
      if (is.infinite(parameter$upper))
        parameter$default + abs(parameter$default)
      else
        parameter$upper
    }

    bsModal(mod_id, "Set slider boundaries", btn_id, size = "small", fluidRow(
      numericInput(min_id, "Parameter Min", min_value, width = "80%"),
      numericInput(max_id, "Parameter Max", max_value, width = "80%")
    ))

  } else {
    NULL
  }
}

parameter_to_ui = function(parameter, learner_id) {

  id = paste0(parameter$id, learner_id)

  if (!parameter$has.default | !parameter$tunable) {
    # don't know what to do without default (yet) :(
    NULL

  } else if (parameter$type %in% c("integer", "numeric")) {

    inp_id = paste0("parameter_", id)
    label  = parameter$id #paste( "Set",        parameter$id)
    btn_id = paste0("btn_",       id)
    min_id = paste0("min_",       id)
    max_id = paste0("max_",       id)
    step   = if (parameter$type == "integer") 1 else NULL

    fluidRow(
      column(3, helpText(label)),
      column(4, sliderInput(
        inp_id, NULL, as.integer(input[[min_id]]), as.numeric(input[[max_id]]), parameter$default, step = step
      )),
      actionButton(btn_id, "Min/Max")
    )

  } else if (parameter$type == "discrete") {

    inp_id = paste0("parameter_", id)
    label  = parameter$id #paste( "Set", parameter$id)
    fluidRow(
      column(3, helpText(label)),
      column(4, selectInput(inp_id, NULL, parameter$values, parameter$default))
    )

  } else if (parameter$type == "logical") {

    inp_id = paste0("parameter_", id)
    label  = parameter$id #paste( "Set", parameter$id)
    fluidRow(
      column(3, helpText(label)),
      column(4, checkboxInput(inp_id, NULL, parameter$default))
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

    name = paste0("learner_", i)
    # react to "input" instead of "values" here, because we do only want
    # an execution when the learner name changes - not its hyperparameters
    req(input[[name]])
    learner = req(isolate(values[[name]]))
#browser()
    lapply(learner$par.set$pars, function(par) min_max_modals(par, i))
  })
})


output$dynamicParameters = renderUI({

  req(learner_amount_enum())
  # for each learner
  lapply(learner_amount_enum(), function(i) {

    name = paste0("learner_", i)
    # react to "input" instead of "values" here, because we do only want
    # an execution when the learner name changes - not its hyperparameters
    req(input[[name]])
    learner = req(isolate(values[[name]]))
    # sort parameter list by parameter type
    par_list = learner$par.set$pars[order(sapply(learner$par.set$pars, function(par) par$type))]
    # for each parameter
    ui_list  = lapply(par_list, function(par) parameter_to_ui(par, i))
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
