#=====================================================================#
# File name: data viewer application
# This is code to create: shinydashboard data viewer
# Authored by and feedback to: @mjfrigaard
# Last updated: 2020-10-07
# MIT License
# Version: 1.1
#=====================================================================#

# ‹(•_•)› PACKAGES ––•––•––√\/––√\/––•––•––√\/––√\/––•––•––√\/––√\/  ----
library(shiny)
library(shinydashboard)
library(tidyverse)
library(listviewer)
library(inspectdf)
library(visdat)
library(ggthemes)
library(reactable)
library(grkstyle)
# set code style
grkstyle::use_grk_style()
# set theme
ggplot2::theme_set(ggthemes::theme_clean(base_family = "Ubuntu Mono"))


# ~~ DEFINE UI ~~ ---------------------------------------------------------
# check this out:
# https://github.com/RinteRface/shinydashboardPlus
ui <- dashboardPage(

# UI --> dashboardHeader --------------------------------------------------

  dashboardHeader(title = "Dataset Viewer", titleWidth = 200),


# UI --> dashboardSideber -------------------------------------------------

  dashboardSidebar(collapsed = FALSE, width = 200,
    
# UI --> fileInput -----
    fileInput(inputId = "filedata",
          label = "Upload data. Choose csv file",
          accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),
    
# UI --> checkboxInput -----
      # Checkbox if file has header 
      checkboxInput(inputId = "header", label = "Header", value = TRUE),
    
# UI --> radioButtons -----
      # Select separator 
      radioButtons(inputId = "sep", label = "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ","),

# UI --> radioButtons -----------------------------------------------------
      # Select quotes 
      radioButtons("quote", "Quote",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'),

      # Horizontal line 
      tags$hr(),

# UI --> sliderInput (slider) ---------------------------------------------

    sliderInput(
      inputId = "slider", label = "Number of observations:",
      min = 1000, max = 10000, value = 100000)
    ),


# UI --> dashboardBody ----------------------------------------------------

  dashboardBody(
    
    # UI --> reactableOutput(table_gt) 
    # box(reactableOutput(outputId = "table_gt", width = "auto", 
    #                     height = "auto", inline = TRUE))
    
    tabBox(
      title = "",
      width = 12,
      id = "tabset0",
        tabPanel(title = "Your Data", 
                 reactableOutput(outputId = "table_gt", width = 1100, 
                                 height = 300, inline = TRUE))
            ),

    # fluidRow(
    #   box(plotOutput(outputId = "plot_mem", width = 500, height = 250)),
    #   box(plotOutput(outputId = "plot_types", width = 500, height = 250))
    #      ),

    tabBox(
      title = "",
      width = 12,
      id = "tabset1",
    # UI --> plotOutput(plot_mem) ------------------------------------------
              tabPanel("Dataset memory use", plotOutput("plot_mem")),
    # UI --> plotOutput(plot_types) ----------------------------------------
              tabPanel("Variable types", plotOutput("plot_types"))
            ),
    
     # fluidRow(
     #  box(plotOutput(outputId = "plot_na", width = 500, height = 250)),
     #  box(plotOutput(outputId = "plot_vis_dat", width = 500, height = 250)),
     #  ),
       
    tabBox(
      title = "",
      width = 12,
      id = "tabset2",
     # UI --> plotOutput(plot_na) -------------------------------------------
              tabPanel("Prevalence of missing values", plotOutput("plot_na")),
     # UI --> plotOutput(plot_vis_dat) --------------------------------------
              tabPanel("Missing data by type", plotOutput("plot_vis_dat"))
            ),
    
      # fluidRow(
      #  box(plotOutput(outputId = "plot_num", width = 500, height = 250)),
      #  box(plotOutput(outputId = "plot_cor", width = 500, height = 250)))
    
    tabBox(
      title = "",
      width = 12,
      id = "tabset3",
      # UI --> plotOutput(plot_num) -------------------------------------------
              tabPanel("Numerical variables", plotOutput("plot_num")),
      # UI --> plotOutput(plot_cor) -------------------------------------------
              tabPanel("Correlations between variables", plotOutput("plot_cor"))
            )
    )
)


# ~~ DEFINE SERVER ~~ -----------------------------------------------------

server <- function(input, output) {

# SERVER --> dataReact --------------------------------------------------------
  dataReact <- reactive({
    req(input$filedata)
      

# SERVER --> tryCatch(read.csv) -------------------------------------------
      
        tryCatch(
      {
        df <- read.csv(input$filedata$datapath,
                 header = input$header,
                 sep = input$sep,
                 quote = input$quote)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
  })

# SERVER --> table_gt --------------------------------------------------------
  output$table_gt <- renderReactable({
   reactable(dataReact(), wrap = FALSE, resizable = TRUE, filterable = TRUE, 
             highlight = TRUE)
  })

# SERVER --> plot_mem ---------------------------------------------------------
  output$plot_mem <- renderPlot({
    dplyr::slice_sample(dataReact(), n = as.numeric(input$slider)) %>%
      inspectdf::inspect_mem() %>%
      inspectdf::show_plot(text_labels = TRUE) -> mem_plot
    # return
    mem_plot
  })

# SERVER --> plot_types ---------------------------------------------------
  output$plot_types <- renderPlot({
    dplyr::slice_sample(dataReact(), n = as.numeric(input$slider)) %>%
      inspectdf::inspect_types() %>%
      inspectdf::show_plot(text_labels = TRUE) -> types_plot
    types_plot
  })


# SERVER --> plot_na ---------------------------------------------------
  output$plot_na <- renderPlot({
    dplyr::slice_sample(dataReact(), n = as.numeric(input$slider)) %>%
      inspectdf::inspect_na() %>%
      inspectdf::show_plot(text_labels = TRUE) -> na_plot
    na_plot
  })
  

# SERVER --> vis_dat_plot ----------------------------------------------
    output$plot_vis_dat <- renderPlot({
    dplyr::slice_sample(dataReact(), n = as.numeric(input$slider)) %>%
      visdat::vis_dat() + 
      ggplot2::coord_flip() -> vis_dat_plot
    vis_dat_plot
  })

# SERVER --> plot_num -------------------------------------------------
output$plot_num <- renderPlot({
    dataReact() %>% 
        dplyr::select_if(is.numeric) %>% 
        dplyr::slice_sample(., n = as.numeric(input$slider)) %>%
        inspectdf::inspect_num() %>% 
        inspectdf::show_plot(text_labels = TRUE) -> num_plot
    num_plot
  })


# SERVER --> plot_cor -----------------------------------------------------
output$plot_cor <- renderPlot({
    dataReact() %>% 
        dplyr::select_if(is.numeric) %>% 
        dplyr::slice_sample(., n = as.numeric(input$slider)) %>%
        inspectdf::inspect_cor() %>% 
        inspectdf::show_plot(text_labels = TRUE) -> cor_plot
    cor_plot
  })
  
}

shinyApp(ui, server)
