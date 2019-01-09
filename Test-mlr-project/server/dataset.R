output$circle_data <- renderPlotly({
    angle = runif(400,0,360)
    radius_class1 = rexp(200,1)
    radius_class2 = rnorm(200,16,3)

    data = data.frame(
        x = sqrt(c(radius_class1,radius_class2)) * cos(2*pi*angle),
        y = sqrt(c(radius_class1,radius_class2)) * sin(2*pi*angle),
        class = c(rep("Class 1",200),rep("Class 2",200))
    )
    
    plotly::plot_ly(
        data = data,
        x = ~x,
        y = ~y,
        color = ~class,
        colors = c("#2b8cbe", "#e34a33"),
        type = "scatter",
        mode = "markers"
        )
    })