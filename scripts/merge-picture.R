library(magick)
library(cowplot)
library(ggplot2)

ima3 <- ggdraw()+draw_image("figs/daylight.jpg",width = 1.2,height = 1.2)
ima4 <- ggdraw()+draw_image('figs/night.jpg',width = 1.2,height = 1.2)

png("figs/merge.png",
    width = 110,
    height = 50,
    units = "mm",
    bg = "white",
    res = 300)
plot_grid(ima3,ima4,labels = "AUTO",scale = 0.7)
dev.off()

p <- plot_grid(ima3,ima4,labels = "AUTO",scale = 0.8)
save_plot("merge.png", p, base_asp = 1.1)

