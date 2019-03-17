# mlrPlayground
Interactive machine learning playground for the mlr package done in shiny.


Select predefined (but tunable) tasks:

![Screenshot](https://i.imgur.com/N2LshkV.png)



Select learner (plus its hyperparameters) and plot prediction plane:

![Screenshot](https://i.imgur.com/QZoUExQ.png)



## How to start:
Use this link (currently only represents branch 'sebastian'):
http://sebastian-gruber.shinyapps.io/mlrPlayground

###### Or:
Open the file ``inst/mlrPlayground/server.R`` or ``inst/mlrPlayground/ui.R`` in Rstudio and press the "start app" button.

###### Or:
Execute ``shiny::startApp('inst/mlrPlayground/')`` in the project folder.

## About the R6 class system (only for developers):
Every learning process is now considered as a class. Currently there are 6 classes with 3 working and 3 not working. The base class is called "LearningProcess" and is meant as a base scheme with all required methods listed for all the other classes. The currently working classes are "ClassifLearningProcess" and "RegrLearningProcess". Besides these "Classif3dLearningProcess", "Regr3dLearningProcess" are not fully implemented and "ClusterLearningProcess" is implemented, but not working right now. All the plots should now be defined in each class, so tasks/datasets in the same class have the SAME predictions and plots. This hopefully makes everything a lot clearer and more uniform. The methods for these plots are already named and called everywhere ("getDataPlot" and "getPredPlot"), so no further methods should be introduced. Every plot should be defined in one of these methods in each class respectively. So whenever a plot is changed, only adapt the class, not any code anywhere else. To make the method "getPredPlot" work, one also has to implement the method "calculatePred", which basically calculates the predictions on a bounded set of equidistant (and predefined) points. This method is then tested in testthat and called in the method "getPredPlot" to plot these predictions. Please follow this guideline.
