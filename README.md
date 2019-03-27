[![Build Status](https://travis-ci.com/SebGruber1996/mlrPlayground.svg?token=aseAdkuRs3BN4g6uWRsf&branch=dev)](https://travis-ci.com/SebGruber1996/mlrPlayground)

# mlrPlayground
Interactive machine learning playground for the mlr package done in shiny.


Select predefined (but tunable) tasks:

![Screenshot](https://i.imgur.com/aq5is74.png)



Select learner and plot prediction plane:

![Screenshot](https://i.imgur.com/YxQunIa.png)


Adjust hyperparameters of learner and see the change in the predictions:

![Screenshot](https://i.imgur.com/H1GdsGh.png)



## How to start:
Use this link:
http://sebastian-gruber.shinyapps.io/mlrPlayground

###### Or:
Install the package and execute ``mlrPlayground::start()``.

###### Or:
Clone the git, open the file ``inst/mlrPlayground/global.R`` in Rstudio and press the "start app" button.


## About the R6 class system (only for developers):
Every learning process is considered as a class. Currently there are 6 classes. The base class is called "LearningProcess" and is meant as a base scheme with all required methods listed for all the other classes. The currently working classes are "ClassifLearningProcess" and "RegrLearningProcess". Besides these "Classif3dLearningProcess", "Regr3dLearningProcess" are not fully implemented and "ClusterLearningProcess" is implemented, but not working right now. All the plots should now be defined in each class, so tasks/datasets in the same class have the SAME predictions and plots. This hopefully makes everything a lot clearer and more uniform. The methods for these plots are already named and called everywhere ("getDataPlot" and "getPredPlot"), so no further methods should be introduced. Every plot should be defined in one of these methods in each class respectively. So whenever a plot is changed, only adapt the class, not any code anywhere else. To make the method "getPredPlot" work, one also has to implement the method "calculatePred", which basically calculates the predictions on a bounded set of equidistant (and predefined) points. When defining methods, ALWAYS use isolate on reactive values. Otherwise calling the method elsewhere may lead to highly unintended behaviour, like infinite update loops or triggered observers in some totally different place - basically stuff making debugging feel totally like hell.

## About unit tests (only for developers):
Because all the app files have to be placed in the ``inst/mlrPlayground`` folder, unit tests can't be written for functions (and especially the R6 classes) defined there. Also the package ``shinytest`` meant for "interactive UI" testing seems to not work - every new execution of the same test suddenly changes some value in the overall state, thus throwing a test error.
Fortunately a different way was found to still do some potent testing.
``shinytest`` allows to start the app, set input values and catch output values in a script without visiting the app. The current unit tests simply set the input to all different kinds of tasks and learners and checks if the dataset/prediction plot json data changed compared to the last input (this way we can make sure the plots are actually updated with the input instead of guessing that "not NULL" as a output condition for the plot may actually be enough).
