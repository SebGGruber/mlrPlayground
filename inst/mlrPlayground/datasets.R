calculate_data = function(task, amount, noise, train.ratio, seed = 123, rescope = 1) {

  set.seed(seed)

  white_noise      = rnorm(amount, 0, noise)

  ##add classification datasets
  #1.add Circle data sets
  if (task == "Circle") {

    amount        = amount / 2
    angle         = runif(2 * amount, 0, 360)
    radius_class1 = rexp(amount, 1 / (5 *  noise))
    radius_class2 = rnorm(amount, 16, 10 * noise)
    radius_class  = c(radius_class1, radius_class2)
    x1            = sqrt(abs(radius_class)) * cos(2*pi*angle) * rescope
    x2            = sqrt(abs(radius_class)) * sin(2*pi*angle) * rescope
    class         = c(rep("Class 1", amount), rep("Class 2", amount))

    data.frame(x1,x2,class)

    #2.add two-circle data sets
  } else if (task == "Two Circle") {

    amount        = amount / 2
    angle         = runif(amount * 2, 0, 360)
    radius_class1 = rnorm(amount, 6, 10 * noise)
    radius_class2 = rnorm(amount, 16, 10 * noise)
    radius_class  = c(radius_class1, radius_class2)
    x1            = sqrt(abs(radius_class)) * cos(2*pi*angle) * rescope
    x2            = sqrt(abs(radius_class)) * sin(2*pi*angle) * rescope
    x2_1          = x2[1 : amount]
    x2_2          = x2[(amount + 1) : (amount * 2)]
    class_1       = ifelse(x2_1 >= 0,"Class 1", "Class 2")
    class_2       = ifelse(x2_2 <  0,"Class 1", "Class 2")
    class         = c(class_1,class_2)

    data.frame(x1,x2,class)

    #3.add two-circle-2 data sets
  } else if (task == "Two Circle + Point") {

    amount1         = round(amount / 2)
    angle           = runif(amount, 0, 360)
    radius_class1   = rnorm(amount1, 6, 10 * noise)
    amount2         = amount - amount1
    amount2_1       = round(amount2/2)
    amount2_2       = amount2 - amount2_1
    radius_class2_1 = rexp(amount2_1, 1 / (5 * noise))
    radius_class2_2 = rnorm(amount2_2, 16, 10 * noise)
    radius_class    = c(radius_class2_1,radius_class1, radius_class2_2)
    x1              = sqrt(abs(radius_class)) * cos(2*pi*angle) * rescope
    x2              = sqrt(abs(radius_class)) * sin(2*pi*angle) * rescope
    class_1         = c(rep("Class 2",amount2_1),rep("Class 1", amount1))
    class           = c(class_1, rep("Class 2", amount2_2))

    data.frame(x1, x2, class)

    #4.add XOR data sets
  } else if (task == "XOR") {

    amount  = amount / 2
    rescope = 0.8
    x1      = runif(amount, -5, 5)
    x2      = runif(amount, -5, 5)
    xor     = (x1 < 0 | x2 < 0) & !(x1 < 0 & x2 < 0)
    class   = ifelse(xor, "Class 1", "Class 2")

    x1      = (x1 + white_noise) * rescope
    x2      = (x2 + white_noise) * rescope

    data.frame(x1, x2, class)

    #5.add Gaussian data sets
  } else if(task == "Gaussian"){

    amount  = amount / 2
    rescope = 0.8
    x1      = c(rnorm(amount, 2, 1), rnorm(amount, -2, 1)) - 0.5
    x2      = c(rnorm(amount, 2, 1), rnorm(amount, -2, 1))
    class   = c(rep("Class 1", amount), rep("Class 2", amount))

    x1      = (x1 + white_noise) * rescope
    x2      = (x2 + white_noise) * rescope

    data.frame(x1, x2, class)

    #6.add Across Spiral data sets
  } else if(task == "Across Spiral"){

    amount   = amount / 2
    rescope  = 1.5
    r        = c(1 : amount) / amount * 5
    angle    = 1.75 * c(1 : amount)  / amount * 2 * pi
    x1       = c(sin(angle), sin(angle + pi)) * r
    x2       = c(cos(angle), cos(angle + pi)) * r
    class    = c(rep("Class 1",amount),rep("Class 2",amount))

    x1       = (x1 / 2 + white_noise) * rescope
    x2       = (x2 / 2 - white_noise) * rescope

    data.frame(x1, x2, class)

    #7. add Opposite Arc data sets
  } else if(task == "Opposite Arc"){

    amount   = amount / 2
    rescope  = 1.5
    range1   = runif(amount,0,1) * pi
    range2   = runif(amount,0.5,1.5) * pi
    x1       = c(range1, range2)

    arc1     = sin(range1)
    arc2     = cos(range2) + 0.5
    x2       = c(arc1, arc2) * 2
    class    = c(rep("Class 1", amount), rep("Class 2", amount))

    x1       = (x1 - white_noise * 1.5) * rescope - 2
    x2       = (x2 - white_noise * 1.5) * rescope

    data.frame(x1, x2, class)

    #8.add Cross Sector data sets
  } else if (task == "Cross Sector") {

    rescope = 0.8
    amount        = amount / 2
    part          = c(0 : 9)
    angle         = runif(amount, 0, 36)
    angle_class1  = 2 * pi * (angle + 36 * 2 * part) / 360
    angle_class2  = 2 * pi * (angle  + 36 * (2 * part + 1)) / 360
    radius_class1 = rexp(amount, 1)
    radius_class2 = rexp(amount, 2)

    x1_class1     = sqrt(radius_class1) * cos(angle_class1)
    x1_class2     = sqrt(radius_class2) * cos(angle_class2)
    x1            = c(x1_class1, x1_class2)

    x2_class1     = sqrt(radius_class1) * sin(angle_class1)
    x2_class2     = sqrt(radius_class2) * sin(angle_class2)
    x2            = c(x2_class1, x2_class2)
    class         = c(rep("Class 1", amount), rep("Class 2", amount))

    x1            = (x1 + white_noise/5) * 2 * rescope
    x2            = (x2 + white_noise/5) * 2 * rescope

    data.frame(x1, x2, class)

    #9.add Wavy surface(3D) data sets
  } else if(task == "Wavy surface"){

    amount= amount / 2
    kern  = runif(amount,-20,20) * pi /5
    x     = (rep(kern,41) + white_noise) * rescope /2
    y     = (rep(kern,each=41) + white_noise) * rescope /2
    z     = (sin(x) + sin(y) + rnorm(length(y), 0, 1) * noise) * rescope
    con   = z > 0.5 | z < -0.5
    class = ifelse(con, "Class 1","Class 2")

    data.frame(x,y,z,class)

    #10.add Sphere (3D) data sets
  } else if(task == "Sphere"){
    amount   = amount / 2
    R        = 2
    alfa     = runif(amount, 0, 50)* pi
    sita     = runif(amount, 0, 50)* pi * 2

    num_alfa = length(alfa)
    num_sita = length(sita)

    x        = matrix(0, num_alfa, num_sita)
    y        = matrix(0, num_alfa, num_sita)
    z        = matrix(0, num_alfa, num_sita)
    class    = matrix(0, num_alfa, num_sita)

    x        = sapply(alfa,function(a)
      sapply(sita,function(b) sin(a) * cos(b) * R))

    y        = sapply(alfa,function(a)
      sapply(sita,function(b) sin(a) * sin(b) * R))

    z        = sapply(alfa,function(a)
      sapply(sita,function(b) cos(a) * R))

    xor      = (x < 0 | y < 0) & !(x < 0 & y < 0)
    class    = ifelse(xor,"Class 1","Class 2")

    x        = as.vector(x + white_noise) * rescope
    y        = as.vector(y + white_noise) * rescope
    z        = as.vector(z + white_noise) * rescope
    class    = as.vector(class)

    data.frame(x,y,z,class)

    ### add regression data sets
    #1.add normal linear data sets
  } else if (task == "Linear ascend") {

    x = rnorm(amount, 0, 1)
    y = x / max(abs(x)) + white_noise

    data.frame(x, y)

    #2.dd Log function data sets
  } else if(task == "Log linear"){

    x = rexp(amount, 2)
    y = log10(x)
    y = y / max(abs(y)) + white_noise


    data.frame(x, y)

    #3.add Polyline data sets
    # DO NOT USE IN CURRENT STATE!!!!!!!!
  } else if(task == "Polyline"){

    x_amount = round(amount/16)
    x1       = runif(x_amount,-4,-3.5)
    x2       = runif(x_amount,-3.5,-3)
    x3       = runif(x_amount,-3,-2.5)
    x4       = runif(x_amount,-2.5,-2)
    x5       = runif(x_amount,-2,-1.5)
    x6       = runif(x_amount,-1.5,-1)
    x7       = runif(x_amount,-1,-0.5)
    x8_amount= amount-round(amount/2)-7*x_amount
    x8       = runif(x8_amount,-0.5,0)
    x9       = runif(round(amount/2),0.1,5)
    x        = c(x1,x2,x3,x4,x5,x6,x7,x8,x9)


    y1       = (-10* x1 - 37)/8
    y2       = (10 * x2 + 33)/7
    y3       = (-10* x3 - 27)/6
    y4       = (10 * x4 + 23)/5
    y5       = (-10* x5 - 17)/4
    y6       = (10 * x6 + 13)/3
    y7       = (-10* x7 - 7)/2
    y8       = 10 * x8 + 3
    y9       = -log2(x9*100) + 6.1
    y        = c(y1,y2,y3,y4,y5,y6,y7,y8,y9) + rnorm(16*x_amount, 0, noise)

    data.frame(x,y)

    #4.add Ascend Cosine data sets
  } else if(task == "Ascend Cosine"){

    x = runif(amount, 0, 4 * pi)
    y = cos(x) + x/4
    y = y / max(abs(y)) + white_noise


    data.frame(x,y)

    #5.add Tangent data sets
  } else if(task == "Tangent"){

    x = runif(amount,-4.2,4.2)
    y = tan(x * pi / 10) + white_noise

    data.frame(x, y)

    #6. add Sigmoid data sets
  } else if(task == "Sigmoid"){

    sigmoid = function(x) {
      1 / (1 + exp(-x))
    }

    x = runif(amount, -5, 5)
    y = sigmoid(2 * x)
    y = y / max(abs(y)) + white_noise



    data.frame(x,y)

    #7. add Three Line data sets
  } else if(task == "Three Line"){

    x_amount  = round(amount/3)
    x3_amount = amount - x_amount * 2
    x1        = runif(x_amount,-5,-1)
    x2        = runif(x_amount,-1,2)
    x3        = runif(x3_amount,2,5)
    x         = c(x1,x2,x3)
    y1        = rep(3, x_amount)
    y2        = rep(-3, x_amount)
    y3        = rep(0.5, x3_amount)
    y        = c(y1, y2, y3)
    y        = y / max(abs(y)) + white_noise

    data.frame(x,y)

    #8. add Amplification Sine data sets
  } else if(task == "Amplification Sine"){

    x1 = c((1-1 / 2 * amount) : 0) * pi/150
    x2 = c(0 : ((1 / 2 * amount) - 1)) * pi/150
    x  = c(x1,x2)
    y  = (sin(6 * x))*((-amount/2):(amount/2-1))/40 + white_noise

    data.frame(x, y)

    #9. add Parabola To Right data sets
  } else if(task == "Parabola To Right"){
    x_amount = amount / 2
    x1       = rexp(x_amount, 2)
    x2       = rexp(x_amount, 2)
    x        = c(x1, x2)
    y1       = sqrt(x1)
    y2       = -sqrt(x2)
    y        = c(y1, y2)
    y        = y / max(abs(y)) + white_noise

    data.frame(x, y)

    #10. add Precipice data sets
  } else if(task == "Precipice"){

    x_amount  = round(amount/7)
    x4_amount = amount - x_amount * 4
    x1        = c(runif(x_amount,-5,-3),runif(x_amount,-2,-1))
    x2        = runif(x_amount,-3,-2.5)
    x3        = runif(x_amount,-2.5,-2)
    x4        = runif(x4_amount,-1,2*pi-1)
    x         = c(x1,x2,x3,x4)

    y1        = rep(3, x_amount*2)
    y2        = -10 * x2 - 27
    y3        = 10 * x3 + 23
    y4        = cos(x4 + 1) + 2
    y        = c(y1, y2, y3, y4)
    y        = y / max(abs(y)) + white_noise

    data.frame(x, y)

    #11. add Spiral ascend (3D) data sets
  } else if(task == "Spiral ascend"){

    angle        = sort(runif(amount, 0, 6 * pi))
    radius_class = sort(runif(amount, 3, 20))
    x            = radius_class * cos(angle) + runif(amount, -noise, noise)
    y            = radius_class * sin(angle) + runif(amount, -noise, noise)
    z            = (c(1:amount) + runif(amount, -noise, noise) * 100)

    x            = x * rescope / 4
    y            = y * rescope / 4
    z            = z * rescope / 100


    data.frame(x, y, z)

    ### add clustering data sets
    #1. add Clustering Dataset 1
  } else if(task == "Normal Points + Uniform Square"){

    x1 = rnorm(amount, 0, 10 *noise)
    x2 = rnorm(amount, 0, 10 *noise)
    x3 = runif(amount,-4,4)*noise*3
    y1 = rnorm(amount, 0, 2)
    y2 = rnorm(amount, 0, 3)
    y3 = runif(amount,-4,4) * noise*3

    x  = c(x1/3 + 2, x2/3 - 3, x3/3 + 1)
    y  = c(y1/3 + 2, y2/3 - 1, y3/3 -2)

    x  = x * rescope
    y  = y * rescope

    data.frame(x, y)

    #2. add Clustering Dataset 2
  } else if(task == "Two Spiral"){

    radius = sort(runif(amount, 101,200))
    angle  = 1.75 * sort(runif(amount, 101,200))/100 * pi
    x      = c(sin(angle), sin(angle + pi)) * radius /50
    y      = c(cos(angle), cos(angle + pi)) * radius /50


    x      = (x + white_noise * 2 ) * rescope
    y      = (y + white_noise * 2 ) * rescope

    data.frame(x, y)

    #3. add Clustering Dataset 3
  } else if(task == "Points + Sine"){

    angle     = runif(amount * 2, 0, 360)
    radius    = rexp(amount, 1)
    p1        = runif(amount,0,1) * pi
    p2        = runif(amount,0.5,1.5) * pi
    p3        = sqrt(radius) * cos(2 * pi * angle)
    x         = c(p1, p2, p3 - 2)

    y_class1  = sin(p1)
    y_class2  = cos(p2)
    y_class3  = sqrt(radius) * sin(2*pi*angle)
    y         = c(y_class1, y_class2, y_class3) + white_noise

    x         = (x - white_noise * 1.5) * rescope
    y         = (y - white_noise * 1.5) * rescope

    data.frame(x, y)

    #4. add Clustering Dataset 4
  } else if(task == "Three Circle"){

    angle    = runif(amount * 2, 0, 360)
    r_class1 = rnorm(amount, 8, 3)
    r_class2 = rnorm(amount, 32, 3)
    r_class3 = rnorm(amount, 128, 3)
    r_class  = c(r_class1, r_class2,r_class3)
    x        = sqrt(abs(r_class)) * cos(2 * pi * angle) / 3 + white_noise
    y        = sqrt(abs(r_class)) * sin(2 * pi * angle) / 3 + white_noise

    x        = x * rescope
    y        = y * rescope

    data.frame(x, y)

    #5. add Clustering Dataset 5
  } else if(task == "Three Slant"){

    x1 = rnorm(amount, 0, 5)
    x2 = rnorm(amount, 3, 5) + 4
    x3 = rnorm(amount, 8, 5) - 2
    x  = c(x1,x2,x3) / 5
    y1 = 0.5 * x1 + noise * rnorm(amount, 0, 1)
    y2 = 0.5 * x2 + noise * rnorm(amount, 0, 1) + 6
    y3 = 0.5 * x3 + noise * rnorm(amount, 0, 1) - 6
    y  = c(y1,y2,y3) / 4 + white_noise

    x  = x * rescope
    y  = y * rescope

    data.frame(x,y)

    #6. add Clustering Dataset 6
  } else if(task == "Parabola + Two Points"){

    x1     = runif(amount,-5,5)
    y1     = runif(amount,-5,5)

    angle  = runif(amount, 0, 360)
    radius = rexp(amount, 1)
    x2     = sqrt(radius) * cos(2 * pi * angle) + 2
    y2     = sqrt(radius) * sin(2 * pi * angle) + 2

    x3     = sqrt(radius) * cos(2 * pi * angle) + 2
    y3     = sqrt(radius) * sin(2 * pi * angle) - 2

    x4     = (rexp(amount, 1))%%5
    y4     = c(sqrt(4 * x4),-sqrt(4 * x4)) + white_noise

    x      = c(x1, x2, x3, -x4, -x4) + white_noise
    y      = c(y1, y2, y3, y4) + white_noise

    x      = x * rescope
    y      = y * rescope

    data.frame(x, y)

  }
}
