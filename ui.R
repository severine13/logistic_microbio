# Shiny app allowing: plot and parameters for microbial growth dataset
# Marc Garel, Severine Martini,  Christian Tamburini
### October 2017
library(shiny)


shinyUI(fluidPage(
  headerPanel("Application of a logistic model on microbial datasets"),
# load dataset
titlePanel("Upload file"),
  sidebarLayout(
    sidebarPanel("This is to perform logistic regression to estimate growth rate and maxium cells density.",
      fileInput('file1', 'Choose CSV File',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv', '.txt')),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      radioButtons('quote', 'Quote',
                   c(None='',
                     'Double Quote'='"',
                     'Single Quote'="'"),
                   '"')
    ),
    
    mainPanel(
      h4("Ref"),
      verbatimTextOutput("txtout"),
      withMathJax(),
      helpText('Logistic equation $$x(t) =r.x_0.(1-\\frac{x_0}K)$$'),
      tabsetPanel(
      tabPanel("Details",tableOutput('contents'),  helpText('You have to format data with tab separartor and dot for decimal. Remove all space in the header from your dataset. Replace it by "_"'),helpText('In your data set there are two arrays, time and cells density (Optic density, Cells number, Biomass ....) ')),
      tabPanel("Data",verbatimTextOutput('ex_out2')),
      tabPanel("Plot",plotOutput('plot'), verbatimTextOutput('ex_out'))
      )
    )
  )
  
))

