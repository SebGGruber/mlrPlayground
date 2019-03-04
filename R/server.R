require(mlr)
require(plotly)

server_files = list.files(path = "./servers", pattern="*.R")
server_files = paste0("servers/", server_files)

for (i in seq_along(server_files)) {
#  source(server_files[i], local = TRUE)
}

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2)

# the amount of test data sets
# amount = 200 

# test ration of all data sets
# ration = 1
# train_amount = amout * ration
# test_amount = amount * (1 - ration)


# noisy



shinyServer(function(input, output, session) {

  output$learnerSelection = renderUI({

    selectInput(
      "learner",
      label = "Select learner",
      choices = as.list(mlr::listLearners()$name[mlr::listLearners()$type == input$tasktype])
    )

  })

  output$taskselection = renderUI({

    #req(input$tasktype)
    #print(input$tasktype)

    #if (input$tasktype == "" || input$tasktype == "classif") {
      choices = list(
      #Classification
        "1.Circle", 
        "2.Two-Circle",
        "3.Two-Circle-2",
        "4.XOR",
        "5.Gaussian",
        "6.Across Spiral",
        "7.Opposite Arc",
        "8.Cross Sector",
        "9.Wavy surface (3D)",
        "10.Sphere (3D)",
      #Regression
        "1.Linear ascend",
        "2.Log linear",
        "3.Sine",
        "4.Ascend Cosine",
        "5.Tangent",
        "6.Sigmoid",
        "7.Circle",
        "8.Spiral",
        "9.Parabola To Right",
        "10.Spiral ascend (3D)",
      #Cluster
        "1.Clustering Dataset 1",
        "2.Clustering Dataset 2",
        "3.Clustering Dataset 3",
        "4.Clustering Dataset 4",
        "5.Clustering Dataset 5",
        "6.Clustering Dataset 6",

      #Multilabel
        "1.Spiral ascend (3D)",
        "2.Wavy surface (3D)",
        "3.Sphere (3D)",

      #Survival
        "1.Exponential Decrement",
        "2.Mountain Peak",
        "3.Wave"
        )

    #} else if (input$tasktype == "regr") {
    #  choices = list("Linear ascend (2D)")

    #} else if (input$tasktype == "cluster") {
    #  choices = list()

    #} else if (input$tasktype == "multilabel") {
    #  choices = list()

    #} else if (input$tasktype == "surv") {
    #  choices = list()

    #}

    radioButtons("task", label = "Select task", choices = choices)
  })


  output$taskinfo = renderText(paste("Currently selected:", input$tasktype, "-", input$task))


  output$distPlot = renderPlot({

    x    = faithful[, 2]
    bins = seq(min(x), max(x), length.out = 11)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })


  output$datasetPlot = renderPlotly({

    req(input$task)
    set.seed(123)
  ##add classification datasets 
    #1.add Circle data sets
    if (input$task == "1.Circle") {

      angle = runif(400, 0, 360)
      radius_class1 = rexp(200, 1)
      radius_class2 = rnorm(200, 16, 3)

      data = data.frame(
        x1 = sqrt(c(radius_class1, radius_class2)) * cos(2*pi*angle),
        x2 = sqrt(c(radius_class1, radius_class2)) * sin(2*pi*angle),
        class = c(rep("Class 1", 200), rep("Class 2", 200))
      )
    }

    #2.add two-circle data sets 
    else if (input$task == "2.Two-Circle") {

      angle = runif(400, 0, 360)
      radius_class1 = rnorm(200, 32, 3)
      radius_class2 = rnorm(200, 10, 3)

      data = data.frame(
        x1 = sqrt(c(radius_class1, radius_class2)) * cos(2*pi*angle),
        x2 = sqrt(c(radius_class1, radius_class2)) * sin(2*pi*angle),
        class = c(rep("Class 1", 200), rep("Class 2", 200))
      )

    }

    #3.add two-circle-2 data sets 
    else if (input$task == "3.Two-Circle-2") {

      angle = runif(400, 0, 360)
      radius_class1 = rnorm(200, 32, 3)
      radius_class2 = rnorm(200, 10, 3)
      x1 = sqrt(c(radius_class1, radius_class2)) * cos(2*pi*angle)
      x2 = sqrt(c(radius_class1, radius_class2)) * sin(2*pi*angle)
      class = ifelse(x2 > 0, "Class 1", "Class 2")

      data = data.frame(
        x1,
        x2,
        class
      )

    }

    #4.add XOR data sets
    else if (input$task == "4.XOR") {

      x1 = runif(400, -5, 5)
      x2 = runif(400, -5, 5)
      xor = (x1 < 0 | x2 < 0) & !(x1 < 0 & x2 < 0)
      class = ifelse(xor, "Class 1", "Class 2")

      data = data.frame(x1, x2, class)

    } 

    #5.add Gaussian data sets
    else if(input$task == "5.Gaussian"){
      x1 = c(rnorm(200,2,1),rnorm(200,-2,1))
      x2 = c(rnorm(200,2,1),rnorm(200,-2,1))
      class = c(rep("Class 1", 200), rep("Class 2", 200)) 
      data = data.frame(x1,x2,class)
    }

    #6.add Across Spiral data sets
    else if(input$task == "6.Across Spiral"){
      r = c(1:200) / 200 * 5
      t = 1.75 * c(1:200)  / 200 * 2 * pi
      noisy = rexp(200,1)/3
      x1 = c(r * sin(t) + noisy, r * sin(t + pi) + noisy)
      x2 = c(r * cos(t) + noisy, r * cos(t + pi) + noisy)
      class = c(rep("Class 1",200),rep("Class 2",200))
      data = data.frame(x1,x2,class)
    }

    #7. add Opposite Arc data sets 
    else if(input$task == "7.Opposite Arc"){
      noisy = rexp(200,1)/8
      p1 = c(0:199) * pi/200
      p2 = c(100:299) * pi/200
      x1 = c(p1,p2) + noisy
      x2 = c(sin(p1) + runif(200,-1,1) / 4,sin(p2+pi/2) + runif(200,-1,1) / 4) + noisy
      class = c(rep("Class 1", 200), rep("Class 2", 200))
      data = data.frame(x1,x2,class)
    }

    #8.add Cross Sector data sets
    if (input$task == "8.Cross Sector") {
      
      angle = runif(200, 0, 36)
      radius_class1 = rexp(200, 1)
      radius_class2 = rexp(200, 2)
      for(i in c(0:9)){
        p1 = c(sqrt(radius_class1) * cos(2*pi*(angle+36 * 2 * i)/360), sqrt(radius_class2) * cos(2*pi*(angle+36 * (2 * i + 1))/360))
        p2 = c(sqrt(radius_class1) * sin(2*pi*(angle+36 * 2 * i)/360), sqrt(radius_class2) * sin(2*pi*(angle+36 * (2 * i + 1))/360))
        if(i == 0){
          x1 = p1
          x2 = p2
          class = c(rep("Class 1", 200), rep("Class 2", 200))
        }
        else{
          x1 = c(x1,p1)
          x2 = c(x2,p2)
          class = c(class,rep("Class 1", 200), rep("Class 2", 200))
        }
      }

      data = data.frame(x1,x2,class)
    }

    #9.add Wavy surface(3D) data sets
    else if(input$task == "9.Wavy surface (3D)"){
      kern = c(-20:20) * pi / 10
      x = rep(kern,41)
      y = rep(kern,each=41)
      z = sin(x)+sin(y) + rnorm(length(y),0,1)/3
      class = rep(0,length(z))
      for(i in c(1:length(z))){
        if(z[i]>=0){
          class[i] = "Class 1"
        }else{
          class[i] = "Class 2"
        }
      }
      
      data = data.frame(x,y,z,class)
    }

    #10.add Sphere (3D) data sets
    else if(input$task == "10.Sphere (3D)"){
      R = 2
      alfa = runif(50,0,50)*pi
      sita = runif(50,0,50)*pi*2

      num_alfa = length(alfa)
      num_sita = length(sita)

      x <- matrix(0, num_alfa, num_sita)
      y <- matrix(0, num_alfa, num_sita)
      z <- matrix(0, num_alfa, num_sita)
      class <- matrix(0, num_alfa, num_sita)

      for(i in c(1:num_alfa)){
        for(j in c(1:num_sita)){
          x[i,j] = R * sin(alfa[i]) * cos(sita[j]) + rnorm(1,0,1)/3
          y[i,j] = R * sin(alfa[i]) * sin(sita[j]) + rnorm(1,0,1)/3
          z[i,j] = R * cos(alfa[i])
          if(z[i,j]>=y[i,j]){
            class[i,j] = "Class 1"
          }else{
            class[i,j] = "Class 2"
          }
        }
      }
      x <- as.vector(x)
      y <- as.vector(y)
      z <- as.vector(z)
      class <- as.vector(class)
      data <- data.frame(x,y,z,class)
    }
  ### add regression data sets
    #1.add normal linear data sets
    else if (input$task == "1.Linear ascend") {

      x = rnorm(200, 0, 5)
      y = 0.5 * x + rnorm(200, 0, 1)

      data = data.frame(x, y)

    }
    #2.dd Log function data sets
    else if(input$task == "2.Log linear"){
      x = rnorm(400, 0, 5)
      y = log10(2 * x + rnorm(400, 0, 1))
      
      data = data.frame(x, y)
    }
  
    #3.add trigonometric function: Sine data sets
    else if(input$task == "3.Sine"){
      noisy = rexp(200,1)/2
      x <- c(-200:200) * pi/100
      y <- sin(x) + noisy

      data <- data.frame(x,y)
    }

    #4.add Ascend Cosine data sets
    else if(input$task == "4.Ascend Cosine"){
      noisy = rexp(200,1)/2
      x <- c(-200:200) * pi/100
      y <-  cos(x) + c(1:401)/150 + noisy

      data <- data.frame(x,y)
    }

    #5.add Tangent data sets
    else if(input$task == "5.Tangent"){
      noisy = rexp(200,1)/2
      x <- c(-190:190) * pi/400
      y<- tan(x) + rnorm(381,-1,1)  + noisy

      data <- data.frame(x,y)
    }

    #6. add Sigmoid data sets
    else if(input$task == "6.Sigmoid"){
      sigmoid = function(x) {
        1 / (1 + exp(-x))
      }
      noisy = rexp(200,1)/2
      p <- runif(400, -20, 20)
      x = p 
      y <- sigmoid(p)+ rnorm(400, -1, 1) / 10

      data <- data.frame(x,y)
    }

    #7. add Circle data sets
    else if(input$task == "7.Circle"){
      angle = runif(400, 0, 360)
      
      radius_class2 = rnorm(400, 16, 3)

      data = data.frame(
        x = sqrt( radius_class2) * cos(2*pi*angle),
        y = sqrt( radius_class2) * sin(2*pi*angle)
      )
    }

    #8. add Spiral data sets
    else if(input$task == "8.Spiral"){
      r = c(1:400) / 200 * 5
      t = 1.75 * c(1:400)  / 200 * 2 * pi
      noisy = rexp(200,1)/2
      x = r * sin(t) + noisy
      y = r * cos(t) + noisy

      data = data.frame( x, y)
    }

    #9. add Parabola To Right data sets
    else if(input$task == "9.Parabola To Right"){
      noisy = rnorm(400,0,1)
      x = rexp(400,1) + noisy
      y1 = sqrt(4 * x) + noisy
      y2 = -sqrt(4 * x) + noisy
      y = c(y1,y2)

      data = data.frame( x, y)
    }

    #10. add Spiral ascend (3D) data sets
    else if(input$task == "10.Spiral ascend (3D)"){
      z = rexp(200,1)*4
      x = sin(z)
      y = cos(z)

      data = data.frame(x, y, z)
    }
  ### add clustering data sets
  #1. add Clustering Dataset 1
    else if(input$task == "1.Clustering Dataset 1"){
      noisy = rexp(200,1)/2
      x1 = rnorm(200, 0, 5) + noisy
      x2 = rexp(200,1) + noisy
      x3 = runif(200,-2,2) + noisy
      y1 = rnorm(200, 0, 5) + noisy
      y2 = rexp(200,1) + noisy
      y3 = runif(200,-2,2) + noisy

      x = c(x1/3 + 3, x2/3 - 3, x3/3 + 1)
      y = c(y1/3 + 3, y2/3 - 1, y3/3 -2)

      data = data.frame(x, y)
    }

  #2. add Clustering Dataset 2
    else if(input$task == "2.Clustering Dataset 2"){
      r = c(101:200) / 200 * 5
      t = 1.75 * c(101:200)  / 200 * 2 * pi
      noisy = rexp(100,1)/3
      x = c(r * sin(t) + noisy, r * sin(t + pi) + noisy)
      y = c(r * cos(t) + noisy, r * cos(t + pi) + noisy)

      data = data.frame(x, y)
    }

  #3. add Clustering Dataset 3
    else if(input$task == "3.Clustering Dataset 3"){
      angle = runif(400, 0, 360)
      radius_class1 = rexp(200, 1)
      noisy = rexp(200,1)/8
      p1 = c(0:199) * pi/200
      p2 = c(100:299) * pi/200
      p3 = sqrt(radius_class1) * cos(2*pi*angle)
      x = c(p1,p2,p3-2) + noisy
      y = c(sin(p1) + runif(200,-1,1) / 4,sin(p2+pi/2) + runif(200,-1,1) / 4, sqrt(radius_class1) * sin(2*pi*angle)) + noisy

      data = data.frame(x, y)
    }

  #4. add Clustering Dataset 4
    else if(input$task == "4.Clustering Dataset 4"){
      angle = runif(400, 0, 360)
      radius_class1 = rnorm(200, 8, 3)
      radius_class2 = rnorm(200, 32, 3)
      radius_class3 = rnorm(200, 64, 3)
      radius_class4 = rnorm(200, 128, 3)

      data = data.frame(
        x = sqrt(c(radius_class1, radius_class2,radius_class3,radius_class4)) * cos(2*pi*angle),
        y = sqrt(c(radius_class1, radius_class2,radius_class3,radius_class4)) * sin(2*pi*angle)
      )
    }

    #5. add Clustering Dataset 5
    else if(input$task == "5.Clustering Dataset 5"){
      x1 = rnorm(200, 0, 5)
      x2 = rnorm(200, 3, 5) + 4
      x3 = rnorm(200, 8, 5) - 2
      x = c(x1,x2,x3)
      y1 = 0.5 * x1 + rnorm(200, 0, 1)
      y2 = 0.5 * x2 + rnorm(200, 0, 1) + 6
      y3 = 0.5 * x3 + rnorm(200, 0, 1) -  6
      y = c(y1,y2,y3)

      data <- data.frame(x,y)
    }

    #6. add Clustering Dataset 6
    else if(input$task == "6.Clustering Dataset 6"){
      x1 = runif(200,-5,5)
      y1 = runif(200,-5,5)

      angle = runif(200, 0, 360)
      radius_class1 = rexp(200, 1)
      x2 = sqrt(radius_class1) * cos(2*pi*angle) + 2
      y2 = sqrt(radius_class1) * sin(2*pi*angle) + 4

      x3 = sqrt(radius_class1) * cos(2*pi*angle) + 0.8
      y3 = sqrt(radius_class1) * sin(2*pi*angle) - 0.4

      noisy = runif(200,0,1)
      x4 = rexp(200,1) + noisy
      y4 = c(sqrt(4 * x4),-sqrt(4 * x4)) + noisy

      x = c(x1,x2,x3,-x4,-x4)
      y = c(y1,y2,y3,y4)

      data <- data.frame(x, y)
    }

  ### add multilabel data sets(3D)
    #1.add Spiral ascend (3D) data sets
    else if(input$task == "1.Spiral ascend (3D)"){
      z = rexp(200,1)*4
      x = sin(z)
      y = cos(z)

      data = data.frame(x, y, z)
    }

    #2.add Wavy surface(3D) data sets
    else if(input$task == "2.Wavy surface (3D)"){
      x = c(-20:20) * pi / 10
      y = rep(x,each=41)
      z = sin(x)+sin(y)

      data = data.frame(x,y,z)
    }

    #3.add Sphere data sets
    else if(input$task == "3.Sphere (3D)"){
      R = 2
      alfa = runif(50,0,50)*pi
      sita = runif(50,0,50)*pi*2

      num_alfa = length(alfa)
      num_sita = length(sita)
      x <- matrix(0, num_alfa, num_sita)
      y <- matrix(0, num_alfa, num_sita)
      z <- matrix(0, num_alfa, num_sita)
      class <- matrix(0, num_alfa, num_sita)


      for(i in c(1:num_alfa)){
        for(j in c(1:num_sita)){
          x[i,j] = R * sin(alfa[i]) * cos(sita[j])
          y[i,j] = R * sin(alfa[i]) * sin(sita[j])
          z[i,j] = R * cos(alfa[i])
        }
      }
      x <- as.vector(x)
      y <- as.vector(y)
      z <- as.vector(z)
     
      data <- data.frame(x,y,z)
    }

  ## add Survival data sets
    #1. add Exponential Decrement data sets
    else if(input$task == "1.Exponential Decrement"){
      x = c(1:51)
      t1 = round(rexp(50,1)/6,2)
      y1 = c(1,sort(t1,TRUE))

      t2 = round((rexp(50,1)-0.6)/6,2)
      y2 = c(1,sort(abs(t2),TRUE))

      data <- data.frame(x,y1,y2)
    }

    #2. add Mountain Peak data sets
    else if(input$task == "2.Mountain Peak"){
      x = c(1:26) * 4
      t1 = round(runif(25,1,100),0)/100
      s1 = sort(t1,TRUE) * pi
      y1 = c(0,sin(s1))

      t2 = round(runif(25,1,100),0)/100
      s2 = sort(t2,TRUE) * pi
      y2 = c(0,sin(s2)*0.8)

      data <- data.frame(x,y1,y2)
    }

  #3. add Wave data sets
    else if(input$task == "3.Wave"){
      x = c(1:91)
      t1 = c(round(runif(30,10,90),0)/100 ,round(runif(30,110,190),0)/100 ,round(runif(30,210,290),0)/100)
      s1 = sort(t1,TRUE) * pi
      y1 = c(1,abs(sin(s1)))

      t2 = c(round(runif(30,-40,40),0)/100 ,round(runif(30,60,140),0)/100 ,round(runif(30,160,240),0)/100)
      s2 = sort(t2,TRUE) * pi
      y2 = c(1,abs(cos(s2))*0.6)

      data <- data.frame(x,y1,y2)
    }

  #4. add Log data sets
    else if(input$task == "4.Log"){
      x = c(1:91)
      t1 = c(round(runif(30,10,90),0)/100 ,round(runif(30,110,190),0)/100 ,round(runif(30,210,290),0)/100)
      s1 = sort(t1,TRUE) * pi
      y1 = c(1,abs(sin(s1)))

      t2 = c(round(runif(30,-40,40),0)/100 ,round(runif(30,60,140),0)/100 ,round(runif(30,160,240),0)/100)
      s2 = sort(t2,TRUE) * pi
      y2 = c(1,abs(cos(s2))*0.6)
    }

### parameter setting of plot_ly ###
    if (input$tasktype == "classif") {
      plotly::plot_ly(
        data = data,
        x = ~x1,
        y = ~x2,
        color = ~class,
        colors = c("#2b8cbe", "#e34a33"),
        type = "scatter",
        mode = "markers"
      )
    } 
    else if (input$tasktype == "classif_3d") {
      plotly::plot_ly(
          data = data,
          type = "scatter3d",
          x = ~x,
          y = ~y,
          z = ~z,
          color = ~class,
          colors = c("#2b8cbe", "#e34a33")
      )%>%
          add_markers()%>%
          layout(scene = list(xaxis = list(title = 'xaxis'),
                              yaxis = list(title = 'yaxis'),
                              zaxis = list(title = 'zaxis')))
    }
    else if (input$tasktype == "regr") {
      plotly::plot_ly(
        data = data,
        x = ~x,
        y = ~y,
        type = "scatter",
        mode = "markers"
      )
    }
    else if (input$tasktype == "regr_3d") {
      plotly::plot_ly(
          data = data,
          type = "scatter3d",
          x = ~x,
          y = ~y,
          z = ~z
      )%>%
          add_markers()%>%
          layout(scene = list(xaxis = list(title = 'xaxis'),
                              yaxis = list(title = 'yaxis'),
                              zaxis = list(title = 'zaxis')))
    }
    else if (input$tasktype == "cluster") {
      plotly::plot_ly(
        data = data,
        x = ~x,
        y = ~y,
        marker = list(
          size = 10,
          color = 'rgba(255, 182, 193, .9)',
          line = list(color = 'rgba(152, 0, 0, .8)',
          width = 1)
        ),
        type = "scatter",
        mode = "markers"
      )
    }
    else if(input$tasktype == "multilabel"){
    plotly::plot_ly(
        data = data,
        type = "scatter3d",
        x = ~x,
        y = ~y,
        z = ~z,
        marker = list(color = ~z, colorscale = c('#FFE1A1', '#683531'), showscale = TRUE)
    )%>%
        add_markers()%>%
        layout(scene = list(xaxis = list(title = 'xaxis'),
                            yaxis = list(title = 'yaxis'),
                            zaxis = list(title = 'zaxis')))
    }
    else if (input$tasktype == "surv") {
      plot_ly(
        data, 
        x = ~x, 
        y = ~y1, 
        line = list(
          color = "blue", 
          shape = "hv"
        ), 
        mode = "lines", 
        type = "scatter"
      ) %>%
        
      add_trace(
        y = ~y2,
        name = 'trace 2',
        line = list(
        color = "red"
        ),
        mode ='lines'
      )
    }
     else {
      plotly::plotly_empty()
    }

  })

  session$onSessionEnded(stopApp)
})
