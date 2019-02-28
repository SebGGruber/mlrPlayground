#make_parameter_ui = function(learner){
#  lapply(learner$par.set$pars,
parameter_to_ui = function(parameter) {

  if (!parameter$has.default) {
    # don't know what to do without default :(
    NULL

  } else if (parameter$type %in% c("integer", "numeric")) {

    id     = paste0("parameter_", parameter$id)
    label  = paste( "Set",        parameter$id)
    min_id = paste0("min_",       parameter$id)
    max_id = paste0("max_",       parameter$id)
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
        id, label, input[[min_id]], input[[max_id]], parameter$default, round = round
      )),
      column(1, numericInput(min_id, "Min", min_value)),
      column(1, numericInput(max_id, "Max", max_value))
    )

  } else if (parameter$type == "discrete") {

    id     = paste0("parameter_", parameter$id)
    label  = paste( "Set",        parameter$id)
    selectInput(id, label, parameter$values, parameter$default)

  } else if (parameter$type == "logical") {

    id     = paste0("parameter_", parameter$id)
    label  = paste( "Set",        parameter$id)
    checkboxInput(id, label, parameter$default)

  }
}

output$dynamicParameters = renderUI({

  lapply(learner_amount_enum(), function(i) {
    conditionalPanel(
      paste0("output.showParam", i, " == false"),
      lapply({

      })

      fluidRow(
        column(3, sliderInput("param1", "Set Parameter1", 0, 10, 5)),
        column(1, numericInput("minparam1", "Min", 0)),
        column(1, numericInput("maxparam1", "Max", 10))
      )
    )
  })
})
