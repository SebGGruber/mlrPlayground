#make_parameter_ui = function(learner){
#  lapply(learner$par.set$pars,
parameter_to_ui = function(parameter, learner_id) {

  id = paste0(parameter$id, learner_id)

  if (!parameter$has.default) {
    # don't know what to do without default (yet) :(
    NULL

  } else if (parameter$type %in% c("integer", "numeric")) {

    inp_id = paste0("parameter_", id)
    label  = paste( "Set",        id)
    min_id = paste0("min_",       id)
    max_id = paste0("max_",       id)
    round  = if (parameter$type == "integer") TRUE else FALSE

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
      column(3, sliderInput(
        inp_id, label, as.integer(input[[min_id]]), as.integer(input[[max_id]]), as.integer(parameter$default), round = round
      )),
      column(1, numericInput(min_id, "Min", min_value)),
      column(1, numericInput(max_id, "Max", max_value))
    )

  } else if (parameter$type == "discrete") {

    inp_id = paste0("parameter_", id)
    label  = paste( "Set",        id)
    selectInput(inp_id, label, parameter$values, parameter$default)

  } else if (parameter$type == "logical") {

    inp_id = paste0("parameter_", id)
    label  = paste( "Set",        id)
    checkboxInput(inp_id, label, parameter$default)

  }
}

output$dynamicParameters = renderUI({

  req(learner_amount_enum())
  # for each learner
  lapply(learner_amount_enum(), function(i) {
    # setup dummy learner to get parameter list
    lrn_name = input[[paste0("learner", i)]]
    learner_mlr = makeLearner(listLearners()$class[listLearners()$name == lrn_name])

    # compute (hidden) parameter panel
    conditionalPanel(
      paste0("output.showParam", i, " == true"),
      lapply(learner_mlr$par.set$pars, function(par) parameter_to_ui(par, i))
    )
  })
})
