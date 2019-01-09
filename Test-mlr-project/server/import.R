output$contents <- renderTable({
        inFile  <- input$file1

        if(is.null(inFile))
            return(NULL)
        
        df <- read.csv(inFile$datapath,header=input$header,
        sep=input$sep,quote=input$quote)

        if(input$disp == "head"){
            return(head(df))
        }
        else{
            return(df)
        }
    })