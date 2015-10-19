library(shiny)
library(ggplot2)

shinyServer(function(input, output, session) {
  
  inputAlpha <- reactive({
    as.numeric(input$alpha)
  })
  
  create_data <- reactive({
    means <- rep(NA, length=input$N)
    sds <- rep(NA, length=input$N)
    for(i in 1:input$N) {
      data <- rnorm(as.numeric(input$size), input$mean, input$sd)
      means[i] <- mean(data)
      sds[i] <- sd(data)
    }
    df <- data.frame(means=means, sds=sds)
    df
  })
  
  output$plot <- renderPlot({
    data <- create_data()
    
    x <- 1:input$N
    lower <- rep(NA, length=input$N)
    upper <- rep(NA, length=input$N)
    notcontained <- rep(NA, length=input$N)
    
    for(i in x) {
      se <- qt(1-(1-inputAlpha())/2, df=as.numeric(input$size)-1)*data$sds[i]/sqrt(as.numeric(input$size))
      lower[i] <- data$means[i]-se
      upper[i] <- data$means[i]+se
      notcontained[i] <- !(lower[i] < input$mean & upper[i] > input$mean)
    }
    
    df <- data.frame(x=x, mean=data$means, l=lower, u=upper, c=notcontained)
    ggplot(df, aes(x=x, y=mean)) +
      geom_point(size=4, aes(color=factor(c))) +
      geom_errorbar(aes(ymax=u, ymin=l, color=factor(c))) +
      scale_color_manual(values=c('black','blue')) +
      geom_hline(yintercept=input$mean)
    
  })
})