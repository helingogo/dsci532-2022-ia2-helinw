library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(dplyr)
library(ggplot2)
library(plotly)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

olympic_data <- na.omit(readr::read_csv(here::here('data', 'olympics_data.csv')))
noc_list <- sort(unique(olympic_data$noc))

app$layout(
    dbcContainer(
        list(
            dccGraph(id='line_chart'),
            dccDropdown(
                id='noc-select',
                options = noc_list %>%
                    purrr::map(function(col) list(label = col, value = col)), 
                value='CAN')
        )
    )
)

app$callback(
    output('line_chart', 'figure'),
    list(input('noc-select', 'value')),
    function(noc1) {
        olympic_data_line_chart <- olympic_data %>%
            subset(noc == noc1)
        
        line_chart <- olympic_data_line_chart %>%
            ggplot(aes(x = year)) +
            geom_line(stat = 'count') +
            labs(
                x = "Year",
                y = "Count of medals",
                title = "Medals Earned Over Time"
            )
        ggplotly(line_chart)

    }
)

app$run_server(host = '0.0.0.0')
# app$run_server(debug = T)