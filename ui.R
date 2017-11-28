# Shiny app allowing: plot and parameters for microbial growth dataset
# Marc Garel, Severine Martini,  Christian Tamburini
### October 2017
library(shiny)


shinyUI(fluidPage(
  headerPanel("Application of a logistic model on microbial datasets"),
# load dataset
titlePanel("Upload file"),
  sidebarLayout(
    sidebarPanel(
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
      h4("Some details"),
      verbatimTextOutput("txtout"),
      tabsetPanel(
      tabPanel("Data",tableOutput('contents')),
      tabPanel("Plot",plotOutput('plot'), verbatimTextOutput('ex_out'))
      )
    )
  )
  
))

