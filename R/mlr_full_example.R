x1 = runif(400, -5, 5)
x2 = runif(400, -5, 5)
xor = (x1 < 0 | x2 < 0) & !(x1 < 0 & x2 < 0)
class = ifelse(xor, "Class 1", "Class 2")

data = data.frame(x1, x2, class)



task_mlr    = mlr::makeClassifTask(data = data, target = "class")
learner_mlr = mlr::makeLearner("classif.ada")
rdesc       = mlr::makeResampleDesc("CV", iters = 2)
results     = mlr::resample(learner_mlr, task_mlr, rdesc)

learningcurve = generateLearningCurveData(learner_mlr, task_mlr)
