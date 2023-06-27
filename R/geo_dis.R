
plot_geo <- function(data) {
data$species[data$species =="Melastoma_candidum"] <-  "Melastoma candidum"
data$species[data$species =="Colocasia_gigantea"] <- "Colocasia gigantea"
data |> 
  mutate(LMA = dry_weight/(disc*pi*(0.005)^2)) |>
  mutate(x_loc = Distance*cos(angel*pi/180))|>
  mutate(y_loc = Distance*sin(angel*pi/180))|>
  ggplot(aes(x_loc, y_loc, color = LMA, size = 14))+
  guides(size = "none")+
  scale_color_gradient(low = "#43ff2a",
  high = "#105cff")+
  coord_fixed()+
  geom_hline(yintercept = 0,linetype="dotted")+
  geom_vline(xintercept = 0,linetype="dotted")+
  geom_point(shape =16,size = 8)+
  facet_wrap(vars(species),ncol = 2,strip.position = "top")+
  labs(x = "", y = "")+
  theme(strip.text = element_text(face = "italic",size = 28),
        axis.text.x=element_text(vjust=1,size=20),
        axis.text.y=element_text(vjust=1,size=20),
        legend.key.size = unit(1.5, 'cm'),
        legend.text = element_text(size = 10),
        legend.title = element_text(size=18),
        legend.position = c(0.95,0.5)) 
}