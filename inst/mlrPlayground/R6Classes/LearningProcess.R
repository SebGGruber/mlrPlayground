#' @title LearningProcess
#' @format \code{\link{R6Class}} object
#' @description
#' An abstract \code{\link{R6Class}} to represent an learning process (dataset, task, learners, predictions)
#' @section Methods:
#' \describe{
#'   \item{learn(iter)}{[\code{function}] \cr todo}
#'   \item{plotPerf()}{[\code{function}] \cr todo}
#' }
#' @return [\code{\link{LearningProcess}}].

LearningProcess = R6Class(
  classname = "LearningProcess",

  public = list(
    # currently only 2 learners are supported
    # element names are mandatory
    # "choices" is the list of selectable learners in the UI
    learners = reactiveValues("1" = NULL, "2" = NULL, choices = NULL),
    # list of valid hyperparameter per learner
    params   = reactiveValues("1" = NULL, "2" = NULL),
    data     = reactiveValues(train.set = NULL,  test.set = NULL),
    task     = reactiveValues(train = NULL, measures = NULL, type = NULL),
    pred     = list(
      "1" = reactiveValues(grid = NULL, test.set = NULL),
      "2" = reactiveValues(grid = NULL, test.set = NULL)
    ),
    # this may seem redundant, but is required so the prediction plots don't load
    # twice (once for learner init and once for parameters - we only want for parameters)
    updated_learners = reactiveValues("1" = NULL, "2" = NULL),


    initialize = function(
        valid_learners,
        learner_1          = NULL,
        learner_2          = NULL,
        params_1           = NULL,
        params_2           = NULL,
        train_set          = NULL,
        test_set           = NULL,
        task               = NULL,
        measures           = NULL,
        tasktype           = NULL,
        pred_1_grid        = NULL,
        pred_1_test        = NULL,
        pred_2_grid        = NULL,
        pred_2_test        = NULL,
        updated_learners_1 = NULL,
        updated_learners_2 = NULL
      ) {
      #' @description Initialize new class instance and define valid learners
      #' for this class
      #' @param valid.learners character vector of valid learner shortnames
      #' @return NULL
      #'

      self$learners$"1"         = learner_1
      self$learners$"2"         = learner_2
      self$params$"1"           = params_1
      self$params$"2"           = params_2
      self$data$train.set       = train_set
      self$data$test.set        = test_set
      self$task$train           = task
      self$task$measures        = measures
      self$task$type            = tasktype
      self$pred$"1"$grid        = pred_1_grid
      self$pred$"1"$test.set    = pred_1_test
      self$pred$"2"$grid        = pred_2_grid
      self$pred$"2"$test.set    = pred_2_test
      self$updated_learners$"1" = updated_learners_1
      self$updated_learners$"2" = updated_learners_2

      # learner choices from here on
      tasktype = isolate(self$task$type)
      listLearners = listLearners(warn.missing.packages = FALSE)
      shortnames = listLearners$short.name[
        listLearners$type       ==   tasktype
        & listLearners$short.name %in% valid_learners
        ]
      names = listLearners$name[
        listLearners$type       ==   tasktype
        & listLearners$short.name %in% valid_learners
        ]

      choices                = as.list(c("", shortnames))
      names(choices)         = c("Choose", names)

      self$learners$choices = choices
    },

    setData = function(data, train.ratio) {
      #' @param data Dataframe
      #' @param train.ratio Ratio of #train/#all (Numeric between 0 and 1)

      assert_that(train.ratio >= 0 && train.ratio <= 1)

      set.seed(123)
      n      = nrow(data)
      sample = sample(n, train.ratio * n)

      self$data$train.set = data[ sample, ]
      self$data$test.set  = data[-sample, ]
    },

    initLearner = function(short.name, i, type, prob = FALSE) {
      #' @description Initialize learner and its hyperparameters
      #' @param short.name String of learner short.name
      #' @param i Index of the learner in the list of stored learners
      #' @param type Type of learner and task (classif, regr, cluster)
      #' @param prob Should probability values be used as predictions? (Bool)
      #' DON'T SET THIS TO 'TRUE' FOR NON CLASSIF LEARNERS

      # Must use string to index into reactivevalues
      i = as.character(i)
      assert_that(i %in% c("1", "2"))
      assert_that(type %in% c("classif", "regr", "cluster"))

      listLearners = listLearners()

      learner = makeLearner({
        selected = listLearners$short.name == short.name & listLearners$type == type
        listLearners$class[selected]
      })

      # transform learner from hard classif to soft classif
      if (prob)
        learner = setPredictType(learner, "prob")

      valid_types = c("integer", "numeric", "discrete", "logical")
      # only valid if param has default, is tunable and has type of integer/numeric/discrete/logical
      is_valid    = sapply(
        learner$par.set$pars,
        function(par) par$has.default & par$tunable & par$type %in% valid_types
      )
      names       = names(learner$par.set$pars)[is_valid]
      # nameception
      names(names) = names

      # remove this once cluster works
      #browser()
      #if (self$task$type == "cluster") names = list()

      self$params[[i]]           = names
      self$learners[[i]]         = learner

      # no updated learner after init, except learner has no hyperparameters
      # (reason: "updateHyperparam" won't be triggered without hyperparameters)
      if (length(names) < 1)
        self$updated_learners[[i]] = learner
      else
        self$updated_learners[[i]] = NULL
    },

    calculatePred = function(i) {
      #' @description Method for calculating and setting process predictions i
      #' once learner i is updated and task is loaded
      #' @param i Index of the learner/predictions in the list of learners/pred
      #' - only 1 and 2 are currently supported
      #' @return named list of shape list(<<learner i>>, <<trained model>>)

      # Must use string to index into reactivevalues
      i = as.character(i)

      learner = isolate(self$updated_learners[[i]])
      model   = train(learner, isolate(self$task$train))

      # calculate test.set predictions
      test.set = predict(model, newdata = isolate(self$data$test.set))
      self$pred[[i]]$test.set = test.set

      # return learner and trained model
      return(list(learner = learner, model = model))
    },

    getPredPlot = function(i) {
      return(NULL)
    },

    getDataPlot = function() {
      return(NULL)
    },


    updateHyperparam = function(par.vals, i) {
      #' @description Method for updating a learner with the given hyperparemeter values
      #' @param par.vals Named list with values of the hyperparameters to update
      #' @param i Index of the target learner
      #' @return NULL

      # Must use string to index into reactivevalues
      i = as.character(i)
      assert_that(i %in% c("1", "2"))

      # choose init learner if there's no updated learner yet
      learner = {
        if (is.null(isolate(self$updated_learners[[i]])))
          self$learners[[i]]
        else
          self$updated_learners[[i]]
      }

      # sanity parsing for values disguised as characters
      par.vals = lapply(par.vals, function(val) if (is.character(val) & !is.na(as.integer(val))) as.integer(val) else val)
      self$updated_learners[[i]] = setHyperPars(learner, par.vals = par.vals)
    }
  ),

  private = list(
  )
)

# list of all remaining measures
#c(
#  "iauc.uno", "featperc", "multilabel.tpr",
#  "ibrier", "multilabel.hamloss", "mcc",
#  "mcp", "lsr",
#  "multilabel.subset01", "meancosts", "timeboth", "timetrain",
#  "timepredict", "multilabel.ppv",
#  "cindex.uno", "multilabel.f1",
#  "multiclass.au1p", "multilabel.acc", "silhouette", "fdr",
#  "kappa", "cindex", "gpr"
#)

