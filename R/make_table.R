
make_table <- function(data) {
  data %>% as_tibble() %>% select(-sp) %>%
  kbl(caption = "Coefficients table",col.names = c("Parameters", "Mean value", "95% CI" ),booktabs = T)%>% 
  kable_styling("striped", full_width = F) %>% 
  column_spec(3, bold = c(F,F,F,T,T,F)) %>%
  pack_rows("Melastoma candidum", 1, 3,italic = TRUE) %>%
  pack_rows("Colocasia_gigantea", 4, 6,italic = TRUE)
}

table_summary <- function(summary_stan){
  parameters <- rep(c("ALAN",
                   "Daylight",
                   "ALAN \u00D7 Daylight"),2)
  quantile_interval <-  paste0("[",format(round(summary_stan$q2.5,4),nsmall = 4),", ",  round(summary_stan$q97.5,4),"]")
  mean <- round(summary_stan$mean,4)

  tibble(parameters, mean, quantile_interval) |> 
    kbl(col.names = c("Variables", "Mean", "95% CI"),
        booktabs = T, digits = 4) |>
    kable_classic(full_width = F) |>
    column_spec(3,bold = c(F,F,F,T,T,F)) |>
    pack_rows("Melastoma candidum", 1, 3, italic = TRUE) |>
    pack_rows("Colocasia gigantea", 4, 6, italic = TRUE) 
}

my_kable_save <- function(table, tablename) {
#  save_kable(
#    x = table,
#    file = paste0(tablename,".png"),
#    density = 1200
#)
  save_kable(
    x = table,
    file = paste0(tablename,".html"),
    density = 300
  )
#  str_c(tablename, c(".png", ".pdf"))
  str_c(tablename, ".html")
#  webshot::webshot("Table1.html", "Table1.pdf") 
}
