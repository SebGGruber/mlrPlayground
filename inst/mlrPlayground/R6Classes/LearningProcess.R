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
    learners = reactiveValues("1" = NULL, "2" = NULL),
    data     = reactiveValues(train.set = NULL,  test.set = NULL),
    task     = reactiveValues(train = NULL), # reactiveVal seems to be buggy with R6
    pred     = reactiveValues(grid = NULL, test.set = NULL),
    measures = NULL,

    initialize = function() {
      return(NULL)
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
      #' @param short.name Character of learner short.name
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

      learner = self$learners[[i]]
      model   = train(learner, self$task$train)

      # calculate test.set predictions
      # remove target column (last one)
      test.set = predictLearner(
        learner, model, self$data$test.set[-ncol(self$data$test.set)]
      )
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
