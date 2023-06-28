library(magick)
library(cowplot)
library(ggplot2)

ima3 <- ggdraw()+draw_image("figs/daylight.jpg",width = 1,height = 1)
ima3
ima4 <- ggdraw()+draw_image('figs/night.jpg',width = 1,height = 1)

png("figs/merge.png")
plot_grid(ima3,ima4,labels = "AUTO",scale = 0.8)
dev.off()
