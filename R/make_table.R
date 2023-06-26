
make_table <- function(data) {
   data %>% as_tibble() %>% select(-sp) %>%
  kbl(caption = "Coefficients table",col.names = c("Parameters", "Mean value", "95% CI" ),booktabs = T)%>% 
  kable_styling("striped", full_width = F) %>% 
  column_spec(3, bold = c(F,F,F,T,T,F)) %>%
  pack_rows("Melastoma candidum", 1, 3,italic = TRUE) %>%
  pack_rows("Colocasia_gigantea", 4, 6,italic = TRUE)
}
