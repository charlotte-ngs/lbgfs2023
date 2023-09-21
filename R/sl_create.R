

create_slides <- function(ps_sl_name, 
                          pb_edit = FALSE, 
                          pl_data = list(title = "Slide Title", author = "Peter von Rohr")){
  s_proj_dir <- here::here()
  s_sl_bn_noext <- fs::path_ext_remove(basename(ps_sl_name))
  s_sl_path <- file.path(s_proj_dir, "sl", s_sl_bn_noext, paste0(s_sl_bn_noext, ".Rmd"))
  rteachtools::create_slides(ps_sl_path = s_sl_path, 
                             pb_edit = pb_edit,
                             pl_data = pl_data)
                         
}