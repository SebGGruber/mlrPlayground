tabpanel.Classification_KNN = fluidPage(theme = shinytheme("united"),
                            sidebarLayout(
                                 sidebarPanel(
                                    width = 3,
                                    fileInput('file_train','Choose Train File',
                                                accept=c('text/csv','text/comma-separated-value,text/plain','.csv')),
                                                # tags$hr(),
                                                # checkboxInput('header','Header',TRUE),
                                                # radioButtons('sep','Separator',
                                                #                 c(Comma=',',
                                                #                 Semicolon=';',
                                                #                 Tab='\t'),
                                                #                 selected = ","),
                                                # radioButtons('quote','Quote',
                                                #                 c(None='',
                                                #                 'Double Quote '='"',
                                                #                 'Single Quote '="'"),
                                                #                 selected = '"'),
                                                
                                                # tags$hr(),

                                    radioButtons("disp_trainfile","Display",
                                                choices = c(Head = "head",All = "all"),
                                                selected = "head"),

                                    fileInput('file_test','Choose Test File',
                                                accept=c('text/csv','text/comma-separated-value,text/plain','.csv')),
                                    radioButtons("disp_testfile","Display",
                                                    choices = c(Head = "head",All = "all"),
                                                    selected = "head"),

                                    numericInput("k_value", "K:", NULL),

                                    radioButtons("disp_resultfile","Result Display",
                                                    choices = c(Head = "head",All = "all"),
                                                    selected = "head"),
                                    submitButton("RUN")
                                ),
                               
                                mainPanel(
                                    width = 9,
                                    tableOutput('classification_knn_train'),
                                    tableOutput('classification_knn_test'),
                                    tableOutput('classification_knn_result')
                                )
                            )
                        )