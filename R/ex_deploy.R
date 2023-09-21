## --- Exercise Deployment Wrapper --------------------------------------------
#'
#' @title Exercise Deployment
#'
#' @description
#' Wrapper for deployment of a given exercise in a course. The deployment
#' consists of producing the pdf-output of the exercise without solutions and
#' the pdf-document with the solutions.
#'
#' @details
#' This wrapper assumes that the source Rmd file containing the exercise problems
#' and the solutions is in a subdirectory called 'ex' under the course project directory.
#'
#' @examples
#' \dontrun{
#' devtools::load_all()
#' deploy_exercise(ps_ex_name = 'lbg_ex02')
#' }
#'
#' @param ps_ex_name exercicse name
#'
#' @export deploy_exercise
deploy_exercise <- function(ps_ex_name){

  s_proj_dir <- here::here()
  s_proj_name <- basename(s_proj_dir)
  s_out_dir <- file.path(s_proj_dir, 'docs')
  s_rexpf_dir <- file.path(dirname(dirname(s_proj_dir)), 'rexpf', s_proj_name)
  # call rteachtools deployment function with a set of default parameters
  rteachtools::deploy_ex(ps_ex_path = file.path(s_proj_dir, 'ex', ps_ex_name, ps_ex_name),
                         ps_ex_out_dir = file.path(s_out_dir, 'ex'),
                         ps_sol_out_dir = file.path(s_out_dir, 'sol'),
                         ps_rexpf_src   = file.path(s_proj_dir, 'nb'),
                         ps_rexpf_trg   = s_rexpf_dir)

  return(invisible(NULL))

}

#' Deployment Based on Unified Source File
#'
#' The unified source file is modified by cutting out selected
#' sections which characteristic for certain output instance.
#'
#' @param ps_ex_name name of exercise
#'
#' @examples
#' \dontrun{
#' devtools::load_all();deploy_uni_src(ps_ex_name = 'lbg_ex02')
#' }
deploy_uni_src <- function(ps_ex_name){
  s_proj_dir <- here::here()
  s_proj_name <- basename(s_proj_dir)
  s_out_dir <- file.path(s_proj_dir, 'docs')
  # rexpf directory
  s_rexpf_dir <- file.path(dirname(dirname(s_proj_dir)), 'rexpf', s_proj_name)
  # call the deployment in rteachtools
  rteachtools::deploy_src_to_ex_sol(ps_uni_src_path = file.path(s_proj_dir, 'ex', ps_ex_name, ps_ex_name),
                                    ps_ex_out_dir   = file.path(s_out_dir,"ex"),
                                    ps_sol_out_dir  = file.path(s_out_dir,"sol"),
                                    ps_nb_src_dir   = file.path(s_proj_dir, "nb", ps_ex_name),
                                    ps_nb_out_dir   = file.path(s_out_dir, "nb"),
                                    ps_rexpf_trg    = s_rexpf_dir) # needs to be implemented first

  return(invisible(NULL))
}
