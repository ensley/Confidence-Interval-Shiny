library(shiny)
library(ggvis)

shinyUI(navbarPage('Confidence Intervals on Means',
  tabPanel('Instructions',
           h1("TODO")),
  tabPanel('Visualization',
     sidebarLayout(
       sidebarPanel(
         selectizeInput('N', 'Number of samples',
                        choices=c('10','20','50','100','500'), selected=100,
                        options=list(create=T)),
         selectizeInput('size', 'Sample size',
                        choices=c('5','10','25','50','100'), selected=25,
                        options=list(create=T)),
         sliderInput('alpha', 'Confidence level', min=0, max=1, step=0.01, value=0.95),
         numericInput('mean', 'Mean', value=0),
         numericInput('sd', 'Standard deviation', value=1)
       ),
       
       mainPanel(
         ggvisOutput('plot'),
         textOutput('count')
       )
     )
  ),
  
  # tweet button stuff
  tags$script(HTML("var header = $('.navbar > .container');
                       header.append('<div style=\"padding-top:10px;float:right\"><a href=\"https://twitter.com/share\" class=\"twitter-share-button\" align=\"middle\" data-url=\"www.mywebsite.com\" data-text=\"I just learned something about statistics from www.mywebsite.com!\" data-size=\"large\">Tweet</a></div>');
                       console.log(header)")),
  tags$script(HTML("!function(d,s,id){
            var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';
            if(!d.getElementById(id)){
                    js=d.createElement(s);
                    js.id=id;
                    js.src=p+'://platform.twitter.com/widgets.js';
                    fjs.parentNode.insertBefore(js,fjs);
            }
    }(document, 'script', 'twitter-wjs');"))
  
))