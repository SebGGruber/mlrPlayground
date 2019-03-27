ClassifLearningProcess = R6Class(
  classname = "ClassifLearningProcess",
  inherit = LearningProcess,

  public = list(

    initialize = function(valid.learners) {
      measures = c(
        "acc", "tnr", "tpr", "f1", "mmce", "bac", "fn", "fp", "fnr", "qsr", "fpr", "npv",
        "brier", "auc", "ber", "ssr",
        "ppv", "wkappa", "tn", "tp", "gmean", "logloss"
      )  #"brier.scaled", "multiclass.brier", "multiclass.aunu","multiclass.au1u", "multiclass.aunp",
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
          colors = c(color_2, color_1),
          symbol = I('x'),
          type   = "scatter",
          mode   = "markers"
        )%>%
        plotly::add_trace(
          data   = isolate(self$data$test.set),
          name   = "Test",
          x      = ~x1,
          y      = ~x2,
          color  = ~class,
          colors = c(color_2, color_1),
          symbol = I('o'),
          type   = "scatter",
          mode   = "markers"
        ) %>%
        config(displayModeBar = FALSE, displaylogo = FALSE)

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

      x1_min = min(c(self$data$test.set$x1, self$data$train.set$x1)) * 1.1
      x2_min = min(c(self$data$test.set$x2, self$data$train.set$x2)) * 1.1
      x1_max = max(c(self$data$test.set$x1, self$data$train.set$x1)) * 1.1
      x2_max = max(c(self$data$test.set$x2, self$data$train.set$x2)) * 1.1
      # caluclate grid predictions
      grid    = expand.grid(
        x1 = seq(x1_min, x1_max, length.out = 100),
        x2 = seq(x2_min, x2_max, length.out = 100)
      )

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
      i         = as.character(i)

      pred = isolate(self$pred[[i]]$grid)
      # ignore warnings for now
      storeWarn = getOption("warn")
      options(warn = -1)

      plot = plotly::plot_ly(
        data    = isolate(self$data$train.set),
        name    = "Train",
        x       = ~x1,
        y       = ~x2,
        color   = ~class,
        colors  = c(color_2, color_1, color_2, color_1),
        symbol  = I("x"),
        type    = "scatter",
        mode    = "markers"
      ) %>%
        plotly::add_trace(
          data   = isolate(self$data$test.set),
          name    = "Test",
          x       = ~x1,
          y       = ~x2,
          color   = ~class,
          colors  = c(color_2, color_1),
          symbol  = I('o'),
          type    = "scatter",
          mode    = "markers"
        )%>%
        plotly::add_trace(
          x         = ~unique(pred$x1),
          y         = ~unique(pred$x2),
          z         = ~matrix(pred$predictions, nrow = sqrt(nrow(pred)), byrow = TRUE),
          type      = "heatmap",
          text      = ~matrix(pred$class, nrow = sqrt(nrow(pred)), byrow = TRUE),
          colors    = colorRamp(c(color_21, color_11)),
          opacity   = 0.2,
          hoverinfo = "x+y+text+skip",
          showscale = FALSE
        ) %>%
        plotly::layout(
          xaxis = list(title = ""),
          yaxis = list(title = ""),
          margin = list(
            l = 0,
            r = 0,
            b = 0,
            t = 0,
            pad = 0
          )
        ) %>%
        config(displayModeBar = FALSE, displaylogo = FALSE)

      #restore warnings
      shinyjs::delay(expr = ({
        options(warn = storeWarn)
      }), ms = 100)

      plot
    }
  ),

  private = list()
)
