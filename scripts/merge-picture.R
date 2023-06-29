library(magick)
library(cowplot)
library(ggplot2)

ima3 <- ggdraw()+draw_image("figs/daylight.jpg")
ima4 <- ggdraw()+draw_image('figs/night.jpg')

png("figs/merge.png",
    width = 110,
    height = 57.7,
    units = "mm",
    bg = "white",
    res = 300)
plot_grid(ima3,ima4,
        align = "h",
        labels = c("A","B"),
        vjust = 1,
        hjust = 0.2,
        scale = 1,
        rel_widths = c(1, 1),
        rel_heights = c(1,1))+
        theme(plot.margin = unit(c(0.3,0.3,0.3,0.3), "cm")) 
dev.off()

p <- plot_grid(ima3,ima4,labels = "AUTO",scale = 0.8)
save_plot("merge.png", p, base_asp = 1.1)

