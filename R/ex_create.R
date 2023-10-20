

#' Generic Function For Creating New Exercise
#'
#' This is a convenience function for collecting the input for calling the
#' function \code{rteachtools::create_exercise()}.
#'
#' @param ps_ex_name name of the exercise
#' @param ps_course_name name of the course for which the exercise is created
#' @param pn_exercise_count the number of the exercise in the course
#' @param ps_author author of the exercise
#' @param pn_nr_problem the number of problems in the exercise
#' @param pd_creation_date date of creation of the exercise
#' @param pb_edit should created file be directly edited
#'
#' @examples
#' \dontrun{
#' create_exercise(ps_ex_name        = "lbg_ex01",
#'                 ps_course_name    = "Livestock Breeding and Genomics",
#'                 pn_exercise_count = 1,
#'                 ps_author         = "Peter von Rohr",
#'                 pn_nr_problem     = 2)
#'
#' }
create_exercise <- function(ps_ex_name,
                            ps_course_name,
                            pn_exercise_count,
                            ps_author,
                            pn_nr_problem,
                            pd_creation_date = format(Sys.Date(), "%Y-%m-%d"),
                            pb_edit          = FALSE){
  s_proj_dir <- here::here()
  s_ex_src_path <- file.path(s_proj_dir, "ex", ps_ex_name, paste0(ps_ex_name, ".Rmd"))

  rteachtools::create_exercise(ps_ex_path    = s_ex_src_path,
                               pn_nr_problem = pn_nr_problem,
                               pl_data       = list(course_name     = ps_course_name,
                                                    exercise_count = pn_exercise_count,
                                                    creation_date  = pd_creation_date,
                                                    author         = ps_author))
  if (pb_edit) usethis::edit_file(path = s_ex_src_path)

  return(invisible(NULL))

}


#' Wrapper for Livestock Breeding and Genomics Exercises
#'
#' @param ps_ex_name name of the exercise
#' @param pn_exercise_count the number of the exercise in the course
#' @param ps_author author of the exercise
#' @param pn_nr_problem number of problems in the exercise
#' @param pd_creation_date creation data of the exercise
#' @param pb_edit should created file be directly edited
#'
#' @examples
#' \dontrun{
#' devtools::load_all()
#' create_exercise_lbg(ps_ex_name        = "lbg_ex01")
#' }
create_exercise_lbg <- function(ps_ex_name,
                                pn_exercise_count = NULL,
                                ps_author = "Peter von Rohr",
                                pn_nr_problem = 3,
                                pd_creation_date = format(Sys.Date(), "%Y-%m-%d"),
                                pb_edit          = TRUE){
  # determine default of exercise count based on numeric part of ps_ex_name
  n_exercise_count <- pn_exercise_count
  if (is.null(n_exercise_count)){
    n_exercise_count <- as.numeric(gsub(pattern = "lbg_ex", replacement = "", ps_ex_name, fixed = TRUE))
  }

  create_exercise(ps_ex_name        = ps_ex_name,
                  ps_course_name    = "Livestock Breeding and Genomics",
                  pn_exercise_count = n_exercise_count,
                  ps_author         = ps_author,
                  pn_nr_problem     = pn_nr_problem,
                  pd_creation_date  = pd_creation_date,
                  pb_edit           = pb_edit)

  return(invisible(NULL))
}
