Classif3dLearningProcess = R6Class(
  classname = "Classif3dLearningProcess",
  inherit = ClassifLearningProcess,

  public = list(

    getDataPlot = function() {
      #' @description Method transforming the data into an interactive plot
      #' @return plotly plot object
      plotly::plot_ly(
        data = self$data$train.set,
        type = "scatter3d",
        x    = ~x,
        y    = ~y,
        z    = ~z,
        color = ~class,
        symbol  = I('x'),
        colors = c("#2b8cbe", "#e34a33")
      )%>%
      add_markers()%>%
      layout(scene = list(
        xaxis = list(title = 'xaxis'),
        yaxis = list(title = 'yaxis'),
        zaxis = list(title = 'zaxis'))
      )%>%
      plotly::add_trace(
        data   = self$data$test.set,
        x      = ~x,
        y      = ~y,
        z      = ~z,
        color  = ~class,
        colors = c("#2b8cbe", "#e34a33"),
        symbol  = I('o'),
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

      # TODO

      return(NULL)
    },

    getPredPlot = function(i) {
      #' @description Method to recieve prediction surface of a trained learner
      #' as an interactive plot
      #' @param i Index of the learner in self$learners to return the
      #' predictions plot for
      #' @return plotly plot object

      pred = self$calculatePred(i)

      # TODO
      return(NULL)
    }
  ),

  private = list()
)
