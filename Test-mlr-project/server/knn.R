   #classification KNN
    output$classification_knn_train <- renderTable({
     
        #loading train file
        inTrainFile <- input$file_train

        if(is.null(inTrainFile))
            return(NULL)
        
        train_file <-read.csv(inTrainFile$datapath,header=input$header)

        if(input$disp_trainfile == "head"){
            return(head(train_file))
        }
        else{
            return(train_file)
        }
    })
    output$classification_knn_test <- renderTable({
        #loading test file
        inTestFile <- input$file_test

        if(is.null(inTestFile))
            return(NULL)
        
        test_file <-read.csv(inTestFile$datapath,header=input$header)

        if(input$disp_testfile == "head"){
            return(head(test_file))
        }
        else{
            return(test_file)
        }
    })
        
    ########################################
output$classification_knn_result <- renderTable({
    inTrainFile <- input$file_train

        if(is.null(inTrainFile))
            return(NULL)
        
        train_file <-read.csv(inTrainFile$datapath,header=input$header,
        sep=input$sep,quote=input$quote)

    inTestFile <- input$file_test

        if(is.null(inTestFile))
            return(NULL)
        
        test_file <-read.csv(inTestFile$datapath,header=input$header,
        sep=input$sep,quote=input$quote)

    
    
    if(is.na(input$k_value)){
        return(NULL)
    }else if(input$disp_resultfile == "head") {
        model1<- knn(train=train_file[,2:5], test=test_file[,2:5], cl=train_file[,6], k=input$k_value)
        return(head(model1))
    }else{
        model1<- knn(train=train_file[,2:5], test=test_file[,2:5], cl=train_file[,6], k=input$k_value)
        return(model1)
    }
})