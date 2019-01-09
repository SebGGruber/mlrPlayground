#input ratio of the numSample, output classify_data
#data type: 2 dimension 

#range: cycle
output$circle_data <- renderTable({
        circle_ratio <- input$ratio
        
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
        ci<-rbind(circle,circle2)
    #plot(ci[,1:2],pch=20,col=c("red","green")[ci[,3]])
        return(ci)
    })