library(shiny)

shinyUI(fluidPage(
  title='Confidence Intervals on Means',
  
  plotOutput('plot'),
  
  fluidRow(
    column(4,
      selectizeInput('N', 'Number of samples',
                     choices=c('10','20','50','100','500'), selected=100,
                     options=list(create=T)),
      selectizeInput('size', 'Sample size',
                     choices=c('5','10','25','50','100'), selected=25,
                     options=list(create=T)),
      sliderInput('alpha', 'Confidence level', min=0, max=1, step=0.01, value=0.95)
    ),
    
    column(4,
      numericInput('mean', 'Mean', value=0),
      numericInput('sd', 'Standard deviation', value=1)
    )
  )
))