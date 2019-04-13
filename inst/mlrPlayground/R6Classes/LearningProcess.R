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
    learners = reactiveValues(
      "1"     = NULL,
      "2"     = NULL,
      choices = NULL
    ),
    # list of valid hyperparameter per learner
    params   = reactiveValues(
      "1" = NULL,
      "2" = NULL
    ),
    # resample instance, restample results for learner 1 and 2
    resample = reactiveValues(
      instance = NULL,
      "1" = NULL,
      "2" = NULL
    ),
    # task object, valid measures, task type
    task     = reactiveValues(
      object   = NULL,
      measures = NULL,
      type     = NULL
    ),
    pred     = list(
      "1" = reactiveValues(grid = NULL, test.set = NULL),
      "2" = reactiveValues(grid = NULL, test.set = NULL)
    ),
    # this may seem redundant, but is required so the prediction plots don't load
    # twice (once for learner init and once for parameters - we only want for parameters)
    updated_learners = reactiveValues("1" = NULL, "2" = NULL),


    # initialize new class instance
    initialize = function(
        valid_learners,
        learner_1          = NULL,
        learner_2          = NULL,
        params_1           = NULL,
        params_2           = NULL,
        data.set           = NULL,
        resampleInstance   = NULL,
        resampleResult_1   = NULL,
        resampleResult_2   = NULL,
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
      #' for this class; all arguments define values in the class instance
      #' @param valid.learners character vector of valid learner shortnames
      #' @param learner_1 mlr learner object
      #' @param learner_2 mlr learner object
      #' @param params_1 list of params for learner 1
      #' @param params_2 list of params for learner 2
      #' @param resampleInstance mlr object of a resample instance
      #' @param resampleResult_1 mlr object of the resample result for learner 1
      #' @param resampleResult_2 mlr object of the resample result for learner 2
      #' @param task mlr task object stored in the instance
      #' @param measures character vector of valid measures
      #' @param tasktype tasktype of the used class ("classif", "regr", "cluster")
      #' @param pred_1_grid grid predictions of learner 1
      #' @param pred_1_test test set predictions of learner 1
      #' @param pred_2_grid grid predicitions for learner 2
      #' @param pred_2_test test set predictions for learner 2
      #' @param updated_learners_1 Updated mlr learner 1
      #' @param updated_learners_2 Updated mlr learner 2
      #' @return NULL
      #'

      self$learners$"1"         = learner_1
      self$learners$"2"         = learner_2
      self$params$"1"           = params_1
      self$params$"2"           = params_2
      self$resample$instance    = resampleInstance
      self$resample$"1"         = resampleResult_1
      self$resample$"2"         = resampleResult_2
      self$task$object          = task
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

    setData = function(train.ratio) {
      #' @description Method for setting the resample instance
      #' Same method in a subclass setting the task
      #' (actually a really bad method name...)
      #' @param task mlr task
      #' @param train.ratio Ratio of #train/#all (Numeric between 0 and 1)
      #' @return NULL

      assert_that(train.ratio >= 0 && train.ratio <= 1)

      set.seed(123)
      task = self$task$object
      resin = makeResampleInstance("Holdout", split = train.ratio, task = task)

      self$resample$instance = resin
    },

    initLearner = function(short.name, i, type, prob = FALSE) {
      #' @description Initialize learner and its hyperparameters
      #' @param short.name String of learner short.name
      #' @param i Index of the learner in the list of stored learners
      #' @param type Type of learner and task (classif, regr, cluster)
      #' @param prob Should probability values be used as predictions? (Bool)
      #' DON'T SET THIS TO 'TRUE' FOR NON CLASSIF LEARNERS
      #' @return NULL

      # Must use string to index into reactivevalues
      i = as.character(i)
      assert_that(i %in% c("1", "2"))
      assert_that(type %in% c("classif", "regr", "cluster"))

      # get all mlr learners once
      listLearners = listLearners(warn.missing.packages = FALSE)

      # make learner based on selected shortname and task type
      learner = makeLearner({
        selected = listLearners$short.name == short.name & listLearners$type == type
        listLearners$class[selected]
      })

      # transform learner from hard classif to soft classif
      if (prob)
        learner = setPredictType(learner, "prob")

      ### DEFINE VALID HYPERPARAMETERS

      valid_types = c("integer", "numeric", "discrete", "logical")
      blacklist   =
        config$blacklist$param.name[config$blacklist$short.name == short.name]
      # only valid if param has default, is tunable, has type of
      # integer/numeric/discrete/logical and is not part of the blacklist
      is_valid    = sapply(
        learner$par.set$pars,
        function(par) par$has.default & par$tunable &
          par$type %in% valid_types & !(par$id %in% blacklist)
      )
      params      = learner$par.set$pars[is_valid]
      names       = names(learner$par.set$pars)[is_valid]
      # nameception
      names(params) = names

      self$params[[i]]   = params
      self$learners[[i]] = learner

      # no updated learner after init, except learner has no hyperparameters
      # (reason: "updateHyperparam" won't be triggered without hyperparameters)
      if (length(names) < 1)
        self$updated_learners[[i]] = learner
      else
        self$updated_learners[[i]] = NULL
    },

    calculateResample = function(i, measures) {
      #' @description Method for calculating resampling results for learner i
      #' once learner i is updated and task is loaded
      #' @param i Index of the learner/predictions in the list of learners/pred
      #' - only 1 and 2 are currently supported
      #' @return NULL

      # Must use string to index into reactivevalues
      i = as.character(i)

      # get all required instance attributes
      task        = isolate(self$task$object)
      learner     = isolate(self$updated_learners[[i]])
      resInstance = isolate(self$resample$instance)

      # most important function call of the whole backend
      self$resample[[i]] = resample(
        task       = task,
        learner    = learner,
        measures   = lapply(measures, get), # string -> function
        resampling = resInstance,
        models     = TRUE
      )

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

      # NA warnings about NAs, that are not there ... :(
      suppressWarnings({
        # sanity parsing for values disguised as characters
        par.vals = lapply(par.vals, function(val) if (is.character(val) & !is.na(as.integer(val))) as.integer(val) else val)
      })
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

