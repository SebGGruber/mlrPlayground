modified_req = function(x){
  #' @description modified version of the req function
  #'   doesn't throw error if x equals FALSE
  #' @param x anything to check for
  # '!' doesn't work here because x can be anything
  if (!is.null(x) && x == FALSE)
    x
  else
    req(x)
}

values = reactiveValues(data = NULL, task = NULL, learner_1 = NULL, learner_2 = NULL)

# observer reactively modifying values$data based on relevant inputs
source("server/observe_for_data.R", local = TRUE)


# create task based on selected data
observe({
  data        = req(values$data)
  values$task = makeClassifTask(data = data, target = "class")
})


# create learner based on selected learner
observe({
  learner = req(input$learner_1)
  tryCatch({
    values$learner_1 = makeLearner(
      listLearners()$class[listLearners()$name == learner & listLearners()$type == input$tasktype]
    )},
    error = function(e) {
      content = paste(
        "Please install package(s):",
        paste(listLearners()$package[listLearners()$name == learner & listLearners()$type == input$tasktype], collapse = ", ")
      )
      createAlert(
        session, "learner_error", title = "Can't create learner!", content = content, append = FALSE
      )
    }
  )
})

# update learner based on selected parameters
observe({
  learner          = req(values$learner_1)
  values$learner_1 = {

    is_valid = sapply(learner$par.set$pars, function(par) par$has.default & par$tunable)
    names       = names(learner$par.set$pars)[is_valid]
    par.vals    = lapply(names,    function(par) modified_req(input[[paste0("parameter_", par, 1)]]))
    par.vals    = lapply(par.vals, function(val) if (is.character(val) & !is.na(as.integer(val))) as.integer(val) else val)
    names(par.vals) = names

    setHyperPars(learner, par.vals = par.vals)
  }
})

# create learner based on selected learner
observe({
  learner          = req(input$learner_2)
  tryCatch({
    values$learner_2 = makeLearner(
      listLearners()$class[listLearners()$name == learner & listLearners()$type == input$tasktype]
    )},
    error = function(e) {
      createAlert(
        session, "learner_error", title = "Can't create learner!", content = e, append = FALSE
      )
    }
  )
})

# update learner based on selected parameters
observe({
  learner          = req(values$learner_2)
  values$learner_2 = {

    is_valid = sapply(learner$par.set$pars, function(par) par$has.default & par$tunable)
    names       = names(learner$par.set$pars)[is_valid]
    par.vals    = lapply(names,    function(par) modified_req(input[[paste0("parameter_", par, 2)]]))
    par.vals    = lapply(par.vals, function(val) if (is.character(val) & !is.na(as.integer(val))) as.integer(val) else val)
    names(par.vals) = names

    setHyperPars(learner, par.vals = par.vals)
  }
})
