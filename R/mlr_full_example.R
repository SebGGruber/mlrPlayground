library(mlr)

x1 = runif(400, -5, 5)
x2 = runif(400, -5, 5)
xor = (x1 < 0 | x2 < 0) & !(x1 < 0 & x2 < 0)
class = ifelse(xor, "Class 1", "Class 2")

data = data.frame(x1, x2, class)



task_mlr    = mlr::makeClassifTask(data = data, target = "class")
learner_mlr = mlr::makeLearner("classif.bartMachine")
model       = mlr::train(learner_mlr, task_mlr)


pred = expand.grid(x1 = -50:50/10, x2 = -50:50/10)
#pred$class = rep("Class 1", 121)
#task_mlr    = mlr::makeClassifTask(data = pred, target = "class")

predictions = predictLearner(learner_mlr, model, pred)

#prediction = predict(model, task_mlr)
pred = data.frame(x = unique(pred$x1), y = unique(pred$x2))
pred$pred_matrix = as.numeric(factor(predictions))

plotly::plot_ly(
  data = pred,
  x = ~unique(x1),
  y = ~unique(x2),
  z = ~matrix(pred_matrix, nrow = sqrt(length(predictions)), byrow = TRUE),
  type = "heatmap",
  colorscale = "Greys",
  opacity = 0.5
)

#rdesc       = mlr::makeResampleDesc("CV", iters = 2)
#results     = mlr::resample(learner_mlr, task_mlr, rdesc)

#learningcurve = generateLearningCurveData(learner_mlr, task_mlr)
