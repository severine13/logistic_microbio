# Shiny app allowing: plot and parameters for microbial growth dataset
# Marc Garel, Severine Martini, Christian Tamburini
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
      
      
      ##############
      x=rep(dd[,1],ncol(dd)-1)
      y=unlist(dd[,2:ncol(dd)])
      crssce=data.frame(y,x)
      require("quantreg")
      # limit axes extended
      maxx=max(x,na.rm=T)+(max(x,na.rm=T)/4)
      maxy=max(y,na.rm=T)+(max(y,na.rm=T)/4)
      w0=seq(0,maxx)
      # modlog2=nls(x ~ SSlogis(y,Asym,xmid,scal),crssce)
      # modlog=nls(y ~ SSlogis(x,Asym,xmid,scal),crssce)
      coef=getInitial(y~SSlogis(x,asym,xmid,scal),data=cbind.data.frame(x,y))
      mu=1/coef[3]
      # output plot
      plot(x,y)
      points(x,y,xlim=c(0,maxx),ylim=c(0,maxy),xlab="temps(h)",ylab="DO600nm",las=1,pch=22,bg=1)
      lines(w0,SSlogis(w0,coef[1],coef[2],coef[3]),lwd=1.5)
      q1b=nlrq(y~SSlogis(x,K, xmid, r),tau=0.25,data=crssce)
      q3b=nlrq(y~SSlogis(x,K, xmid, r),tau=0.75,data=crssce)
      q05b=nlrq(y~SSlogis(x,K, xmid, r),tau=0.025,data=crssce)
      q95b=nlrq(y~SSlogis(x,K, xmid, r),tau=0.975,data=crssce)
      lines(w0, predict(q1b, newdata=list(x=w0)), col="blue",lty=2)
      lines(w0, predict(q3b, newdata=list(x=w0)), col="blue",lty=2)
      lines(w0, predict(q05b, newdata=list(x=w0)), col="blue",lty=3)
      lines(w0, predict(q95b, newdata=list(x=w0)), col="blue",lty=3)

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