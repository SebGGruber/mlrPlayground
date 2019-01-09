tabpanel.datasets = fluidPage(theme = shinytheme("united"),
                            sidebarLayout(
                                 sidebarPanel(
                                    width = 3,
                                    navbarPage(
                                        "Data",
                                        tags$hr(),                                 
                                        actionButton(
                                            "circle_data",
                                            img(src="circle_data.png")
                                        ),
                                        
                                        tags$hr(), 
                                        actionButton(
                                            "Gaussian_Data",
                                             img(src="gaussian_data.png")
                                        #icon = icon("./img/circle_data.png")
                                         ),
                                        
                                        tags$hr(), 
                                        actionButton(
                                            "spiral_Data",
                                             img(src="spiral_data.png")
                                        #icon = icon("./img/circle_data.png")
                                         ),

                                        tags$hr(), 
                                        actionButton(
                                            "XOR_Data",
                                             img(src="XOR_data.png")
                                        #icon = icon("./img/circle_data.png")
                                         ),
                                        # Simple integer interval
                                         sliderInput("ratio", "Ratio of training to test data:", min=0, max=1000, value=500) 
                                    )
                                   ),
                                mainPanel(
                                    width = 4,
                                    plotly::plotlyOutput('circle_data')
                                    #plotlyOutput('Gaussian_data')
                                    #plotlyOutput('Spiral_data'),
                                    #plotlyOutput('XOR_data')
                                )
                            )
                        )