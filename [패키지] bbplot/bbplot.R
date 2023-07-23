if(!require(pacman))install.packages("pacman")

pacman::p_load('dplyr', 'tidyr', 'gapminder',
               'ggplot2',  'ggalt',
               'forcats', 'R.utils', 'png', 
               'grid', 'ggpubr', 'scales',
               'bbplot')

# install.packages('devtools')
remotes::install_github("bbc/bbplot") # 1

#Data for chart from gapminder package
line_df <- gapminder %>%
    filter(country == "Malawi") 

#Make plot
line <- ggplot(line_df, aes(x = year, y = lifeExp)) +
    geom_line(colour = "#1380A1", size = 1) +
    geom_hline(yintercept = 0, size = 1, colour="#333333") +
    bbc_style() +
    labs(title="Living longer",
         subtitle = "Life expectancy in Malawi 1952-2007")

line
