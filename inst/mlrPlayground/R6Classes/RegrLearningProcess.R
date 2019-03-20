RegrLearningProcess = R6Class(
  classname = "RegrLearningProcess",
  inherit = LearningProcess,

  public = list(

    initialize = function(valid.learners) {
      self$task$measures = c(
        "mae", "mape", "medse", "msle", "rae", "spearmanrho", "rmsle", "medae", "sse", "expvar",
        "kendalltau", "rmse", "mse", "rrse", "rsq", "sae", "arsq"
      )
      self$task$type = "regr"
      super$initialize(valid.learners)

    },

    setData = function(data, train.ratio) {
      super$setData(data, train.ratio)
      #browser()
      self$task$train = makeRegrTask(data = self$data$train.set, target = "y")
    },

    initLearner = function(short.name, i) {
      super$initLearner(short.name, i, "regr")
    },

    getDataPlot = function() {
      #' @description Method transforming the data into an interactive plot
      #' @return plotly plot object
      plotly::plot_ly(
        data = self$data$train.set,
        x    = ~x,
        y    = ~y,
        type = "scatter",
        mode = "markers"
      )
    },

    calculatePred = function(i) {
      #' @description Method for calculating equidistant predictions in a 2D box
      #' @param i Index of the learner in self$learners to calculate the
      #' predictions for
      #' @return list(x = <<x-coordinates>>, y = <<predictions>>)

      # Must use string to index into reactivevalues
      i = as.character(i)

      trained = super$calculatePred(i)

      grid    = expand.grid(x = -50:50 / 10)
      grid$y  = predictLearner(trained$learner, trained$model, grid)

      self$pred[[i]]$grid = grid

      return(trained)
    },

    getPredPlot = function(i) {
      #' @description Method to recieve prediction surface of a trained learner
      #' as an interactive plot
      #' @param i Index of the learner in self$learners to return the
      #' predictions plot for
      #' @return plotly plot object

      # Must use string to index into reactivevalues
      i = as.character(i)

      pred = self$pred[[i]]$grid

      plotly::plot_ly(
        data = self$data$train.set,
        x = ~x,
        y = ~y,
        #        color = ~class,
        #        colors = c("#2b8cbe", "#e34a33", "#2b8cbe", "#e34a33"),
        type = "scatter",
        mode = "markers"
      ) %>%
        plotly::add_trace(
          x = ~pred$x,
          y = ~pred$y,
          name = 'trace 1',
          mode = 'lines',
          #        colors = colorRamp(c("red", "blue")),
          #        opacity = 0.2,
          showscale = FALSE

        ) %>%
        plotly::layout(xaxis = list(title = ""), yaxis = list(title = ""))
    }
  ),

  private = list()
)
