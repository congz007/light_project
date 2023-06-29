plot_geo <- function(data) {
  data |>
    mutate(species = str_replace_all(species, "_", " ")) |>
    mutate(x_loc = distance * cos(angel * pi / 180)) |>
    mutate(y_loc = distance * sin(angel * pi / 180)) |>
    ggplot(aes(x_loc, y_loc, color = lma, size = 14)) +
      guides(size = "none")+
      scale_color_gradient(
        low = "#43ff2a",
        high = "#105cff")+
      coord_fixed()+
      geom_hline(yintercept = 0, linetype = "dotted") +
      geom_vline(xintercept = 0, linetype = "dotted") +
      geom_point(shape = 16, size = 2.5)+
      facet_wrap(vars(species), ncol = 2, strip.position = "top") +
      labs(x = "(m)", y = "(m)", col = expression(LMA~(gm^{-2})))+
      theme_bw()+
      theme(strip.text = element_text(face = "italic", size = 8),
            axis.text.x = element_text(vjust = 1, size = 10),
            axis.text.y = element_text(vjust = 1, size = 10),
            legend.key.size = unit(0.5, 'cm'),
            legend.text = element_text(size = 10),
            legend.title = element_text(size = 10),
            # legend.position = c(0.95, 0.5))
            legend.position = "right")
}

#' @title ggsave for targets
#' @inheritParams ggplot2::ggsave
my_ggsave <- function(filename, plot, units = c("in", "cm",
        "mm", "px"), height = NA, width = NA, dpi = 300, ...) {
  ggsave(
    filename = paste0(filename, ".png"),
    plot = plot,
    height = height,
    width = width,
    units = units,
    dpi = dpi,
    ...
  )
  ggsave(
    filename = paste0(filename, ".pdf"),
    plot = plot,
    height = height,
    width = width,
    units = units,
    dpi = dpi,
    ...
  )
  str_c(filename, c(".png", ".pdf"))
}
