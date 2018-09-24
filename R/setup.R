## install tfse (from github)
if (!requireNamespace("tfse", quietly = TRUE)) {
  if (!requireNamespace("remotes", quietly = TRUE)) {
    install.packages("remotes")
  }
  remotes::install_github("mkearney/tfse")
}

## install newest version of rtweet
if (!requireNamespace("rtweet", quietly = TRUE)) {
  remotes::install_github("mkearney/rtweet")
}

## install newest version of blogdown
if (!requireNamespace("blogdown", quietly = TRUE)) {
  remotes::install_github("rstudio/blogdown")
}

## install tidyverse and other parsing-assisting pkgs
tfse::install_if(c("textclean", "tidyverse", "rvest"))

## if mwk doesn't exist yet...
if (!requireNamespace("mwk", quietly = TRUE)) {
  if (!requireNamespace("pkgverse", quietly = TRUE)) {
    remotes::install_github("mkearney/pkgverse")
  }
  ## create mwk pkg
  pkgverse::pkgverse("mwk", c("dplyr", "purrr", "tibble", "ggplot2"))
}
