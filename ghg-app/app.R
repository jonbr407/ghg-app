#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(readxl)
library(shinyBS)


# Define UI for application that draws a histogram
ui <- fluidPage(
  # Application title
  tags$br(),
  tags$img(src = "https://www.otago.ac.nz/_assets/_gfx/logo@2x.png", width = "160px", height = "80px"),
  titlePanel("Greenhouse Gas Emissions Dashboard"),
  style = "font-family: 'Open Sans', sans-serif;",
  tags$br(),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      width = 4,
      tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: #00508F}")),
      sliderInput("StudentSlider",
                  tags$h3("Student numbers"),
                  min = -.50,
                  max = 1,
                  value = 0,
                  step = 0.10),
      bsPopover("StudentSlider" , "Percentage of change in student numbers" , "The change in Equivalent Full Time Students can affect the amount of resources the University requires, and therefore indirectly impacts on greenhouse gas emissions. Note: the slider bar moves on a 10% incremental increase in student numbers i.e. 0.1 = 10%", trigger = "hover"),

      
      tags$style(HTML(".js-irs-1 .irs-single, .js-irs-1 .irs-bar-edge, .js-irs-1 .irs-bar {background: #00508F}")),
      sliderInput("BehaviourSlider",
                  tags$h3("Behavioural change"),
                  min = -1.25,
                  max = +1.25,
                  value = 0,
                  step = 0.25),
      bsPopover("BehaviourSlider", "Level of change by University", "How much the University is doing to commit / act on reducing greenhouse gas emissions on campus through initiatives. Examples include subsidising public transport, reducing vegan food prices, or setting up more recycling bins on campus. Note: the slider bar is currently set at moderate. -1.25 = very low; -1 = low; +1 = high; +1.25  = very high", trigger = "hover",
                options = NULL),
      tags$style(HTML(".js-irs-2 .irs-single, .js-irs-2 .irs-bar-edge, .js-irs-2 .irs-bar {background: 	#00508F}")),
      sliderInput("ElectricitySlider",
                  tags$h3("NZ electricity source"),
                  min = 1,
                  max = 5,
                  value = 1),
      bsPopover("ElectricitySlider", "Rate of conversion to renewable energy", "The degree to which the energy used by University is generated by renewable energy. The goal is to change all fossil fuel sources such as coal and gas to renewable energy. Note: the slider bar represents five scenarios  with 1 = maintaining current state till 80% renewable energy by 2032, 3 = having 95% renewable energy by 2032,  and 5 = having 100% renewable energy by 2032", trigger = "hover",
                options = NULL)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tags$div(
        tags$h3("Current forecast emissions"),
        tags$p(tags$h4(tags$strong("Use this dashboard to observe how variables and their interactions can 
                    impact on the University's greenhouse gas emissions up to 2032. In the graphical plot, the emissions are broken down into categories."))),
        tags$style("h4 {color: #00508F;
                                 font-size: 20px;
                                 font-style: italic;
                                 }"
        )
      ),
      tags$br(),
      plotOutput("plot"),
      
      tags$br(),
      
      tags$div(
        textOutput("text1")
      ),
      
      tags$div(
        tags$h3("Notes"),
      tags$text("Each of the variables (i.e. student numbers, behavioural change, NZ electricity source) have a quantified impact on the various categories of emissions. For example: for a 10% change in student numbers, 
                  emissions related to the category “staff air travel” is impacted by 25% of this 10% change in student numbers. 
                  In subsequent years, the impact is projected to 50%, which could be regulated by University management.")
      ),
      tags$style("text {font-size: 14px;
                                 }"),
      
      tags$br(),
      
      tags$div(
        tags$text("The categories were developed by Deloitte in their annual greenhouse gas emissions report for the University of Otago (provided below)."),
        tags$br(),
        tags$br(),
        tags$text(tags$strong("Staff Air Travel - domestic and international")),
        tags$br(),
        tags$text("Emissions generated from staff air travel, both international and domestic."),
        tags$br(),
        tags$text(tags$strong("Student air travel - domestic and international")),
        tags$br(),
        tags$text("Emissions generated from student air travel, both international and domestic."),
        tags$br(),
        tags$text(tags$strong("Steam & MTHW - coal (incl losses)")),
        tags$br(),
        tags$text("Steam and medium temperature hot water (MTHW) generated from coal power. This includes losses generated in transmission and distribution."),
        tags$br(),
        tags$text(tags$strong("Electricity (incl transmission losses)")),
        tags$br(),
        tags$text("The emissions generated from the production of electricity. This includes losses generated in transmission and distribution."),
        tags$br(),
        tags$text(tags$strong("Waste from operations - to landfill, recycling and water processing")),
        tags$br(),
        tags$text("The emissions generated from waste to landfill, recycling and water processing. “Emissions include meat (excluding poultry), poultry, pulp and paper, wine, dairy processing.”"),
        tags$br(),
        tags$text(tags$strong("Purchased Goods and Services - food")),
        tags$br(),
        tags$text("The emissions resulting from the purchase of food fall into two main categories: Food for consumption by students in residential colleges and food for sale in retail outlets or events."),
        tags$br(),
        tags$text(tags$strong("Stationary Combustion - coal")),
        tags$br(),
        tags$text("Stationary combustion fuels are burnt in a fixed unit or asset, such as a boiler. Emissions occur from the combustion of fuels from sources owned or controlled by the reporting organisation."),
        tags$br(),
        tags$text(tags$strong("Employee Commuting - private vehicles")),
        tags$br(),
        tags$text("Staff commuting to and from the Otago University campus has been based on two primary sources of data - census mapping and the 2019 staff travel survey."),
        tags$br(),
        tags$text(tags$strong("Stationary Combustion - LPG")),
        tags$br(),
        tags$text("Stationary combustion fuels are burnt in a fixed unit or asset, such as a boiler. Emissions occur from the combustion of fuels from sources owned or controlled by the reporting organisation."),
        tags$br(),
        tags$text(tags$strong("Other")),
        tags$br(),
        tags$text("A combination of all factors contributing to the University of Otago’s greenhouse gas emissions that aren’t deemed significant enough to be individual categories on their own. 
                  These factors are subject to change in future versions of this dashboard and currently include student commuting, business travel - accommodation, steam & (MTHW) - biomass (incl losses),
                  business travel - mileage, taxis and shuttles, fugitive emissions - refrigerants, mobile combustion - diesel, petrol, pcard & marine, stationary combustion - biomass, purchased goods and services - water, stationary combustion - diesel, employee commuting - public transport, construction & demolition.")
      ),
      tags$div(
        tags$p(tags$h3("Further information")),
        tags$p(tags$a(href="https://www.otago.ac.nz/sustainability/about/", "University of Otago's Sustainability Office")),
        tags$p(tags$a(href="https://www.otago.ac.nz/sustainability/news/otago828588.html", "University of Otago makes submission to ORC's draft 10 year plan")),
        tags$p(tags$a(href="https://www.otago.ac.nz/sustainability/otago824241.pdf", "University of Otago's 2019 Greenhouse Gas Inventory")),
        tags$p(tags$a(href="https://www.greenofficemovement.org/sustainability-assessment/", "University Sustainability Assessment Framework Tool"))
      ),
      tags$br()
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  Base_Scenario <- read_excel("Project_Figures.xlsx",
                              sheet = "4. Total base scenario", range = "A1:M11")
  #Pivoting base scenario table to make graphing easier.
  Base_Scenario <- Base_Scenario %>%
    pivot_longer(cols = `2021`:`2032`, names_to = "Year",
                 values_to ="Carbon_Emissions",
                 names_repair = "minimal")
  
  Base_Scenario <- Base_Scenario %>% rename(Category = "Emissions")  
  
  #Rounding figures for base scenario table.
  Base_Scenario$Carbon_Emissions <- round(Base_Scenario$Carbon_Emissions,
                                          digits = 2)
  #Sorting the base scenario table for easier graphing.
  Base_Scenario <- Base_Scenario %>%
    group_by(Year) %>%
    arrange(Year)
  
  
  
  #Adjusted_Base_scenario
  Adjusted_Multiplier <- read_excel("Project_Figures.xlsx",
                                    
                                    sheet = "6.Adjustments", range = "A1:M11")
  #Pivoting Adjusted_Multiplier table to make graphing easier.
  Adjusted_Multiplier <- Adjusted_Multiplier %>%
    pivot_longer(cols = `2021`:`2032`, names_to = "Year",
                 values_to ="Multipliers",
                 names_repair = "minimal")
  #Rounding figures for Adjusted_Multiplier table.
  Adjusted_Multiplier$Multipliers <- round(Adjusted_Multiplier$Multipliers,
                                           digits = 2)
  
  Adjusted_Multiplier <- Adjusted_Multiplier %>% rename(Category = "Emissions") 
  
  #Level of behavioural change (LOBC)
  Lobc_Multipliers <- read_excel("Project_Figures.xlsx",
                                 sheet = "2. Lobc", range = "A16:M26")
  
  #Pivoting Lobc_Multiplier table to make graphing easier.
  Lobc_Multipliers <- Lobc_Multipliers %>%
    pivot_longer(cols = `2021`:`2032`, names_to = "Year",
                 values_to ="Lobc_Multiplier",
                 names_repair = "minimal")
  #Rounding figures for Lobc_Multipliers table.
  Lobc_Multipliers$Lobc_Multiplier <- round(Lobc_Multipliers$Lobc_Multiplier,
                                            digits = 2)
  
  #Electricity Multiplier Table
  Electricity_Multipliers <- read_excel("Project_Figures.xlsx",
                                        sheet = "3. Electricity renewables %",
                                        range = "A7:M17")
  
  #Pivoting Electricity_Multipliers table to make graphing easier.
  Electricity_Multipliers <- Electricity_Multipliers %>%
    pivot_longer(cols = `2021`:`2032`, names_to = "Year",
                 values_to ="Electricity_Multiplier",
                 names_repair = "minimal")
  
  #Rounding figures for Electricity_Multipliers table.
  Electricity_Multipliers$Electricity_Multiplier <- round(Electricity_Multipliers$Electricity_Multiplier,
                                                          digits = 2)
  
  Electricity_Multipliers <- Electricity_Multipliers %>% rename(Category = "Emissions")
  
  #Scenarios foe electricity
  Scenarios <- read_excel("Project_Figures.xlsx",
                          sheet = "3. Electricity renewables %",
                          range = "A59:M64")
  
  #Pivoting Scenarios table to make graphing easier.
  Scenarios <- Scenarios %>%
    pivot_longer(cols = `2021`:`2032`, names_to = "Year",
                 values_to ="Scenario_E",
                 names_repair = "minimal")
  
  #Rounding figures for Electricity_Multipliers table.
  Scenarios$Scenario_E <- round(Scenarios$Scenario_E,
                                digits = 2)
  
  Scenarios <- Scenarios %>%
    pivot_wider(names_from = Scenarios, values_from = Scenario_E)
  

  #The table for question one with the multiplied totals
  The_Complete_Table <- left_join(Base_Scenario, Adjusted_Multiplier,
                                  by = c("Category", "Year"), keep = FALSE)
  
  #The table for question two with the multiplied totals
  The_Complete_Table <- left_join(The_Complete_Table, Lobc_Multipliers,
                                  by = c("Category", "Year"), keep = FALSE) 
  
  #The table for question three with the multiplied totals
  The_Complete_Table <- left_join(The_Complete_Table, Electricity_Multipliers,
                                  by = c("Category", "Year"), keep = FALSE)
  
  #The table for question three with the multiplied totals
  The_Complete_Table <- left_join(The_Complete_Table, Scenarios,
                                  by =  "Year", keep = FALSE)
  
  
  output$plot <- renderPlot({
    # req(new_scenario())
    Base_Scenario_Graph <- The_Complete_Table %>%
      mutate(Total_Emissions = Carbon_Emissions * (1 + (Multipliers * input$StudentSlider) 
                                                   + (Lobc_Multiplier * input$BehaviourSlider)
                                                   + (case_when (input$ElectricitySlider == 5 ~  Scenario_5 * Electricity_Multiplier,
                                                                 input$ElectricitySlider == 4 ~ Scenario_4 * Electricity_Multiplier,
                                                                 input$ElectricitySlider == 3 ~  Scenario_3 * Electricity_Multiplier,
                                                                 input$ElectricitySlider == 2 ~  Scenario_2 * Electricity_Multiplier,
                                                                 input$ElectricitySlider == 1 ~ Scenario_1 * Electricity_Multiplier)))) %>% 
      ggplot() +
      geom_col(aes(x = Year, y = Total_Emissions, fill = Category),
               position = position_stack(reverse = TRUE), na.rm = TRUE,
               color="black") +
      theme(legend.position="right") +
      guides(fill = guide_legend(reverse = TRUE)) +
      ylab("CO2 Emissions (Tonnes)") +
      ylim(0, 50000)
    Base_Scenario_Graph
  })
    
    output$text1 <- renderText({paste("Based on your selected inputs: " , input$StudentSlider * 10, "percent increase in student numbers, level" , 
                                      input$BehaviourSlider , "of behavioural change, " ,
                                      input$ElectricitySlider , "times rate of conversion from fossil fuel sources to renewable energy, " ,
                                      Total_Emit_2030 <- The_Complete_Table %>%
                                        mutate(Total_Emissions = Carbon_Emissions * (1 + (Multipliers * input$StudentSlider) 
                                                                                     + (Lobc_Multiplier * input$BehaviourSlider)
                                                                                     + (case_when (input$ElectricitySlider == 5 ~  Scenario_5 * Electricity_Multiplier,
                                                                                                   input$ElectricitySlider == 4 ~ Scenario_4 * Electricity_Multiplier,
                                                                                                   input$ElectricitySlider == 3 ~  Scenario_3 * Electricity_Multiplier,
                                                                                                   input$ElectricitySlider == 2 ~  Scenario_2 * Electricity_Multiplier,
                                                                                                   input$ElectricitySlider == 1 ~ Scenario_1 * Electricity_Multiplier))))%>%
                                        select(Total_Emissions) %>%
                                        filter(Year == 2030)%>%
                                        summarise(round(sum(Total_Emissions)/7.8))%>%
                                        select(-Year)
                                      , "hectares of trees would 
                                      need to be planted by year 2025 in order to reach net zero emissions in 2030. These figures are based on 1 hectare of new indigenous forest sequestering 
                                      7.8 tonnes of CO2-e by its fifth year." , 
                                      
                                      "To buy carbon credits from the market to offset current emissions, " ,
                                      "the cost would be " , "$" , Total_Emit_2030 <- The_Complete_Table %>%
                                        mutate(Total_Emissions = Carbon_Emissions * (1 + (Multipliers * input$StudentSlider) 
                                                                                     + (Lobc_Multiplier * input$BehaviourSlider)
                                                                                     + (case_when (input$ElectricitySlider == 5 ~  Scenario_5 * Electricity_Multiplier,
                                                                                                   input$ElectricitySlider == 4 ~ Scenario_4 * Electricity_Multiplier,
                                                                                                   input$ElectricitySlider == 3 ~  Scenario_3 * Electricity_Multiplier,
                                                                                                   input$ElectricitySlider == 2 ~  Scenario_2 * Electricity_Multiplier,
                                                                                                   input$ElectricitySlider == 1 ~ Scenario_1 * Electricity_Multiplier))))%>%
                                        select(Total_Emissions) %>%
                                        filter(Year == 2030)%>%
                                        summarise(test = sum(Total_Emissions)*150)%>%
                                        select(-Year)%>%return(formatC(test, big.mark = TRUE, digits = 2, justify = "none")), "(emissions x $150)."
                                      
                                      )})

      }

# Run the application 

shinyApp(ui = ui, server = server)