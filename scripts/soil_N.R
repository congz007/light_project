#After we get soil NCP draw a picture
soil <- expand.grid("site" = c(paste0("site",1:5)),
               "year" = c("2019", "2022"),
               "distance" = c("0","10")) %>% mutate("N" = rbeta(20,2,2))%>% mutate("C" = rbeta(20,3,3))


p <- ggplot(soil, aes(x= year, y = N, fill= distance)) + 
  geom_boxplot()
#the distance and year must be character type?