RegrLearningProcess = R6Class(
  classname = "RegrLearningProcess",
  inherit   = LearningProcess,

  public = list(

    initialize = function(valid.learners) {
      measures = c(
        "mae", "mape", "medse", "rae", "spearmanrho", "medae", "sse", "expvar",
        "kendalltau", "rmse", "mse", "rrse", "rsq", "sae"#, "arsq", "rmsle", "msle"#, not working
      )
      super$initialize(valid.learners, tasktype = "regr", measures = measures)

    },

    setData = function(data, train.ratio) {
      self$task$object = makeRegrTask(data = data, target = "y")
      super$setData(train.ratio)
    },

    initLearner = function(short.name, i, prob) {
      # prob is only used for classif
      super$initLearner(short.name, i, "regr")
    },

    getDataPlot = function() {
      #' @description Method transforming the data into an interactive plot
      #' @return plotly plot object

      data = isolate(self$task$object$env$data)
      # define train and test data sets for plotting
      train.set = data[isolate(self$resample$instance$train.inds[[1]]), ]
      test.set  = data[isolate(self$resample$instance$test.inds[[1]]),  ]

      plotly::plot_ly(
        data    = train.set,
        name    = "Train",
        x       = ~x,
        y       = ~y,
        type    = "scatter",
        mode    = "markers",
        color  = I(color_2),
        symbol  = I('x')
      )%>%
      plotly::add_trace(
        data    = test.set,
        name    = "Test",
        x       = ~x,
        y       = ~y,
        type    = "scatter",
        mode    = "markers",
        color  = I(color_2),
        symbol  = I('o')
      ) %>%
      config(displayModeBar = FALSE, displaylogo = FALSE)
    },

    calculateResample = function(i) {
      #' @description Method for calculating equidistant predictions in a 2D box
      #' @param i Index of the learner in self$learners to calculate the
      #' predictions for
      #' @return NULL

      # define data
      data = isolate(self$task$object$env$data)
      # define train and test data sets for plotting
      train.set = data[isolate(self$resample$instance$train.inds[[1]]), ]
      test.set  = data[isolate(self$resample$instance$test.inds[[1]]),  ]

      # Must use string to index into reactivevalues
      i = as.character(i)

      measures    = isolate(self$task$measures)
      # calculate the base resample results
      isolate(super$calculateResample(i, measures))
      # learner and model from resample are required
      learner = isolate(self$updated_learners[[i]])
      model   = isolate(self$resample[[i]]$models[[1]])

      # set interval for 1D grid
      x_min = min(c(test.set$x, train.set$x)) * 1.1
      x_max = max(c(test.set$x, train.set$x)) * 1.1
      grid    = expand.grid(
        x = seq(x_min, x_max, length.out = 100)
      )
      grid$y  = predictLearner(learner, model, grid)

      self$pred[[i]]$grid = grid

    },

    getPredPlot = function(i) {
      #' @description Method to recieve prediction surface of a trained learner
      #' as an interactive plot
      #' @param i Index of the learner in self$learners to return the
      #' predictions plot for
      #' @return plotly plot object

      # define data
      data = isolate(self$task$object$env$data)
      # define train and test data sets for plotting
      train.set = data[isolate(self$resample$instance$train.inds[[1]]), ]
      test.set  = data[isolate(self$resample$instance$test.inds[[1]]),  ]

      # Must use string to index into reactivevalues
      i = as.character(i)

      pred = isolate(self$pred[[i]]$grid)
      # ignore warnings for now
      storeWarn = getOption("warn")
      options(warn = -1)

      plot = plotly::plot_ly(
        data = train.set,
        name   = "Train",
        x      = ~x,
        y      = ~y,
        symbol = I('x'),
        color  = I(color_2),
        type   = "scatter",
        mode   = "markers"
      ) %>%
      plotly::add_trace(
        data   = test.set,
        name   = "Test",
        x      = ~x,
        y      = ~y,
        symbol = I('o'),
        color  = I(color_2),
        type   = "scatter",
        mode   = "markers"
      )%>%
        plotly::add_trace(
          x     = ~pred$x,
          y     = ~pred$y,
          color = I(color_1),
          name  = 'Prediction',
          symbol = NULL,
          mode  = 'lines',
          showscale = FALSE,
          line = list(width = 4)
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
