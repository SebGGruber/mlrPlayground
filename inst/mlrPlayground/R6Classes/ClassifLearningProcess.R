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
      self$task$object = makeClassifTask(data = data, target = "class")
      super$setData(train.ratio)
    },

    initLearner = function(short.name, i, prob = FALSE) {
      super$initLearner(short.name, i, "classif", prob)
    },

    getDataPlot = function() {
      #' @description Method transforming the data into an interactive plot
      #' @return plotly plot object

      data = isolate(self$task$object$env$data)
      # define train and test data sets for plotting
      train.set = data[isolate(self$resample$instance$train.inds[[1]]), ]
      test.set  = data[isolate(self$resample$instance$test.inds[[1]]),  ]

      plotly::plot_ly(
          data   = train.set,
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
          data   = test.set,
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

    calculateResample = function(i) {
      #' @description Method for calculating predictions of a grid data set used for plotting
      #'  and returning the trained model for further prediction calculations
      #' @param i Index of the learner in self$learners to calculate the
      #' predictions for
      #' @return list(learner, model)

      # define data
      data = isolate(self$task$object$env$data)
      # define train and test data sets for plotting
      train.set = data[isolate(self$resample$instance$train.inds[[1]]), ]
      test.set  = data[isolate(self$resample$instance$test.inds[[1]]),  ]

      # Must use string to index into reactivevalues
      i = as.character(i)

      learner = isolate(self$updated_learners[[i]])
      measures    = {
        # remove measures requiring probabilities if predict.type is "response"
        if (learner$predict.type != "prob") {
          meas = isolate(self$task$measures)
          meas[
            sapply(meas, function(x) !("req.prob" %in% getMeasureProperties(get(x))))
          ]

        } else isolate(self$task$measures)
      }

      # calculate the base resample results
      isolate(super$calculateResample(i, measures))
      # model after resample
      model   = isolate(self$resample[[i]]$models[[1]])

      # calculate corners of a box with 10% margins around the data set
      x1_min = min(c(test.set$x1, train.set$x1)) * 1.1
      x2_min = min(c(test.set$x2, train.set$x2)) * 1.1
      x1_max = max(c(test.set$x1, train.set$x1)) * 1.1
      x2_max = max(c(test.set$x2, train.set$x2)) * 1.1
      # caluclate grid predictions (length² data points)
      grid    = expand.grid(
        x1 = seq(x1_min, x1_max, length.out = 49),
        x2 = seq(x2_min, x2_max, length.out = 49)
      )

      # predictions for the defined grid
      predictions = predictLearner(learner, model, grid)

      # check if something went wrong with the dimensions
      # (ranger for example doesn't understand "prob")
      if (length(dim(predictions)) > 1) {

        predictions = predictions[, 2]
        # if prediction is equal 0.5, no class can be predicted
        class = ifelse(
          predictions <= 0.5,
          "Class 1",
          "Class 2"
        )

      } else {
        class = predictions
        predictions = as.numeric(predictions)
      }

      # set instance attribute for grid preds
      self$pred[[i]]$grid = cbind(grid, predictions = predictions, class = class)
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
      i         = as.character(i)

      pred = isolate(self$pred[[i]]$grid)
      # ignore warnings for now
      storeWarn = getOption("warn")
      options(warn = -1)

      plot = plotly::plot_ly(
        data    = train.set,
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
          data   = test.set,
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
