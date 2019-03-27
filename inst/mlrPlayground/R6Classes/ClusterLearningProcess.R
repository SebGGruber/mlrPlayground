ClusterLearningProcess = R6Class(
  classname = "ClusterLearningProcess",
  inherit = LearningProcess,

  public = list(

    initialize = function(valid.learners) {
      self$task$measures = c(
        "db", "dunn", "G1", "G2"
      )
      self$task$type = "cluster"
      super$initialize(valid.learners)

    },

    setData = function(data, train.ratio) {
      super$setData(data, train.ratio)
      self$task$train = makeClusterTask(data = self$data$train.set)
    },

    initLearner = function(short.name, i) {
      super$initLearner(short.name, i, "cluster")
    },

    getDataPlot = function() {
      #' @description Method transforming the data into an interactive plot
      #' @return plotly plot object

      plotly::plot_ly(
        data   = self$data$train.set,
        x      = ~x,
        y      = ~y,
        type   = "scatter",
        mode   = "markers"
      )%>%
      plotly::add_trace(
        data   = self$data$test.set,
        name   = "Test",
        x      = ~x,
        y      = ~y,
        type   = "scatter",
        mode   = "markers"
        )
    },

    calculatePred = function(i) {
      #' @description Method for calculating equidistant predictions in a 2D box
      #' @param i Index of the learner in self$learners to calculate the
      #' predictions for
      #' @return list(x = <<x-coordinates>>, y = <<predictions>>)

      assert_that(i %in% 1:2)
      # Must use string to index into reactivevalues
      i = as.character(i)

      trained = super$calculatePred(i)

      grid    = expand.grid(x = -50:50 / 10, y = -50:50 / 10)

      predictions = predictLearner(trained$learner, trained$model, grid)
      grid$z      = as.numeric(factor(predictions))

      self$pred[[i]]$grid = grid
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
        data    = self$data$train.set,
        name    = "Train",
        x       = ~x,
        y       = ~y,
        colors  = c("#2b8cbe", "#e34a33", "#2b8cbe", "#e34a33"),
        symbol  = I("x"),
        type    = "scatter",
        mode    = "markers"
      ) %>%
      plotly::add_trace(
        data    = self$data$test.set,
        name    = "Test",
        x       = ~x,
        y       = ~y,
        colors  = c("#2b8cbe", "#e34a33"),
        symbol  = I('o'),
        type    = "scatter",
        mode    = "markers"
        )%>%
        plotly::add_trace(
          x         = ~unique(pred$x),
          y         = ~unique(pred$y),
          z         = ~matrix(pred$z, nrow = sqrt(length(pred$z)), byrow = TRUE),
          type      = "heatmap",
          colors    = colorRamp(c("blue","red")),
          opacity   = 0.2,
          hoverinfo = "x+y+skip",
          showscale = FALSE
        ) %>%
        plotly::layout(xaxis = list(title = "X"), yaxis = list(title = "Y"))
    }
  ),

  private = list()
)