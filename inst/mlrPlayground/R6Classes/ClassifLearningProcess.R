ClassifLearningProcess = R6Class(
  classname = "ClassifLearningProcess",
  inherit = LearningProcess,

  public = list(

    setData = function(data, train.ratio) {
      super$setData(data, train.ratio)
      self$task$train = makeClassifTask(data = self$data$train.set, target = "class")
    },

    initLearner = function(short.name, i) {
      super$initLearner(short.name, i, "classif")
    },

    getDataPlot = function() {
      #' @description Method transforming the data into an interactive plot
      #' @return plotly plot object
      plotly::plot_ly(
        data   = self$data$train.set,
        x      = ~x1,
        y      = ~x2,
        color  = ~class,
        colors = c("#2b8cbe", "#e34a33"),
        type   = "scatter",
        mode   = "markers"
      )
    },

    calculatePred = function(i) {
      #' @description Method for calculating equidistant predictions in a 2D box
      #' @param i Index of the learner in self$learners to calculate the
      #' predictions for
      #' @return list(x1 = <<x1-coordinates>>, x2 = <<x2-coordinates>>,
      #'  pred_matrix = <<matrix containing predictions>>)

      # Must use string to index into reactivevalues
      i = as.character(i)

      learner = self$learners[[i]]
      model   = train(learner, self$task$train)
      pred    = expand.grid(x = -50:50 / 10, y = -50:50 / 10)

      predictions      = predictLearner(learner, model, pred)
      pred$class       = predictions
      pred$predictions = as.numeric(factor(predictions))

      return(pred)
    },

    getPredPlot = function(i) {
      #' @description Method to recieve prediction surface of a trained learner
      #' as an interactive plot
      #' @param i Index of the learner in self$learners to return the
      #' predictions plot for
      #' @return plotly plot object

      pred = self$calculatePred(i)

      plotly::plot_ly(
        data    = self$data$train.set,
        x       = ~x1,
        y       = ~x2,
        color   = ~class,
        colors  = c("#2b8cbe", "#e34a33", "#2b8cbe", "#e34a33"),
        type    = "scatter",
        mode    = "markers"

      ) %>%
        plotly::add_trace(
          x         = ~unique(pred$x),
          y         = ~unique(pred$y),
          z         = ~matrix(pred$predictions, nrow = sqrt(length(pred$predictions)), byrow = TRUE),
          type      = "heatmap",
          text      = ~matrix(pred$class, nrow = sqrt(length(pred$predictions)), byrow = TRUE),
          colors    = colorRamp(c("blue","red")),
          opacity   = 0.2,
          hoverinfo = "x+y+text+skip",
          showscale = FALSE
        ) %>%
        plotly::layout(xaxis = list(title = ""), yaxis = list(title = ""))
    }
  ),

  private = list()
)
