require("class")


shinyServer(function(input,output){
    
######################################
shinyjs::addClass(id = "mlrlink", class = "navbar-right")

  server.files = list.files(path = "./server", pattern = "*.R")
  server.files = paste0("server/", server.files)
  for (i in seq_along(server.files)) {
    source(server.files[i], local = TRUE)
  hide(id = "loading-content", anim = TRUE, animType = "fade")    
  show("app-content")
  }

#   session$onSessionEnded(stopApp)
        
    
})