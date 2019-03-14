modified_req = function(x){
  #' @description modified version of the req function
  #' doesn't throw error if x equals FALSE
  #' @param x anything to check for
  # '!' doesn't work here because x can be anything
  #' @return input
  if (!is.null(x) && x == FALSE)
    x
  else
    req(x)
}

create_learner = function(i) {
  #
  name    = paste0("learner_", i)
  learner = req(input[[name]])
#  tryCatch({
#  browser()
    values[[name]] = makeLearner(
      listLearners()$class[listLearners()$short.name == learner & listLearners()$type == input$tasktype]
    )#},
    #error = function(e) {
    #  content = paste(
    #    "Please install package(s):",
    #    paste(listLearners()$package[listLearners()$name == learner & listLearners()$type == input$tasktype], collapse = ", ")
    #  )
    #  createAlert(
    #    session, "learner_error", title = "Can't create learner!", content = content, append = FALSE
    #  )
    #}
  #)
}

update_hyperparameters = function(learner, i){
  #' @description Function updating hyperparameters reactively of a learner given index i
  #' @param i Index of the learner to update
  #' @return mlr learner object
  is_valid = sapply(learner$par.set$pars, function(par) par$has.default & par$tunable)
  names       = names(learner$par.set$pars)[is_valid]
  par.vals    = lapply(names,    function(par) modified_req(input[[paste0("parameter_", par, i)]]))
  par.vals    = lapply(par.vals, function(val) if (is.character(val) & !is.na(as.integer(val))) as.integer(val) else val)
  names(par.vals) = names

  setHyperPars(learner, par.vals = par.vals)
}


values = reactiveValues(data = NULL, task = NULL, learner_1 = NULL, learner_2 = NULL, learner_choices = NULL)

# observer modifying reactively values$data based on relevant inputs
source("server/observe_for_data.R", local = TRUE)


# create task based on selected data
observe({
  data        = req(values$data)
  values$task = makeClassifTask(data = data, target = "class")
})


# create learner 1 based on selected learner
observe({
  create_learner(1)
})

# update learner 1 based on selected parameters
observe({
  learner          = req(values$learner_1)
  values$learner_1 = update_hyperparameters(learner, 1)
})

# create learner 2 based on selected learner
observe({
  create_learner(2)
})

# update learner 2 based on selected parameters
observe({
  learner          = req(values$learner_2)
  values$learner_2 = update_hyperparameters(learner, 2)
})
