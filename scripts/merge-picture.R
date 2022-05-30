library(magick)
library(cowplot)
ima1 <- ggdraw()+draw_image('figs/sp1-dis.png',width = 1)
ima2 <- ggdraw()+draw_image('figs/sp2-dis.png',width = 1)
ima3 <- ggdraw()+draw_image('figs/daylight.jpg',width = 1)
ima3
ima4 <- ggdraw()+draw_image('figs/night.jpg',width = 1)
plot_grid(ima1,ima3,ima2,ima4, labels = "AUTO",rel_widths = 1,rel_heights = 1)