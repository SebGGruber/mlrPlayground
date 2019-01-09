#input ratio of the numSample, output classify_data
#data type: 2 dimension 

#range: cycle
output$circle_data <- renderPlotly({
        circle_ratio <- input$ratio
        

#outside circle dataset
        generate_circle_data<-function(num){
            emp.data<-data.frame(
                x=c(0),
                y=c(0),
                z=c(1)
            )
            while(num>0){
                a = runif(1,0,1) * 2 * pi
                r = sqrt(runif(1,0,1))
                # print(a,r)
                x = r * cos(a)
                y = r * sin(a)
                z = 1
                emp.newdata<-data.frame(x,y,z)
                emp.data<-rbind(emp.data,emp.newdata)
                num=num-1
            }
            return(emp.data)
        
        }
        circle<-generate_circle_data(circle_ratio)

    #inside circle dataset
        generate_ring_data<-function(num){
            emp.data<-data.frame(
                x=c(0),
                y=c(0),
                z=c(2)
            )
            a=0
            r=0
            while(num>0){
                
                a = runif(1,0,1) * 2 * pi
                r = sqrt(runif(1,1.5,2))
                # print(a,r)
                x = 2 * r * cos(a)
                y = 2 * r * sin(a)
                z = 2
                emp.newdata<-data.frame(x,y,z)
                emp.data<-rbind(emp.data,emp.newdata)
                num=num-1
            }
            return(emp.data)
        }
        circle2<-generate_ring_data(circle_ratio)
        circle_data<-rbind(circle2,circle)
        plot_ly(circle_data, type = "scatter",x=~x,y=~y,color = ~z,colors = c("#2b8cbe", "#e34a33"),mode = "markers")
   # plotly(circle_data[,1:2],pch=20,col=c("red","green")[circle_data[,3]])
        # return(plot(ci[,1:2],pch=20,col=c("red","green")[ci[,3]]))
    })



#input ratio of the numSample, output Gaussian distribution Dataset
#data type: 2 dimension 

#range: Gaussian point
output$Gaussian_data <- renderPlotly({
        plotly::plot_ly(
        data = data,
        x = ~x1,
        y = ~x2,
        color = ~class,
        colors = c("#2b8cbe", "#e34a33"),
        type = "scatter",
        mode = "markers"
        )
        Gaussian_ratio <- input$ratio
        normalRandom<-function(mean,variance){
            #  if(!exists(mean)) { mean = 0 }
            #  if(!exists(variance)) { variance = 1 }
            s = 0
            {
                v1 = 2 * runif(1,0,1) - 1
                v2 = 2 * runif(1,0,1) - 1
                s = v1 * v1 + v2 * v2 
            } 
            while(s > 1)
            {
                v1 = 2 * runif(1,0,1) - 1
                v2 = 2 * runif(1,0,1) - 1
                s = v1 * v1 + v2 * v2 
            } 
            result = sqrt(-2 * log(s) / s) * v1
            return(mean + sqrt(variance) * result) 
            
        }


        genGauss<-function(cx,cy,label,Gaussian_ratio){
            emp.data<-data.frame(
                x=c(0),
                y=c(0),
                z=c(1)
            )
            variance = 1
            while(Gaussian_ratio > 0){
                x = normalRandom(cx,variance)  
                y = normalRandom(cy,variance)
                z = label
                emp.newdata<-data.frame(x,y,z)
                emp.data <- rbind(emp.data,emp.newdata) 
                Gaussian_ratio = Gaussian_ratio-1
            }
            return(emp.data[-1,])
        }

        emp.data_p<-genGauss(2,2,1,Gaussian_ratio)
        emp.data_n<-genGauss(-2,-2,2,Gaussian_ratio)

        data = as.data.frame(rbind(emp.data_p,emp.data_n))
        # plotly(Gaussian_data[,1:2],pch=20,col=c("red","green")[Gaussian_data[,3]])
        
    })




#input ratio of the numSample, output Spiral distribution Dataset
#data type: 2 dimension 

#range: Spiral point
output$Spiral_data <- renderPlotly({
        Spiral_ratio <- input$ratio
        n = Spiral_ratio / 2
        genspiral<-function(deltaT, label, n){
            emp.data<-data.frame(
            x=c(0),
            y=c(0),
            z=c(1)
            )
            range_num = c(0:n)
            for(i in range_num){
            r = i / n *  5
            t = 1.75 * i / n * 2 * pi +  deltaT
            x = r * sin(t)
            y = r * cos(t)
            z = label
            emp.newdata<-data.frame(x,y,z)
            emp.data <- rbind(emp.data,emp.newdata)
            
            }
            return(emp.data[-1,])
        }
        
        
        spiral_0<-genspiral(0,1,n)
        spiral_pi<-genspiral(pi,2,n)
        spiral_data<-rbind(spiral_0,spiral_pi)
        plot(spiral_data[,1:2],pch=20,col=c("red","green")[spiral_data[,3]])         
    })



#input ratio of the numSample, output Spiral distribution Dataset
#data type: 2 dimension 

#range: Spiral point
output$XOR_data <- renderPlotly({
        XOR_ratio <- input$ratio    
        getXORLable<-function(x,y){
            mul = x * y
            if(mul >= 0){
                return(1)
            }else{
                return(2)
            }
        }

        emp.data<-data.frame(
                x=c(0),
                y=c(0),
                z=c(1)
            )
        i=0
        while(i < XOR_ratio){
            x = runif(1,-5,5)
            padding = 0.3
            if(x > 0){
                x = x + padding
            }else{
                x = x - padding
            }
            y = runif(1,-5,5)
            if(y > 0){
                y = y + padding
            }else{
                y = y - padding
            }
            z=getXORLable(x,y)
            emp.newdata<-data.frame(x,y,z)
            emp.data <- rbind(emp.data,emp.newdata)
            i=i+1
        }
        plot(emp.data[-1,1:2],pch=20,col=c("red","green")[emp.data[-1,3]])     
    })





















#   # Reactive expression to compose a data frame containing all of the values
#   sliderValues <- reactive({

#     # Compose data frame
#     data.frame(
#       Name = c("Integer", 
#                "Decimal",
#                "Range",
#                "Custom Format",
#                "Animation"),
#       Value = as.character(c(input$integer, 
#                              input$decimal,
#                              paste(input$range, collapse=' '),
#                              input$format,
#                              input$animation)), 
#       stringsAsFactors=FALSE)
#   }) 

#   # Show the values using an HTML table
#   output$values <- renderTable({
#     sliderValues()
#   })