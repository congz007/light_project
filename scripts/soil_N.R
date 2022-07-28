#After we get soil NCP draw a picture
soil <- expand.grid("site" = c(paste0("site",1:5)),
               "year" = c("2019", "2022"),
               "distance" = c("0","10")) %>% mutate("N" = rbeta(20,2,2))%>% mutate("C" = rbeta(20,3,3))


p <- ggplot(soil, aes(x= year, y = N, fill= distance)) + 
  geom_boxplot()
#the distance and year must be character type?


library(GGally)
library(tidyverse)


soil <- read.csv("data-raw/soil_nutrients.csv")
soil

ratio <- function(data) {
     t <- data[2,]/data[1,]
     names(t) <- c("ratio_C","ratio_N","ratio_P","noyear")
     t
}

ave <- function(data) {
  tt <- map(data,mean)
  names(tt) <- c("ave_C","ave_N", "ave_P")
  as_tibble(tt)
}
#we prepare the ratio between year before and now and the ratio between distance 0 and 10.
#we also need the average value of C,N,P for two years 

t <- as_tibble(soil) %>% select(-Tag) %>%group_by(Plot,Distance) %>% nest() %>% 
      mutate(Ratio = map(data, ratio))%>%unnest(cols = c(data,Ratio)) %>% 
      select(-noyear)%>%ungroup%>%mutate(Plot = as.character(Plot))%>%mutate(Distance = as.character(Distance))
t

 u <- t %>% select(T.C,T.N,T.P,Year) %>% group_by(Year) %>% nest()
 v <- u %>% mutate(average = map(data, ave))
w <- v%>%unnest%>%ungroup()
#forget the distance oops

t %>%filter(Distance == 0) %>% ggplot(., aes(x = Year, y = T.C, color = Plot))+
      geom_point(size = 4)+geom_line(size = 1.5)

t %>%ggplot(., aes(x = Year, y = T.C, color = Plot, linetype = Distance))+
       geom_line(size = 1.5) +
       geom_point(size = 4, shape = 17) 

t %>%ggplot(., aes(x = Year, y = T.N, color = Plot, linetype = Distance))+
       geom_line(size = 1.5) +
       geom_point(size = 4, shape = 17) 

t %>%ggplot(., aes(x = Year, y = T.P, color = Plot, linetype = Distance))+
       geom_line(size = 1.5) +
       geom_point(size = 4, shape = 17) 

t %>% mutate(Year = as.character(Year)) %>%ggplot(., aes(x = Year,y = T.N, group  = Year))+
      geom_boxplot()
