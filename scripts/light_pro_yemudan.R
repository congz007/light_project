tempdir <- function() "D:/R"
unlockBinding("tempdir", baseenv())
utils::assignInNamespace("tempdir", tempdir, ns="base", envir=baseenv())
assign("tempdir", tempdir, baseenv())
lockBinding("tempdir", baseenv())

library(tidyverse)
library(plotly)

yemudan <- tibble()
yemudan <- as_tibble(leaf_light_proj_yemudan) %>% 
  mutate(LMA = dry_weight/(disc_number*pi*0.0001)) %>% 
  mutate(Water_rate = (fresh_weight - dry_weight)/(disc_number*pi*0.0001)) #%>% 
ggplot(dayeyu,aes(x = ditance, y = LMA))+
  geom_point()+
  theme_bw()

dayeyu$LMA
ggplot(dayeyu,aes(x = ditance, y = LMA))+
  geom_point()+
  geom_smooth()+
  labs(title = "LMA_Colocasia_gigantea")+
  theme_bw()


detach(light_proj_dayeyu)
attach(dayeyu)
detach(dayeyu)
?lm()
lm(LMA ~ ditance+ canopy_openness, data = dayeyu)
r <- lm(log(LMA) ~ log(ditance) * log(canopy_openness), data = dayeyu)
summary(r)