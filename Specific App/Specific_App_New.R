options(shiny.sanitize.errors = FALSE) 
options(shiny.maxRequestSize = 50*1024^2)
library(shiny)
library(readxl)
library(xlsx)
library(DT)
library(shinybusy)
library(plotly)
library(tidyverse)
library(shinyBS)
library(colourpicker)
library(shinyWidgets)
library(bslib)
library(shinydashboard)
library(scales)
library(Cairo)
library(shinyAce)


ui <- 
  fluidPage(
    title = "Simulation Results", # title in browser window tab
    
    
    # App title 
    titlePanel("Simulation Shiny App"), 
    
    add_busy_spinner(spin = "fading-circle"),
    sidebarLayout(
      
      sidebarPanel(
        h3("Color Choices"),
        uiOutput("colors_ui"), 
        width = 2
      ),
      
      
      mainPanel(
        tabsetPanel(
          
          tabPanel(
            "Pre-filter data",
            DT::dataTableOutput("dataDT")
          ), 
          
          
          tabPanel(
            "Choose default values",
            
            fluidRow(
              column(
                12,
                actionButton(
                  "goDT", 
                  "Apply filters to dataset"
                ),
                # verbatimTextOutput("search"),
                # verbatimTextOutput("searchInput"),
                DT::dataTableOutput("filteredDT", width = "120%")
              )
            ),
            
            
            # fluidRow(
            #   column(
            #     width = 6,
            #     HTML("test output to see if list with default values is filled correctly"),
            #     verbatimTextOutput("lDefault")
            #   ),
            #   
            #   column(
            #     width = 6,
            #     actionButton(
            #       "updateDefaultList", 
            #       "Save default values"
            #     ),
            #     actionButton(
            #       "updateDefaultList2",
            #       "Start Color Picker"
            #     )
            #    
            #   )
            #   
            #   
            # ) 
            
          ),
          
          # tabPanel(
          #   "Colors",
          #   
          #   uiOutput("colors_ui")
          #   , verbatimTextOutput("colorText")
          # ),
          
          tabPanel(
            "Plot",
            
            fluidRow(
              uiOutput("lineplot_ui")
              # plotOutput("lineplot")
            ),
            
            
            fluidRow(
              column(
                4,
                #verbatimTextOutput("test"),
                h3("Simulation Parameters & Output"),
                selectInput(
                  "x", 
                  "Choose x-Variable", 
                  choices = NULL
                ),
                
                # colourPicker(3),
                
                
                checkboxGroupInput(
                  "OC", 
                  "Choose OC to plot", 
                  choices = NULL
                )
              ),
              
              column(
                4,
                
                h3("Optional simulation parameters"),
                checkboxInput(
                  "checkboxFacet",
                  "Do you want to add a facet grid dimension?",
                  value = TRUE
                ),
                
                conditionalPanel(
                  "input.checkboxFacet != 0",
                  
                  selectInput(
                    "facet_rows", 
                    "Choose row variable", 
                    choices = NULL
                  ),
                  
                  selectInput(
                    "facet_cols", 
                    "Choose col variable", 
                    choices = NULL
                  )
                ),
                
                
                
                
                checkboxInput(
                  "checkboxShape", 
                  "Do you want to add a shape dimension?",
                  value = TRUE
                ),
                conditionalPanel(
                  "input.checkboxShape != 0",
                  
                  selectInput(
                    "shape", 
                    "Choose shape variable",
                    choices = NULL
                  )
                )
              ),
              
              column(
                4,
                
                h3("Optical parameters"),
                sliderInput("xLegend",
                            "x-coord legend",
                            min = -0.5,
                            max = 1.2,
                            value = 1.05, 
                            step = 0.05),
                
                
                
                sliderInput("yLegend",
                            "y-coord legend",
                            min = -0.5,
                            max = 1.2,
                            value = 0.5,
                            step = 0.05),
                # 
                #                 sliderInput("res",
                #                             "Change resolution",
                #                             value = 72,
                #                             min = 50, 
                #                             max = 200),
                
                checkboxInput(
                  "checkboxSize", 
                  "Change plot size"
                ),
                conditionalPanel(
                  "input.checkboxSize != 0",
                  
                  sliderInput(
                    "plotwidth", 
                    "Plot width (px)",
                    value = 1200,
                    min = 600,
                    max = 1500
                  ),
                  
                  sliderInput(
                    "plotheight", 
                    "Plot height (px)",
                    value = 600,
                    min = 300,
                    max = 1000
                  ),
                  
                  sliderInput(
                    "linesize",
                    "Line and point size",
                    value = 0.5,
                    min = 0.1, 
                    max = 3, 
                    step = 0.1
                  )
                ),
                
                checkboxInput(
                  "checkboxTitle",
                  "Add title"
                ),
                
                conditionalPanel(
                  "input.checkboxTitle != 0",
                  
                  textInput(
                    "plot_title",
                    "Enter the plot title"
                  ),
                  
                  numericInput(
                    "plot_title_size",
                    "Size",
                    value = 30,
                    min = 1,
                    max = 50,
                    step = 1
                  ),
                  
                  # colorPickr(
                  #   inputId = "plot_title_colour", label = "Title colour:",
                  #   #showColour = "background",
                  #   selected = "black",
                  #   opacity = FALSE)
                  # 
                  colourInput(
                    inputId = "plot_title_colour", label = "Title colour:",
                    showColour = "background",
                    value = "black",
                    allowTransparent = FALSE)
                  
                  
                  
                  
                  
                  
                ),
                
                checkboxInput(
                  "checkboxTheme",
                  "Change the theme?"
                ),
                
                conditionalPanel(
                  "input.checkboxTheme !=0",
                  
                  radioButtons(
                    "plottheme",
                    "Select the theme",
                    choices = c(
                      "Grey", "White", "Linedraw",
                      "Light", "Minimal", "Classic"
                    )
                  ),
                  
                  numericInput(
                    "plotfontsize",
                    "Font size",
                    value = 10,
                    min = 1,
                    max = 50,
                    step = 0.5
                  ),
                  
                  selectInput(
                    "plotfont",
                    "Font",
                    choices = c("sans", "Times", "Courier")
                  )
                  
                )
                
              )
              
              
            ),
            
            fluidRow(
              h3("Data Points displayed in plot:"),
              # verbatimTextOutput("df_plot")
              DT::dataTableOutput("df_plot")
            )
            
          )
          
          # , selected = "Choose default values"
        )
      )
      
    )
  )









server <- function(session, input, output){
  
  # read in Example data and convert some variables for correct display
  
  # exampleData<- read_excel("CombinedResultsNew2.xlsx")
  exampleData <- read.csv("CombinedResultsNewNoSpace.csv", 
                          header = TRUE,
                          sep = ",",
                          stringsAsFactors = FALSE)
  
  
  
  
  # Use example data if checkbox is checked, otherwise use uploaded dataset
  data_full <- exampleData
  
  
  
  # display dataset as DT
  # Table in tab 'Pre-filter data'
  output$dataDT <- DT::renderDT(
    data_full,
    filter = "top",
    options = list(lengthChange = FALSE, 
                   autoWidth = TRUE,
                   scrollX = TRUE
    )
  )
  
  reacVals <- reactiveValues()
  
  ind_inputend <- which(colnames(data_full) == "TreatmentEfficacySetting")
  
  ind_outputstart <- which(colnames(data_full) == "Avg_Pat")
  
  names_inputs <- colnames(data_full)[1:ind_inputend]
  
  names_outputs <- colnames(data_full)[ind_outputstart:ncol(data_full)]
  
  # Table with all chosen filters in 'Pre-filter data'
  data_prefiltered <- reactive({
    #req(input$dataDT_rows_all)
    d <- data_full
    
    # Convert output parameters to numeric values
    for(i in ind_outputstart:ncol(d)){
      d[,i] <- as.numeric(d[[i]])
    }
    
    
    d[input$dataDT_rows_all,] # extracts rows that fit the filter choices
    
  })
  
  
  
  
  output$filteredDT <- DT::renderDT({
    input$goDT
    
    # Table displayed at start in tab 'Choose default values'
    # execute filters to create new DT upon clicking action button
    
    
    # display only input columns
    data_filtered <<- data_prefiltered()[,1:ind_inputend]
    
    # inputvariables
    
    
    # --------------Some choice-updates for inputs---------
    
    # Checkbox with defaults (not needed at the moment)
    
    # updateCheckboxGroupInput(session, 
    #                          "checkboxDefault", 
    #                          choices = names_inputs, 
    #                          selected = if(input$all_default) names_inputs
    # )
    
    updateCheckboxGroupInput(session,
                             "OC",
                             choices = names_outputs,
                             selected = c("Disj_Power", "PTP"))
    
    
    # #----------------------------------------------------------
    # make every input available for simulation parameter choice
    
    # updateSelectInput(session,
    #                   "x",
    #                   choices = names_inputs
    # )
    
    # updateSelectInput(session,
    #                   "facet_rows",
    #                   choices = names_inputs
    # )
    # 
    # 
    # updateSelectInput(session,
    #                   "facet_cols",
    #                   choices = names_inputs
    # )
    # 
    # updateSelectInput(session,
    #                   "shape",
    #                   choices = names_inputs
    # )
    
    #---------------------------------------------------------------
    
    # display only columns with more than 1 unique entry
    uniques <- lapply(data_filtered, unique)
    bUniques <- sapply(uniques, function(x) length(x) == 1)
    data_filtered <<- data_filtered[,which(!bUniques)]
    
    for(i in colnames(data_filtered)){
      # transforms variables to factors to be able to choose 1 factor level as default value
      data_filtered[,i] <<- factor(as.factor(data_filtered[[i]]))  #factor(...) drops unused factor levels from prefiltering
    }
    
   data_filtered_helper <- data.frame(lapply(data_filtered, as.character), stringsAsFactors = FALSE)

      
    fil <<- paste0("'[\"", data_filtered_helper[1,], "\"]'")
    fil_string <<- paste0(
      "list(NULL, ",
      paste0("list(search = ", fil, ")", collapse = ", "),
      ")"
      )
    
    data_filtered
    
  },
  
  filter = "top",
  options = list(lengthChange = FALSE, 
                 autoWidth = TRUE, 
                 # scrollX = TRUE, 
                 pageLength = 5,
                 searchCols = eval(parse(text = fil_string))
  )
  )
  
  
  
  # specify default value for every variable and save in data frame
  # if df is not reduced to 1 line (i. e. if not for every variable a default value is specified), the first observation is taken as default
  
  data_default <- reactive({
    req(input$filteredDT_rows_all)
    # ind_inputend <- isolate(which(colnames(data_prefiltered()) == input$inputend))
    # data_filtered <<- isolate(data_prefiltered()[,1:ind_inputend])
    
    
    d <- data_prefiltered()
    d <- d[input$filteredDT_rows_all, 1:ind_inputend]
    
    # d <- data_filtering()
    # d <- d[input$filteredDT_rows_all, ]
    d[1,]
  })
  
  
  
  
  # Vector column filter choices ------------------------------------------
  
  search_vector <- reactive({
    req(input$filteredDT_search_columns)
    
    
    vNamedSearch <- input$filteredDT_search_columns
    names(vNamedSearch) <- colnames(data_filtered)
    vNamedSearch
    
  })
  
  
  
  output$search <- renderPrint({
    
    search_vector()
  })
  
  
  search_input <- reactive({
    req(input$filteredDT_search_columns)
    
    search_input <- search_vector()[search_vector() != ""]
    
    
    
    search_input
    
    # paste0(names(search_input),
    #        " == ",
    #        search_input,
    #        collapse = " & ")
    
    
    #names(search_input)
    
    
    
    # paste0(names(search_input),
    #        " == ",
    #        search_input,
    #        collapse = " & ")
    
    
  })
  
  output$searchInput <- renderPrint({
    
    search_input()
    
    
  })
  
  # Color vector specification ------------------------------------
  
  
  
  # Adding reactive Values for number of OCs and names of OCs
  
  observe({
    
    reacVals$nOC <- ncol(data_prefiltered()) - ind_inputend
    
  })
  
  observe({
    
    reacVals$names_outputs <- colnames(data_prefiltered()[,ind_outputstart:ncol(data_prefiltered())])
  })
  
  
  # experimenting with color() palette for plot --------------------------------
  
  
  # vColors <- reactive({
  #   
  #   # ind_inputend <- isolate(which(colnames(data_prefiltered()) == input$inputend))
  #   names_outputs <- colnames(data_prefiltered()[,reacVals$ind_outputstart:ncol(data_prefiltered())])
  #   
  #   
  #   nOC <- ncol(data_prefiltered()) - reacVals$ind_inputend
  #   
  #   nColors <- sample(1:657,
  #                     size = nOC,
  #                     replace = FALSE)
  #   vColors <- colors()[nColors]
  #   names(vColors) <- factor(factor(names_outputs))
  #   
  #   # output <- c(nOC, reacVals$ind_inputend, input$inputend, reacVals$ind_outputstart)
  #   # names(output) <- c("nOC", "ind_inputend", "input$inputend", "ind_outputstart")
  #   # output
  #   vColors
  #   
  # })
  # 
  # output$colors <- renderPrint({
  #   
  #   vColors()
  # })
  
  
  
  # --------------------------------------------------------------------------
  # dynamic number of color selectors (one for every OC) ---------------------
  
  
  output$colors_ui <- renderUI({
    
    nWidgets <- as.integer(reacVals$nOC)
    # nWidgets <- length(input$OC)
    
    int_col <- sample(1:657, 657, replace = FALSE)
    colPalette <- colors()[int_col[1:nWidgets]]
    
    #colPalette <- colors()[1:nWidgets]
    names(colPalette) <- reacVals$names_outputs
    
    colPalette[
      c("FWER",
        "FWER_BA",
        "Disj_Power",
        "Disj_Power_BA",
        "PTT1ER",
        "PTP")] <-
      
      c("red3", 
        "red1", 
        "steelblue4", 
        "steelblue1", 
        "sienna1", 
        "skyblue")
    
    colList <- lapply(1:nWidgets, function(i) {
      colourInput(inputId = paste0("col", i), 
                  label = reacVals$names_outputs[i],
                  showColour = "both",
                  # value = "black"
                  # value = colors()[sample(1:657,
                  #                         1,
                  #                         replace = FALSE)]
                  value = colPalette[i]
      )
      
    })
    
    colList
  })
  
    

  lUiColors <- reactive({
    
    nWidgets <- as.integer(reacVals$nOC)
    # nWidgets <- length(input$OC)
    #names_outputs <- colnames(data_prefiltered()[,reacVals$ind_outputstart:ncol(data_prefiltered())])
    
    df_colors <- data.frame(lapply(1:nWidgets, function(i) {
      input[[paste0("col", i)]]
    }))
    
    names(df_colors) <- reacVals$names_outputs
    
    
    # Default colors ----------------------------------------------
    
    
    #-------------------------------------------------------------
    df_colors
    
  })
  
  
  output$colorText <- renderPrint({
    lUiColors()
  })
  
  
  
  
  
  
  
  
  # --------------------------------------------------------------------------
  # only make variables with default values available for simulation parameter choice
  
  observe({
    
    updateSelectInput(session,
                      "x",
                      choices = names(search_input()),
                      selected = "FinalCohortSampleSize"
    )
    
  })
  
  observe({
    
    updateSelectInput(session,
                      "facet_rows",
                      choices = names(search_input()),
                      selected = "Maximumnumberofcohorts"
    )
    
  })
  
  observe({
    
    updateSelectInput(session,
                      "facet_cols",
                      choices = names(search_input()),
                      selected = "CohortInclusionRate"
    )
    
  })
  
  observe({
    
    updateSelectInput(session,
                      "shape",
                      choices = names(search_input()),
                      selected = "TypeofDataSharing"
    )
  })
  
  
  
  
  # 
  # updateSelectInput(session,
  #                   "facet_rows",
  #                   choices = names_inputs
  # )
  # 
  # 
  # updateSelectInput(session,
  #                   "facet_cols",
  #                   choices = names_inputs
  # )
  # 
  # updateSelectInput(session,
  #                   "shape",
  #                   choices = names_inputs
  # )
  # 
  
  
  
  
  # save default values in a list upon clicking action button
  
  # # variant with checkboxes for all variables
  # lDefault <- eventReactive(input$updateDefaultList, {as.list(data_default()[1, input$checkboxDefault])})
  # 
  
  # variant with automatic input of chosen filters as default values
  lDefault <- eventReactive(input$updateDefaultList, 
                            {as.list(search_input())})
  
  
  
  
  
  
  
  # Output of list with default values
  output$lDefault <- renderPrint({
    req(lDefault)
    print(lDefault())
  })
  
  
  
  
  
  
  # PLOT -------------------------------------------------------------------
  #-----------------------------------------------------------------------------------
  
  
  # Plot Df ------------------------------------------
  
  # Data frame used for plot
  # Filters every variable for the specified default value except the chosen simulation parameters, which can have more distinguishable values
  
  df_plot <- reactive({
    
    # 1 line df with default values for variables that are checked
    # default_df <- data_default()[1, input$checkboxDefault]
    default_df <- search_input()
    
    
    # vector of names of simulation parameters
    sim_par <- input$x
    if(input$checkboxShape){
      sim_par <- c(sim_par, input$shape)
    }
    
    if(input$checkboxFacet){
      sim_par <- c(sim_par, input$facet_rows, input$facet_cols)
    }
    
    # exclude simulation parameters from df with default values
    default_filter <- default_df[!(names(default_df) %in% sim_par)]
    
    default_filter <- gsub('\\["', "", default_filter)
    default_filter <- gsub('\\"]', "", default_filter)
    
    bedingung <- paste0(paste0("`", names(default_filter), "`"),
                        " == ",
                        paste0("'", default_filter, "'"),
                        # default_filter,
                        collapse = " & ")
    
    
    df_plot <- subset(data_prefiltered(), eval(parse(text = bedingung)))
    df_plot # return data frame
    
    
  })
  
  
  
  output$df_plot <- DT::renderDT({
    
    df_plot()
  },
  
  options = list(scrollX = TRUE))
  
  
  
  # Transform dataset to long format on chosen output variables for easy plotting
  data_longer <- reactive({
    
    
    d <- df_plot()
    # d <- d[input$filteredDT_rows_all,]
    
    d <- 
      d %>%
      pivot_longer(cols = input$OC,
                   names_to = "OC",
                   values_to = "value")
    d
  })
  
  
  
  # Plot ---------------------------------------
  
  # Plot based on which dimensions are chosen
  output$lineplot<- renderPlotly({
    # output$lineplot <- renderPlot({
    
    p1 <- ggplot(
      data_longer(), 
      aes_string(x = input$x)
    )
    
    colScale <- scale_colour_manual(values = lUiColors())
    
    p1 <- 
      p1 + 
      geom_line(aes(y = value, color = OC), size = input$linesize) +
      geom_point(aes(y = value, color = OC), size = 3*input$linesize) + colScale
    
    
    
    if(input$checkboxShape){
      p1 <- 
        p1 + 
        aes(linetype = 
              factor(get(
                input$shape)
              )
            ,
            shape = 
              factor(get(
                input$shape)
              )
        )
    }
    
    
    if(input$checkboxFacet){
      p1 <- 
        p1 + 
        facet_grid(vars(get(input$facet_rows)),
                   vars(get(input$facet_cols))
        )
    }
    
    
    # THEME ---------------------------------------------
    
    plot_theme <- input$plottheme
    plot_fontsize <- input$plotfontsize
    plot_font <- input$plotfont
    
    if (plot_theme == "Grey") {
      p1 <- p1 + theme_gray(plot_fontsize, plot_font)
    }
    if (plot_theme == "White") {
      p1 <- p1 + theme_bw(plot_fontsize, plot_font)
    }
    if (plot_theme == "Linedraw") {
      p1 <- p1 + theme_linedraw(plot_fontsize, plot_font)
    }
    if (plot_theme == "Light") {
      p1 <- p1 + theme_light(plot_fontsize, plot_font)
    }
    if (plot_theme == "Minimal") {
      p1 <- p1 + theme_minimal(plot_fontsize, plot_font)
    }
    if (plot_theme == "Classic") {
      p1 <- p1 + theme_classic(plot_fontsize, plot_font)
    }
    
    
    if (plot_fontsize == 12 & plot_font == "sans" & plot_theme == "Grey") {
    }
    
    # TITLE ----------------------------------------
    
    if (input$checkboxTitle){
      p1 <- p1 + 
        labs(title = input$plot_title)  + 
        theme(plot.title = element_text(colour = input$plot_title_colour,
                                        size = input$plot_title_size, vjust = 1.5))
      
    }
    
    p1 <- p1 + theme(legend.title = element_blank())
    p1 <- ggplotly(p1)
    
    p1 %>% layout(legend = list(x = input$xLegend, y = input$yLegend))
    p1
    
    
  })

  output$lineplot_ui <- renderUI({
    plotlyOutput("lineplot",
    # plotOutput("lineplot",
                 height = input$plotheight,
                 width = input$plotwidth)
  })

  
}  

shinyApp(ui = ui, server = server)

#shinyBS::bsModal()





