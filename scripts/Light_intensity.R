library(tidyverse)

ALAN <- read.csv('data/ALAN_intensity.csv') %>% as_tibble()

ALAN %>% filter(Vertical == "L") %>% 
    filter(Direction %in% c("East", "West")) %>% 
    select(-Direction,-Vertical) %>% 
    mutate(y = 0) -> ALAN_x
names(ALAN_x)[2] <- "x"

ALAN %>% filter(Vertical == "L") %>% 
    filter(Direction %in% c("South", "North")) %>% 
    select(-Direction,-Vertical) %>% 
    mutate(x = 0) -> ALAN_y
names(ALAN_y)[2] <- "y"

rbind(ALAN_x,ALAN_y) -> LI



LI1 <- LI %>% filter(Plot == "RP2") %>% 
    filter(Device ==1 ) %>%
     filter(Intensity > 0)

LI1 %>%  ggplot(aes(x =x , y = y, size = Intensity)) +  
        geom_point() +
        theme_bw()


LI2 <- LI %>% filter(Plot == "RP5") %>% 
    filter(Device ==1 ) %>%
     filter(Intensity > 0)
LI2 %>%  ggplot(aes(x =x , y = y, size = Intensity)) +  
        geom_point() +
        theme_bw()
