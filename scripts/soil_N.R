library(GGally)
library(tidyverse)
library(ggpubr)

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
      geom_point(size = 4)+geom_line(size = 1.5)+ ggtitle("Under ALAN")

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

t %>% ggplot(.,aes(x = Distance, y = ratio_N))+ geom_boxplot()

t %>% filter(Plot == c(2,5)) %>% ggplot(.,aes(x = Distance, y = ratio_N, shape = Plot))+ geom_point(size = 10)

p1 <- t %>% ggplot(.,aes(x = Distance, y = ratio_C, shape = Plot))+ geom_point(size = 8)
p2 <- t %>% ggplot(.,aes(x = Distance, y = ratio_N, shape = Plot))+ geom_point(size = 8)
p3 <- t %>% ggplot(.,aes(x = Distance, y = ratio_P, shape = Plot))+ geom_point(size = 8)

ggarrange(p1,p2,p3,nrow = 1, common.legend = T,heights = 0.8)


p1 <- t %>% filter(Plot == c(2,5))%>% ggplot(.,aes(x = Distance, y = ratio_C, shape = Plot))+ geom_point(size = 8)
p2 <- t %>% filter(Plot == c(2,5))%>% ggplot(.,aes(x = Distance, y = ratio_N, shape = Plot))+ geom_point(size = 8)
p3 <- t %>% filter(Plot == c(2,5))%>% ggplot(.,aes(x = Distance, y = ratio_P, shape = Plot))+ geom_point(size = 8)
ggarrange(p1,p2,p3,nrow = 1, common.legend = T,heights = 0.8)
