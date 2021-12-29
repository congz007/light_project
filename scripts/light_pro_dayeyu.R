
library(tidyverse)
library(plotly)

leafdisc<- tibble()
leafdisc <- as_tibble(leaf_light_project) %>% 
  mutate(LMA = dry_weight/(disc*pi*0.0001)) %>% 
  mutate(Water_rate = (fresh_weight - dry_weight)/(disc*pi*0.0001))
head(leafdisc)

leafdisc %>% filter(Plot == 2) %>% 
ggplot(aes(x = Distance, y = LMA))+
    geom_point()+
    labs(title = "LMA_Colocasia_gigantea")+
    theme_bw()

leafdisc %>% filter(Plot == 5) %>% 
  ggplot(aes(x = Distance, y = LMA))+
  geom_point()+
  labs(title = "LMA_yemudan")+
  theme_bw()

dayeyu <- leafdisc %>% filter(Plot == 2) 
r1 <- lm(log(LMA) ~ log(Distance) * log(canopy_openness), data = dayeyu)
summary(r1)

attach(dayeyu)
plot_ly(x = ~log(Distance), y = ~canopy_openness, z = ~log(LMA),
        type="scatter3d", 
        mode="markers", color=~LMA)
detach(dayeyu)

yemudan <- leafdisc %>% filter(Plot == 5)
r2 <- lm(log(LMA) ~ log(Distance) * log(canopy_openness), data = dayeyu)
summary(r2)

attach(yemudan)
plot_ly(x = ~log(Distance), y = ~canopy_openness, z = ~log(LMA),
        type="scatter3d", 
        mode="markers", color=~LMA)
detach(yemudan)
