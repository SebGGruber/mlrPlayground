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
Open the file R/server.R or R/ui.R in Rstudio and press the "start app" button.

###### Or:
Execute ``shiny::startApp('R/')`` in the project folder.

## TODO

### Sebastian
- user interface
- frontend/backend logic
- threshold setting
- https://mlr.mlr-org.com/articles/tutorial/learning_curve.html


### Yuhao
- mehr 2D datensätze (classification (wichtig), regression (wichtig), cluster (mittel), multilabel (niedrig), survival (niedrig)) (10 pro typ)
- ein paar 3D datensätze als versuch (2-3)
- beste plotly optionen für unterschiedliche datensätze
- parameter einbauen (streuung, training:test ration) (!!KEIN USER INTERFACE!!)
