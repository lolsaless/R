library(xml2)
library(tidyverse)

xml_path <- "http://www.w3schools.com/xml/simple.xml"
raw_xml <- read_xml(xml_path)
raw_xml

food_node <- xml_children(raw_xml)
food_node

lapply(seq_along(food_node),
       function(x){
         temp_row <- xml_find_all(food_node[x], "./*")
         print(x)
         print(temp_row)
         tibble(
           idx = x,
           key = temp_row %>% xml_name(),
           value = temp_row %>% xml_text()
         ) %>% return()
       }) %>% bind_rows() %>% 
  spread(key, value) %>% 
  select(food_node %>% xml_children() %>% xml_name() %>% unique())


raw_xml
food_node %>% xml_children()
food_node[1] %>% xml_find_all(., "./*") %>% xml_name()
food_node[1] %>% xml_find_all(., "./*") %>% xml_text()
seq_along(food_node)

