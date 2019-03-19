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
      return(NULL)
    },

    getPredPlot = function(i){
      # call "calculatePred" in here to recieve predictions for the plot
      return(NULL)
    },

    getDataPlot = function(){
      return(NULL)
    }
  ),

  private = list(
  )
)
