#make_parameter_ui = function(learner){
#  lapply(learner$par.set$pars,
parameter_to_ui = function(parameter, learner_id) {

  id = paste0(parameter$id, learner_id)

  if (!parameter$has.default) {
    # don't know what to do without default (yet) :(
    NULL

  } else if (parameter$type %in% c("integer", "numeric")) {

    inp_id = paste0("parameter_", id)
    label  = parameter$id #paste( "Set",        parameter$id)
    mod_id = paste0("mod_",       id)
    btn_id = paste0("btn_",       id)
    min_id = paste0("min_",       id)
    max_id = paste0("max_",       id)
    step   = if (parameter$type == "integer") 1 else NULL

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

    fluidRow(
      column(3, helpText(label)),
      column(4, sliderInput(
        inp_id, NULL, as.integer(input[[min_id]]), as.numeric(input[[max_id]]), parameter$default, step = step
      )),
      actionButton(btn_id, "Min/Max"),
      bsModal(mod_id, "Set slider boundaries", btn_id, size = "small", fluidRow(
        numericInput(min_id, "Parameter Min", min_value),
        numericInput(max_id, "Parameter Max", max_value)
      ))
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
  }
}

output$dynamicParameters = renderUI({

  req(learner_amount_enum())
  # for each learner
  lapply(learner_amount_enum(), function(i) {
    # setup dummy learner to get parameter list
    lrn_name = input[[paste0("learner", i)]]
    learner_mlr = makeLearner(listLearners()$class[listLearners()$name == lrn_name])
    # sort parameter list by parameter type
    par_list = learner_mlr$par.set$pars[order(sapply(learner_mlr$par.set$pars, function(par) par$type))]
    ui_list  = lapply(par_list, function(par) parameter_to_ui(par, i))
    # indeces of first half
#    split_index1 = 1:round(length(ui_list)/3)
    ui_split = split(ui_list, cut(seq_along(ui_list), 3, labels = FALSE))
    # compute (hidden) parameter panel
    conditionalPanel(
      paste0("output.showParam", i, " == true"),
      fluidRow(
        # split into two columns
        column(4, ui_split[[1]]),
        column(4, ui_split[[2]]),
        column(4, ui_split[[3]])
      ),
      style = "overflow-y:scroll; overflow-x:hidden; max-height: 400px"
    )
  })
})

# force loading even when hidden
outputOptions(output, "dynamicParameters", suspendWhenHidden = FALSE)
