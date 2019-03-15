# set the amount of test data sets
amount       = 200

# by noisy size change data sets
scope  = 3
rnom_scope   = rnorm(amount, 0, 1) / scope
rexp_scope   = rexp(amount, 1) / scope
runif_scope  = runif(amount, 0, 1) / scope

# TODO: add parameter selections for the amount, the distribution, noisy_ration, scope,
# TODO: (add any number of data sets, set x offset and y offset for each class)
# distribution = Null
# noisy_ration = 0.1
# size_noisy   = amount * noisy_ration

observe({

  req(input$task)

  seed = 123 # TODO
  set.seed(seed)

  values$data = {
    if (input$task == "Circle") {

      angle = runif(400, 0, 360)
      radius_class1 = rexp(200, 1)
      radius_class2 = rnorm(200, 16, 3)

      data.frame(
        x1 = sqrt(c(radius_class1, radius_class2)) * cos(2*pi*angle),
        x2 = sqrt(c(radius_class1, radius_class2)) * sin(2*pi*angle),
        class = c(rep("Class 1", 200), rep("Class 2", 200))
      )

    } else if (input$task == "XOR") {

      x1 = runif(400, -5, 5)
      x2 = runif(400, -5, 5)
      xor = (x1 < 0 | x2 < 0) & !(x1 < 0 & x2 < 0)
      class = ifelse(xor, "Class 1", "Class 2")

      data.frame(x1, x2, class)

    } else if (input$task == "Linear ascend (2D)") {

      x = rnorm(200, 0, 5)
      y = 0.5 * x + rnorm(200, 0, 1)
      class = c(rep("Class 1", 400))
      data.frame(x, y, class)

      ##add classification datasets
      #1.add Circle data sets
    } else if (input$task == "1.Circle") {

      angle         = runif(400, 0, 360)
      radius_class1 = rexp(amount, 1)
      radius_class2 = rnorm(amount, 16, 3)

      data.frame(
        x1    = sqrt(c(radius_class1, radius_class2)) * cos(2*pi*angle),
        x2    = sqrt(c(radius_class1, radius_class2)) * sin(2*pi*angle),
        class = c(rep("Class 1", amount), rep("Class 2", amount))
      )

      #2.add two-circle data sets
    } else if (input$task == "2.Two-Circle") {

      angle         = runif(amount * 2, 0, 360)
      radius_class1 = rnorm(amount, 6, 1)
      radius_class2 = rnorm(amount, 16, 3)

      data.frame(
        x1    = sqrt(c(radius_class1, radius_class2)) * cos(2*pi*angle),
        x2    = sqrt(c(radius_class1, radius_class2)) * sin(2*pi*angle),
        class = c(rep("Class 1", amount), rep("Class 2", amount))
      )

      #3.add two-circle-2 data sets
    } else if (input$task == "3.Two-Circle-2") {

      angle         = runif(amount * 2, 0, 360)
      radius_class1 = rnorm(amount, 6, 1)
      radius_class2 = rnorm(amount, 16, 3)
      x1            = sqrt(c(radius_class1, radius_class2)) * cos(2*pi*angle)
      x2            = sqrt(c(radius_class1, radius_class2)) * sin(2*pi*angle)
      class         = ifelse(x2 > 0, "Class 1", "Class 2")

      data.frame(x1, x2, class)

      #4.add XOR data sets
    } else if (input$task == "4.XOR") {

      x1    = runif(amount * 2, -5, 5)
      x2    = runif(amount * 2, -5, 5)
      xor   = (x1 < 0 | x2 < 0) & !(x1 < 0 & x2 < 0)
      class = ifelse(xor, "Class 1", "Class 2")

      data.frame(x1, x2, class)

      #5.add Gaussian data sets
    } else if(input$task == "5.Gaussian"){

      x1    = c(rnorm(amount, 2, 1), rnorm(amount, -2, 1)) - 0.5
      x2    = c(rnorm(amount, 2, 1), rnorm(amount, -2, 1))
      class = c(rep("Class 1", amount), rep("Class 2", amount))

      data.frame(x1, x2, class)

      #6.add Across Spiral data sets
    } else if(input$task == "6.Across Spiral"){

      r     = c(1 : amount) / amount * 5
      angle = 1.75 * c(1 : amount)  / amount * 2 * pi
      x1    = (c(sin(angle), sin(angle + pi)) * r + rnom_scope) * 4 / 5
      x2    = c(cos(angle), cos(angle + pi)) * r + rnom_scope
      class = c(rep("Class 1",amount),rep("Class 2",amount))

      data.frame(x1, x2, class)

      #7. add Opposite Arc data sets
    } else if(input$task == "7.Opposite Arc"){

      range1 = c(0 : (amount - 1)) * pi / 200
      range2 = c(100 : (amount + 99)) * pi / 200
      x1     = c(range1, range2) + rexp_scope - 2

      arc1   = sin(range1) + runif(amount,-1,1) / 4
      arc2   = sin(range2+pi/2) + runif(amount,-1,1) / 4
      x2     = c(arc1, arc2) * 2 + rexp_scope
      class  = c(rep("Class 1", amount), rep("Class 2", amount))

      data.frame(x1, x2, class)

      #8.add Cross Sector data sets
    } else if (input$task == "8.Cross Sector") {

      part          = c(0 : 9)
      angle         = runif(amount * 5, 0, 36)
      angle_class1  = 2 * pi * (angle + 36 * 2 * part) / 360
      angle_class2  = 2 * pi * (angle  + 36 * (2 * part + 1)) / 360
      radius_class1 = rexp(amount * 5, 1)
      radius_class2 = rexp(amount * 5, 2)
      
      x1_class1     = sqrt(radius_class1) * cos(angle_class1)
      x1_class2     = sqrt(radius_class2) * cos(angle_class2)
      x1            = c(x1_class1, x1_class2)
      
      x2_class1     = sqrt(radius_class1) * sin(angle_class1)
      x2_class2     = sqrt(radius_class2) * sin(angle_class2)
      x2            = c(x2_class1, x2_class2)
      class         = c(rep("Class 1", 1000), rep("Class 2", 1000))

      data.frame(
        x1          = x1 * 2, 
        x2          = x2 * 2, 
        class
      )

      #9.add Wavy surface(3D) data sets
    } else if(input$task == "9.Wavy surface (3D)"){

      kern  = c((- amount / 10) : (amount / 10)) * pi / 10
      x     = rep(kern,41)
      y     = rep(kern,each=41)
      z     = sin(x) + sin(y) + rnorm(length(y), 0, 1) / 3
      class = rep(0, length(z))
      for(i in c(1 : length(z))){
        if(z[i] >= 0){
          class[i] = "Class 1"
        }else{
          class[i] = "Class 2"
        }
      }

      data.frame(x,y,z,class)

      #10.add Sphere (3D) data sets
    } else if(input$task == "10.Sphere (3D)"){

      R        = 2
      alfa     = runif(amount / 4, 0, 50)* pi
      sita     = runif(amount / 4, 0, 50)* pi * 2

      num_alfa = length(alfa)
      num_sita = length(sita)

      x     = matrix(0, num_alfa, num_sita)
      y     = matrix(0, num_alfa, num_sita)
      z     = matrix(0, num_alfa, num_sita)
      class = matrix(0, num_alfa, num_sita)

      for(i in c(1 : num_alfa)){
        for(j in c(1 : num_sita)){
          x[i,j] = R * sin(alfa[i]) * cos(sita[j])
          y[i,j] = R * sin(alfa[i]) * sin(sita[j])
          z[i,j] = R * cos(alfa[i])
          if(z[i,j] >= y[i,j]){
            class[i,j] = "Class 1"
          }else{
            class[i,j] = "Class 2"
          }
        }
      }
      x     = as.vector(x + rnom_scope)
      y     = as.vector(y + rnom_scope)
      z     = as.vector(z)
      class = as.vector(class)

      data.frame(x,y,z,class)

      ### add regression data sets
      #1.add normal linear data sets
    } else if (input$task == "1.Linear ascend") {

      x = rnorm(amount, 0, 5)
      y = 0.5 * x + (rnom_scope * 5)

      data.frame(x, y)

      #2.dd Log function data sets
    } else if(input$task == "2.Log linear"){

      x = rnorm(amount * 2, 0, 5)
      y = log10(2 * x + (rnom_scope * 10))

      data.frame(x, y)

      #3.add trigonometric function: Sine data sets
    } else if(input$task == "3.Sine"){

      x = c(-amount:amount) * pi/100
      y = sin(x) + rexp_scope

      data.frame(x,y)

      #4.add Ascend Cosine data sets
    } else if(input$task == "4.Ascend Cosine"){

      x = c((-amount) : amount) * pi/100
      y =  cos(x) + c(1 : (amount * 2 + 1)) / 150 + rexp_scope

      data.frame(x,y)

      #5.add Tangent data sets
    } else if(input$task == "5.Tangent"){

      x = c((-amount + 10) : (amount - 10)) * pi/400
      y = tan(x) + rnorm((amount - 10) * 2  + 1, -1, 1)  + (rnom_scope * 4)

      data.frame(x, y)

      #6. add Sigmoid data sets
    } else if(input$task == "6.Sigmoid"){

      sigmoid = function(x) {
        1 / (1 + exp(-x))
      }
      p = runif(amount * 2, -20, 20)
      x = p
      y = sigmoid(p)+ rnom_scope / 2

      data.frame(x,y)

      #7. add Circle data sets
    } else if(input$task == "7.Circle"){

      angle  = runif(amount * 2, 0, 360)
      radius = rnorm(amount * 2, 16, 3)

      data.frame(
        x = sqrt(radius) * cos(2 * pi * angle) + rnom_scope * 2,
        y = sqrt(radius) * sin(2 * pi * angle) + rnom_scope * 2
      )

      #8. add Spiral data sets
    } else if(input$task == "8.Spiral"){

      r = c(1: (amount * 2)) / 200 * 5
      t = 1.75 * c(1: (amount * 2))  / 200 * 2 * pi
      x = r * sin(t) + rexp_scope * 3
      y = r * cos(t) + rexp_scope * 3

      data.frame(x, y)

      #9. add Parabola To Right data sets
    } else if(input$task == "9.Parabola To Right"){

      x  = rexp(amount * 2, 1) + rnom_scope
      y1 = sqrt(4 * x) + rnom_scope * 2
      y2 = -sqrt(4 * x) + rnom_scope * 2
      y  = c(y1,y2)

      data.frame( x, y)

      #10. add Spiral ascend (3D) data sets
    } else if(input$task == "10.Spiral ascend (3D)"){

      z = rexp(amount,1)*4
      x = sin(z)
      y = cos(z)

      data.frame(x, y, z)

      ### add clustering data sets
      #1. add Clustering Dataset 1
    } else if(input$task == "1.Clustering Dataset 1"){

      x1 = rnorm(amount, 0, 5) + rexp_scope
      x2 = rexp(amount,1) + rexp_scope
      x3 = runif(amount,-2,2) + rexp_scope
      y1 = rnorm(amount, 0, 5) + rexp_scope
      y2 = rexp(amount,1) + rexp_scope
      y3 = runif(amount,-2,2) + rexp_scope

      x  = c(x1/3 + 3, x2/3 - 3, x3/3 + 1)
      y  = c(y1/3 + 3, y2/3 - 1, y3/3 -2)

      data.frame(x, y)

      #2. add Clustering Dataset 2
    } else if(input$task == "2.Clustering Dataset 2"){

      radius = c(101 : amount) / 200 * 5
      angle  = 1.75 * c(101 : amount)  / 200 * 2 * pi
      x      = c(sin(angle), sin(angle + pi)) * radius + rexp_scope
      y      = c(cos(angle), cos(angle + pi)) * radius + rexp_scope

      data.frame(x, y)

      #3. add Clustering Dataset 3
    } else if(input$task == "3.Clustering Dataset 3"){

      angle     = runif(amount * 2, 0, 360)
      radius    = rexp(amount, 1)
      p1        = c(0 : (amount - 1)) * pi/200
      p2        = c(100 : (amount + 99)) * pi/200
      p3        = sqrt(radius) * cos(2 * pi * angle)
      x         = c(p1, p2, p3 - 2) + rexp_scope

      y_class1  = sin(p1) + runif(amount, -1, 1) / 4
      y_class2  = sin(p2+pi/2) + runif(amount, -1, 1) / 4
      y_class3  = sqrt(radius) * sin(2*pi*angle)
      y         = c(y_class1, y_class2, y_class3) + rexp_scope

      data.frame(x, y)

      #4. add Clustering Dataset 4
    } else if(input$task == "4.Clustering Dataset 4"){

      angle         = runif(amount * 2, 0, 360)
      r_class1 = rnorm(amount, 8, 3)
      r_class2 = rnorm(amount, 32, 3)
      r_class3 = rnorm(amount, 64, 3)
      r_class4 = rnorm(amount, 128, 3)

      data.frame(
        x = sqrt(c(r_class1, r_class2,r_class3,r_class4)) * cos(2*pi*angle),
        y = sqrt(c(r_class1, r_class2,r_class3,r_class4)) * sin(2*pi*angle)
      )

      #5. add Clustering Dataset 5
    } else if(input$task == "5.Clustering Dataset 5"){

      x1 = rnorm(amount, 0, 5)
      x2 = rnorm(amount, 3, 5) + 4
      x3 = rnorm(amount, 8, 5) - 2
      x  = c(x1,x2,x3)
      y1 = 0.5 * x1 + rnorm(amount, 0, 1)
      y2 = 0.5 * x2 + rnorm(amount, 0, 1) + 6
      y3 = 0.5 * x3 + rnorm(amount, 0, 1) -  6
      y  = c(y1,y2,y3)

      data <- data.frame(x,y)

      #6. add Clustering Dataset 6
    } else if(input$task == "6.Clustering Dataset 6"){

      x1     = runif(amount,-5,5)
      y1     = runif(amount,-5,5)

      angle  = runif(amount, 0, 360)
      radius = rexp(amount, 1)
      x2     = sqrt(radius) * cos(2 * pi * angle) + 2
      y2     = sqrt(radius) * sin(2 * pi * angle) + 4

      x3     = sqrt(radius) * cos(2 * pi * angle) + 0.8
      y3     = sqrt(radius) * sin(2 * pi * angle) - 0.4

      x4     = rexp(amount, 1) + runif_scope * 3
      y4     = c(sqrt(4 * x4),-sqrt(4 * x4)) + runif_scope * 3

      x      = c(x1, x2, x3, -x4, -x4)
      y      = c(y1, y2, y3, y4)

      data.frame(x, y)

    }
  }
})
