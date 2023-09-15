pokemon <- pokemonGO

png(filename = "base_r.png", width = 640, height = 450)
plot(`Max CP` ~ `Max HP`, data = pokemon)
dev.off()

library(ggplot2)
ggplot(pokemon, aes(x = `Max HP`, y = `Max CP`)) +
    geom_point()
ggsave(filename = "base_ggplot.png", width = 640/72, height = 450/72, dpi = 72)

library(bbplot)
p <- ggplot(pokemon, aes(x = `Max HP`, y = `Max CP`)) +
    geom_point() +
    bbc_style()
finalise_plot(p, source_name = "Source: Kaggle", 
              save_filepath = "base_bbplot.png",
              width_pixels = 640, height_pixels = 450)

# 제목추가
p <- ggplot(pokemon, aes(x = `Max HP`, y = `Max CP`)) +
    geom_point() +
    # Title
    labs(title = "Relationship between Max CP and Max HP") +
    # Style
    bbc_style() +
    theme(plot.title = element_text(color = "#063376"))

finalise_plot(p, source_name = "Source: Kaggle", 
              save_filepath = "base_bbplot.png",
              width_pixels = 640, height_pixels = 450)


p <- ggplot(pokemon, aes(x = `Max HP`, y = `Max CP`)) +
    geom_point() +
    # Title
    labs(title = "Relationship between Max CP and Max HP") +
    # Axis
    scale_x_continuous(labels = function(x) paste0(x, " HP")) +
    scale_y_continuous(labels = function(y) paste0(y, " CP")) +
    # Style
    bbc_style() +
    theme(plot.title = element_text(color = "#063376"))

finalise_plot(p, source_name = "Source: Kaggle", 
              save_filepath = "base_bbplot.png",
              width_pixels = 640, height_pixels = 450)

p <- ggplot(pokemon, aes(x = `Max HP`, y = `Max CP`)) +
    geom_smooth(data = pokemon["Name" != "Chansey"], method = "lm", 
                se = FALSE, col = "#ee1515") +
    geom_point() +
    # Title
    labs(title = "Relationship between Max CP and Max HP") +
    # Axis
    scale_x_continuous(labels = function(x) paste0(x, " HP")) +
    scale_y_continuous(labels = function(y) paste0(y, " CP")) +
    # Style
    bbc_style() +
    theme(plot.title = element_text(color = "#063376"))

finalise_plot(p, source_name = "Source: Kaggle", 
              save_filepath = "base_bbplot.png",
              width_pixels = 640, height_pixels = 450)

p <- ggplot(pokemon, aes(x = `Max HP`, y = `Max CP`)) +
    geom_smooth(data = pokemon["Name" != "Chansey"], method = "lm", 
                se = FALSE, col = "#ee1515") +
    geom_point(aes(col = `Type 1`)) +
    # Title
    labs(title = "Relationship between Max CP and Max HP") +
    # Axis
    scale_x_continuous(labels = function(x) paste0(x, " HP")) +
    scale_y_continuous(labels = function(y) paste0(y, " CP")) +
    # Style
    bbc_style() +
    theme(plot.title = element_text(color = "#063376"))

finalise_plot(p, source_name = "Source: Kaggle", 
              save_filepath = "base_bbplot.png",
              width_pixels = 640, height_pixels = 450)

colors <- c("#1F77B4", "#AEC7E8", "#FF7F0E", "#FFBB78", "#2CA02C",
            "#98DF8A", "#D62728", "#FF9896", "#9467BD", "#C5B0D5",
            "#8C564B", "#E377C2", "#7F7F7F", "#BCBD22", "#17BECF")
p <- ggplot(pokemon, aes(x = `Max HP`, y = `Max CP`)) +
    geom_smooth(data = pokemon["Name" != "Chansey"], method = "lm", 
                se = FALSE, col = "#ee1515") +
    geom_point(aes(col = `Type 1`)) +
    # Title
    labs(title = "Relationship between Max CP and Max HP") +
    # Axis
    scale_x_continuous(labels = function(x) paste0(x, " HP")) +
    scale_y_continuous(labels = function(y) paste0(y, " CP")) +
    # Legend
    scale_color_manual(values = colors) +
    # Style
    bbc_style() +
    theme(plot.title = element_text(color = "#063376")) +
    theme(legend.text = element_text(size = 14))

finalise_plot(p, source_name = "Source: Kaggle", 
              save_filepath = "base_bbplot.png",
              width_pixels = 640, height_pixels = 450)

table_pokemon <- table(pokemon$`Type 1`)
table_pokemon

library(tidyverse)
pokemon_2 <- pokemon %>% mutate(types = ifelse(table_pokemon >= 10,
                                `Type 1`, "Other"))



pokemon[, `Type 1` = ifelse(table_pokemon >= 10,
                           `Type 1`, "Other")]
table_pokemon >= 10

pokemon[, `Type 1` = factor(`Type 1`, c("Bug", "Fire", "Grass", "Normal",
                                     "Poison", "Water", "Other"))]
sort(table(pokemon$`Type 1`))




p <- ggplot(pokemon, aes(x = `Max HP`, y = `Max CP`)) +
    geom_smooth(data = pokemon["Name" != "Chansey"], method = "lm", 
                se = FALSE, col = "#ee1515") +
    geom_point(aes(col = `Type 1`)) +
    # Arrow for pokemon Chansey
    geom_curve(aes(x = 375, y = 1500, xend = 404, yend = 860),
               colour = "#555555", curvature = -.2, size = .5,
               arrow = arrow(length = unit(0.03, "npc"))) +
    geom_label(aes(x = 330, y = 1400, label = "Chansey"),
               hjust = 0, vjust = 0, colour = "#555555",
               fill = "white", label.size = NA, size = 6) +
    # Arrow for pokemon Pikachu
    geom_curve(aes(x = 50, y = 1400, xend = 65, yend = 880),
               colour = "#555555", curvature = .2, size = .5,
               arrow = arrow(length = unit(0.03, "npc"))) +
    geom_label(aes(x = 50, y = 1460, label = "Pikachu"),
               hjust = .75, vjust = 0, colour = "#555555",
               fill = "white", label.size = NA, size = 6) +
    # Arrow for pokemon Snorlax
    geom_curve(aes(x = 290, y = 3335, xend = 270, yend = 3135),
               colour = "#555555", curvature = -.2, size = .5,
               arrow = arrow(length = unit(0.03, "npc"))) +
    geom_label(aes(x = 290, y = 3255, label = "Snorlax"),
               hjust = .3, vjust = 0, colour = "#555555",
               fill = "white", label.size = NA, size = 6) +
    # Arrow for pokemon Mewtwo
    geom_curve(aes(x = 155, y = 4100, xend = 175, yend = 4150),
               colour = "#555555", curvature = .2, size = .5,
               arrow = arrow(length = unit(0.03, "npc"))) +
    geom_label(aes(x = 155, y = 4100, label = "Mewtwo"),
               hjust = 1, vjust = .3, colour = "#555555",
               fill = "white", label.size = NA, size = 6) +
    # Title
    labs(title = "Relationship between Max CP and Max HP") +
    # Axis
    scale_x_continuous(labels = function(x) paste0(x, " HP")) +
    scale_y_continuous(labels = function(y) paste0(y, " CP")) +
    # Legend
    scale_color_manual(values = colors, 
                       guide = guide_legend(nrow = 1)) +
    # Style
    bbc_style() +
    theme(plot.title = element_text(color = "#063376"))

finalise_plot(p, source_name = "Source: Kaggle", 
              save_filepath = "base_bbplot.png",
              width_pixels = 640, height_pixels = 450)
