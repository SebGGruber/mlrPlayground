tabpanel.import = fluidPage(theme = shinytheme("united"),
                            sidebarLayout(
                                 sidebarPanel(
                                    width = 3,
                                    fileInput('file1','Choose CSV File',
                                                accept=c('text/csv','text/comma-separated-value,text/plain','.csv')),
                                                tags$hr(),
                                                checkboxInput('header','Header',TRUE),
                                                radioButtons('sep','Separator',
                                                                c(Comma=',',
                                                                Semicolon=';',
                                                                Tab='\t'),
                                                                selected = ","),
                                                radioButtons('quote','Quote',
                                                                c(None='',
                                                                'Double Quote '='"',
                                                                'Single Quote '="'"),
                                                                selected = '"'),
                                                
                                                tags$hr(),

                                                radioButtons("disp","Display",
                                                              choices = c(Head = "head",
                                                                         All = "all"),
                                                              selected = "head")
                                ),
                                mainPanel(
                                    width = 9,
                                    tableOutput('contents')
                                )
                            )
                            )