ClassifLearningProcess = R6Class(
  classname = "ClassifLearningProcess",
  inherit = LearningProcess,

  public = list(

    initialize = function(valid.learners) {
      measures = c(
        "acc", "tnr", "tpr", "f1", "mmce", "brier.scaled", "bac", "fn", "fp", "fnr", "qsr", "fpr", "npv",
        "brier", "auc", "multiclass.aunp", "multiclass.aunu","ber", "multiclass.brier", "ssr",
        "ppv", "wkappa", "tn", "tp", "multiclass.au1u", "gmean", "logloss"
      )
      super$initialize(valid.learners, tasktype = "classif", measures = measures)

    },

    setData = function(data, train.ratio) {
      super$setData(data, train.ratio)
      self$task$train = makeClassifTask(data = isolate(self$data$train.set), target = "class")
    },

    initLearner = function(short.name, i, prob = FALSE) {
      super$initLearner(short.name, i, "classif", prob)
    },

    getDataPlot = function() {
      #' @description Method transforming the data into an interactive plot
      #' @return plotly plot object
      plotly::plot_ly(
        data   = isolate(self$data$train.set),
        name   = "Train",
        x      = ~x1,
        y      = ~x2,
        color  = ~class,
        colors = c("#2b8cbe", "#e34a33"),
        symbol  = I('x'),
        type   = "scatter",
        mode   = "markers"
      )%>%
      plotly::add_trace(
        data   = isolate(self$data$test.set),
        name   = "Test",
        x      = ~x1,
        y      = ~x2,
        color  = ~class,
        colors = c("#2b8cbe", "#e34a33"),
        symbol  = I('o'),
        type   = "scatter",
        mode   = "markers"
        )
    },

    calculatePred = function(i) {
      #' @description Method for calculating predictions of a grid data set used for plotting
      #'  and returning the trained model for further prediction calculations
      #' @param i Index of the learner in self$learners to calculate the
      #' predictions for
      #' @return list(learner, model)


      # Must use string to index into reactivevalues
      i = as.character(i)

      trained = super$calculatePred(i)

      # caluclate grid predictions
      grid    = expand.grid(x1 = -50:50 / 10, x2 = -50:50 / 10)

      predictions = predictLearner(trained$learner, trained$model, grid)

      # check if something went wrong (ranger for example doesn't understand "prob")
      if (length(dim(predictions)) > 1) {

        predictions = predictions[, 2]
        # if prediction is equal 0.5, no class can be predicted
        class = ifelse(
          predictions < 0.5, "Class 1",
          ifelse(predictions > 0.5, "Class 2", "No Class")
        )

      } else {
        class = predictions
        predictions = as.numeric(predictions)
      }

      self$pred[[i]]$grid = cbind(grid, predictions = predictions, class = class)

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

      pred = isolate(self$pred[[i]]$grid)

      plotly::plot_ly(
        data    = isolate(self$data$train.set),
        name    = "Train",
        x       = ~x1,
        y       = ~x2,
        color   = ~class,
        colors  = c("#2b8cbe", "#e34a33", "#2b8cbe", "#e34a33"),
        symbol  = I("x"),
        type    = "scatter",
        mode    = "markers"
      ) %>%
        plotly::add_trace(
          data   = isolate(self$data$test.set),
          name   = "Test",
          x      = ~x1,
          y      = ~x2,
          color  = ~class,
          colors = c("#2b8cbe", "#e34a33"),
          symbol  = I('o'),
          type   = "scatter",
          mode   = "markers"
        )%>%
        plotly::add_trace(
          x         = ~unique(pred$x1),
          y         = ~unique(pred$x2),
          z         = ~matrix(pred$predictions, nrow = sqrt(nrow(pred)), byrow = TRUE),
          type      = "heatmap",
          text      = ~matrix(pred$class, nrow = sqrt(nrow(pred)), byrow = TRUE),
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
