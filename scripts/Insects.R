library(tidyverse)

Insect <- read.csv('data/Drymass_funnel.csv') %>% as_tibble()

Insect %>% filter(distance %in% c(0,10)) %>%
        filter(habitat %in% paste0("RP",1:5)) -> Inse

Inse1 <- Inse %>% filter(time == "yes") %>% select(-time)
Inse2 <- Inse %>% filter(time == "no") %>% select(-time) %>%
         rename_at(5, ~'dry2')

inner_join(Inse1,Inse2, by = c("month","habitat","method", "distance")) %>% 
        mutate(dry = drymass + dry2) %>%
        select(month,habitat,distance,dry) -> Night_Inse

Night_Inse$distance <- as.factor(Night_Inse$distance)
Night_Inse <- Night_Inse %>% 
    filter(habitat %in% c("RP2", "RP5")) %>% 
    mutate(species = ifelse(habitat == "RP5", 
                            "Melastoma candidum",
                            "Colocasia gigantea"))

Night_Inse %>% filter(dry < 0.5 ) %>%
         ggplot(aes(x = distance, y = dry)) +
            geom_boxplot() + facet_grid(~species) + 
            theme(strip.text = element_text(face = "italic", size = 15))

