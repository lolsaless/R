install.packages('devtools')
remotes::install_github("bbc/bbplot") # 1

if(!require(pacman))install.packages("pacman")

pacman::p_load('dplyr', 'tidyr', 'gapminder',
               'ggplot2',  'ggalt',
               'forcats', 'R.utils', 'png', 
               'grid', 'ggpubr', 'scales',
               'bbplot')

#Data for chart from gapminder package
line_df <- gapminder %>%
    filter(country == "Malawi") 

#Make plot
line <- ggplot(line_df, aes(x = year, y = lifeExp)) +
    geom_line(colour = "#1380A1", size = 1) +
    geom_hline(yintercept = 0, linewidth = 1, colour="#333333") +
    bbc_style() +
    labs(title="Living longer",
         subtitle = "Life expectancy in Malawi 1952-2007")

line

finalise_plot(plot_name = line,
              source = "Source: Gapminder",
              save_filepath = "images/line_plot_finalised_test.png",
              width_pixels = 640,
              height_pixels = 550)

# 여러 줄 차트 만들기
#Prepare data
multiple_line_df <- gapminder %>%
    filter(country == "China" | country == "United States") 

#Make plot
multiple_line <- ggplot(multiple_line_df, aes(x = year, y = lifeExp, colour = country)) +
    geom_line(size = 1) +
    geom_hline(yintercept = 0, size = 1, colour="#333333") +
    scale_colour_manual(values = c("#FAAB18", "#1380A1")) +
    bbc_style() +
    labs(title="Living longer",
         subtitle = "Life expectancy in China and the US")
multiple_line


#####---------------(https://www.charlesbordet.com/en/make-beautiful-charts-ggplot2/#)-------------####

