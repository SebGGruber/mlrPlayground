Classif3dLearningProcess = R6Class(
  classname = "Classif3dLearningProcess",
  inherit = ClassifLearningProcess,

  public = list(

    getDataPlot = function() {
      #' @description Method transforming the data into an interactive plot
      #' @return plotly plot object
      plotly::plot_ly(
        data    = self$data$train.set,
        type    = "scatter3d",
        x       = ~x,
        y       = ~y,
        z       = ~z,
        color   = ~class,
        opacity = 0.5,
        colors  = c("#2b8cbe", "#e34a33")
      )%>%
      plotly::add_trace(
        data    = self$data$test.set,
        name    = "Test",
        type    = "scatter3d",
        x       = ~x,
        y       = ~y,
        z       = ~z,
        color   = ~class,
        opacity = 0.5,
        symbol  = I("o"),
        colors  = c("#2b8cbe", "#e34a33")
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

      # pred = self$calculatePred(i)

      # TODO
      plotly::plot_ly(
        data    = self$data$train.set,
        type    = "scatter3d",
        x       = ~x,
        y       = ~y,
        z       = ~z,
        color   = ~class,
        opacity = 0.5,
        colors  = c("#2b8cbe", "#e34a33")
      )%>%
      plotly::add_trace(
        data    = self$data$test.set,
        name    = "Test",
        type    = "scatter3d",
        x       = ~x,
        y       = ~y,
        z       = ~z,
        color   = ~class,
        opacity = 0.5,
        symbol  = I("o"),
        colors  = c("#2b8cbe", "#e34a33")
        )
    }
  ),

  private = list()
)
