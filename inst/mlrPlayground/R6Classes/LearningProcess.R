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
    data     = reactiveValues(train.set = NULL,  test.set = NULL),
    task     = reactiveValues(train = NULL, measures = NULL, type = NULL),
    pred     = reactiveValues(grid = NULL, test.set = NULL),

    initialize = function() {
      shortnames = listLearners()$short.name[
        listLearners()$type       ==   self$task$type
        & listLearners()$short.name %in% valid_learners
        ]
      names = listLearners()$name[
        listLearners()$type       ==   self$task$type
        & listLearners()$short.name %in% valid_learners
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

    initLearner = function(short.name, i, type) {
      #' @param short.name String of learner short.name
      #' @param i Index of the learner in the list of stored learners
      #' @param type Type of learner and task (classif, regr, cluster)

      assert_that(type %in% c("classif", "regr", "cluster"))

      # Must use string to index into reactivevalues
      i = as.character(i)

      self$learners[[i]] = makeLearner({
        selected = listLearners()$short.name == short.name & listLearners()$type == type
        listLearners()$class[selected]
      })
    },

    calculatePred = function(i) {
      #' @description Method for calculating and setting process predictions i
      #' once learner i and task are loaded
      #' @param i Index of the learner/predictions in the list of learners/pred
      #' - only 1 and 2 are currently supported
      #' @return named list of shape list(<<learner i>>, <<trained model>>)

      learner = self$learners[[i]]
      model   = train(learner, self$task$train)

      # calculate test.set predictions
      test.set = predict(model, newdata = self$data$test.set)
      self$pred[[i]]$test.set = test.set

      # return learner and trained model
      return(list(learner = learner, model = model))
    },

    getPredPlot = function(i){
      return(NULL)
    },

    getDataPlot = function(){
      return(NULL)
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
#  "timepredict", "multilabel.ppv", "logloss",
#  "cindex.uno", "multilabel.f1",
#  "multiclass.au1p", "multilabel.acc", "silhouette", "fdr",
#  "kappa", "cindex", "gpr"
#)

