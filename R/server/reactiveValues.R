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

values = reactiveValues(data = NULL, learner_1 = NULL, learner_2 = NULL)

observe({

  task = req(input$task)
  seed = 123 # TODO
  set.seed(seed)

  values$data = {
    if (task == "Circle") {

      angle = runif(400, 0, 360)
      radius_class1 = rexp(200, 1)
      radius_class2 = rnorm(200, 16, 3)

      data.frame(
        x1 = sqrt(c(radius_class1, radius_class2)) * cos(2*pi*angle),
        x2 = sqrt(c(radius_class1, radius_class2)) * sin(2*pi*angle),
        class = c(rep("Class 1", 200), rep("Class 2", 200))
      )

    } else if (task == "XOR") {

      x1 = runif(400, -5, 5)
      x2 = runif(400, -5, 5)
      xor = (x1 < 0 | x2 < 0) & !(x1 < 0 & x2 < 0)
      class = ifelse(xor, "Class 1", "Class 2")

      data.frame(x1, x2, class)

    } else if (task == "Linear ascend (2D)") {

      x = rnorm(200, 0, 5)
      y = 0.5 * x + rnorm(200, 0, 1)

      data.frame(x, y)
    }
  }
})

# create learner based on selected learner
observe({
  learner          = req(input$learner_1)
  values$learner_1 = makeLearner(
    listLearners()$class[listLearners()$name == learner]
  )
})

# update learner based on selected parameters
observe({
  learner          = req(values$learner_1)
  values$learner_1 = {

    has_default = sapply(learner$par.set$pars, function(par) par$has.default)
    names       = names(learner$par.set$pars)[has_default]
    par.vals    = lapply(names,    function(par) modified_req(input[[paste0("parameter_", par, 1)]]))
    par.vals    = lapply(par.vals, function(val) if (is.character(val) & !is.na(as.integer(val))) as.integer(val) else val)
    names(par.vals) = names
    #browser()

    setHyperPars(learner, par.vals = par.vals)
  }
})

# create learner based on selected learner
observe({
  learner          = req(input$learner_2)
  values$learner_2 = makeLearner(
    listLearners()$class[listLearners()$name == learner]
  )
})

# update learner based on selected parameters
observe({
  learner          = req(values$learner_2)
  values$learner_2 = {

    has_default = sapply(learner$par.set$pars, function(par) par$has.default)
    names       = names(learner$par.set$pars)[has_default]
    par.vals    = lapply(names,    function(par) modified_req(input[[paste0("parameter_", par, 2)]]))
    par.vals    = lapply(par.vals, function(val) if (is.character(val) & !is.na(as.integer(val))) as.integer(val) else val)
    names(par.vals) = names

    setHyperPars(learner, par.vals = par.vals)
  }
})
