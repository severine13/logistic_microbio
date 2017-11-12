
# Shiny app allowing: plot and parameters for microbial growth dataset
# Severine Martini, Marc Garel, Christian Tamburini
### October 2017


library(shiny)

shinyServer(function(input, output) {
  output$contents <- renderTable({
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    dd<-read.csv(inFile$datapath, header=input$header, sep=input$sep, 
             quote=input$quote)
    do<-reactiveValues(data=dd)
    
    output$plot <- renderPlot({
   #   plot(dd$H,dd$A, pch=19, xlab="Time(h)", ylab="DO600nm")
  #    lines(dd$H,SSlogis(summary(fit)$parameters[1,1],summary(fit)$parameters[2,1],summary(fit)$parameters[3,1]))
  #    crssce=data.frame(dd$H,dd$A)
  #    SSlogis(dd$H,asym,xmid,scal)
  #   coef=getInitial(dd$A~SSlogis(dd$H,asym,xmid,scal),data=crssce)
  #    lines(dd$H,SSlogis(dd$H,coef[1],coef[2],coef[3]),lwd=1.5,col="blue")
  #    grid(col="grey")
      
      
      ##############
      x=rep(dd[,1],ncol(dd)-1)
      y=unlist(dd[,2:ncol(dd)])
      crssce=data.frame(y,x)
      w0=seq(0,90)
      #modlog2=nls(x ~ SSlogis(y,Asym,xmid,scal),crssce)
      modlog=nls(y ~ SSlogis(x,Asym,xmid,scal),crssce)
      coef=getInitial(y~SSlogis(x,asym,xmid,scal),data=cbind.data.frame(x,y))
      mu=1/coef[3]
      plot(x,y)
      points(x,y,xlim=c(0,90),ylim=c(0,1.1),xlab="temps(h)",ylab="DO600nm",las=1,pch=22,bg=1)
      lines(w0,SSlogis(w0,coef[1],coef[2],coef[3]),lwd=1.5)
      # ou, ce qui revient au mÃªme
      
      #x=dd[,1]
      #y=dd[]
      #coef=getInitial(y~SSlogis(x,asym,xmid,scal),data=cbind.data.frame(x,y))
      #mu=1/coef[3]
      #plot(x,y)
      #points(x,y,xlim=c(0,90),ylim=c(0,1.1),xlab="temps(h)",ylab="DO600nm",las=1,pch=22,bg=1)
      #lines(w0,SSlogis(w0,coef[1],coef[2],coef[3]),lwd=1.5)
      
      ###############
      
      observeEvent(input$clicks, {print(as.numeric(do$data))})
     
    })
    # 
  })

})

# shinyServer(function(input, output, session) {
#output$main_plot <- renderPlot({
#    plot(dd$H,dd$A, type=input$plotType)

#   
#   
#   output$table <- DT::renderDataTable({
#     DT::datatable(cars)
#   })
# })
