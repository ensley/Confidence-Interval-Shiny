library(shiny)
library(ggvis)
library(dplyr)

shinyServer(function(input, output, session) {
  
  # alpha level for confidence intervals
  inputAlpha <- reactive({
    as.numeric(input$alpha)
  })
  
  # counter for number of intervals that don't contain the mean
  count <- reactiveValues(c=0)
  
  create_data <- reactive({

    means <- rep(NA, length=input$N)
    sds <- rep(NA, length=input$N)
    for(i in 1:input$N) {
      d <- rnorm(as.numeric(input$size), input$mean, input$sd)
      means[i] <- mean(d)
      sds[i] <- sd(d)
    }
    data.frame(means=means, sds=sds)
  
  })
  
  create_intervals <- reactive({
    
    data <- isolate({ create_data() })

    x <- 1:input$N
    lower <- rep(NA, length=input$N)
    upper <- rep(NA, length=input$N)
    notcontained <- rep(NA, length=input$N)
    
    for(i in x) {
      se <- qt(1-(1-input$alpha)/2, df=as.numeric(input$size)-1)*data$sds[i]/sqrt(as.numeric(input$size))
      lower[i] <- data$means[i]-se
      upper[i] <- data$means[i]+se
      notcontained[i] <- !(lower[i] < input$mean & upper[i] > input$mean)
    }
    
    df <- data.frame(x=x, mean=data$means, l=lower, u=upper, c=notcontained)
    
    isolate({
      count$c <- sum(notcontained)
    })
    
    df
    
  })
  
  data_tooltip <- function(p) {
    if (is.null(p)) return(NULL)
    
    all_pts <- isolate(create_intervals())
    pt <- all_pts[all_pts$x == p$x, ]
    
    contained_string = " "
    if(pt$c) { contained_string = " not " }
    
    paste0("<b>Sample mean: </b>", round(pt$mean,3), "<br>",
           "<b>Interval: </b>(", round(pt$l,3), ", ", round(pt$u,3), ")<br>",
           "True mean is", contained_string, "contained in the interval.")
  }
  
  vis <- reactive({
    
    create_intervals %>%
      ggvis(x = ~mean, y = ~x) %>%
      layer_rects(~l, ~x-as.numeric(input$N)/2000, x2 = ~u, y2 = ~x+as.numeric(input$N)/2000, stroke = ~as.factor(c)) %>%
      layer_points(size.hover := 200, fillOpacity := 0.8, fillOpacity.hover := 0.6) %>%
      add_tooltip(data_tooltip, 'hover') %>%
      set_options(height = 550, keep_aspect = T)
    
  })
  
  vis %>% bind_shiny('plot')
  
  output$count <- renderText({
    paste0(round(as.numeric(count$c)/as.numeric(input$N)*100,2),'% (',count$c,' out of ', input$N, ') confidence intervals do not include the true mean. \nAt a confidence level of ', inputAlpha(), ', we would expect this to be about ', round((1-inputAlpha())*100), '%.')
  })
  
})