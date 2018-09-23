## check dir
if (!file.exists("data-scribers.Rproj")) {
  stop("You're in the wrong working directory!")
}

## read mwk lib
library(mwk)

## read data
blogs_data <- readRDS("~/Dropbox/blogs_data.rds")

## write function to create feed post
write_post <- function(url, pubdate, title, link, description) {
  if (is.na(url) || nchar(url) < 5) return(NULL)
  if (is.na(pubdate) || nchar(pubdate) < 5) return(NULL)
  if (is.na(title) || nchar(title) < 5) return(NULL)
  if (is.na(link) || nchar(link) < 5) return(NULL)
  if (is.na(pubdate) || as.Date("2017-01-01") > as.Date(pubdate)) return(NULL)
  tag <- gsub("[[:punct:]]", "", gsub("https?://", "", url))
  tag <- sub("^www", "", tag)
  author <- sub("https?://", "", url)
  title <- ifelse(nchar(title) > 30 & grepl(":", title),
    sub(":.*", "", title), title)
  title <- gsub('"', "'", title)
  if (grepl("about", title, ignore.case = TRUE) && nchar(title) < 7) {
    return(NULL)
  }
  slug <- gsub("[[:punct:]]", "", title)
  slug <- tolower(slug)
  slug <- gsub("\\W+", " ", slug)
  slug <- gsub("\\s+", "-", slug)
  if (nchar(slug) > 30) {
    slug <- substr(slug, 1, 30)
  }
  cats <- character()
  if (grepl("rstats|dplyr|ggplot|tidyverse|library\\(|r-project|\\br\\b",
    description, ignore.case = TRUE)) {
    cats[length(cats) + 1] <- "rstats"
  }
  if (grepl("python|panda|numpi|pytorch",
    description, ignore.case = TRUE)) {
    cats[length(cats) + 1] <- "python"
  }
  if (grepl("neural net|machine learn|tensorflow|keras|pytorch",
    description, ignore.case = TRUE)) {
    cats[length(cats) + 1] <- "machine-learning"
  }
  if (grepl("regression|ols|lm\\(|linear model|anova|modeling",
    description, ignore.case = TRUE)) {
    cats[length(cats) + 1] <- "modeling"
  }
  cats <- paste(paste0("  - ", c(cats, tag), "\n"), collapse = "")
  txt <- glue::glue("---
    title: \"{title}\"
    author: '{author}'
    date: '{pubdate}'
    slug: {slug}
    categories:
    - bloglink
    tags:
    {cats}---
    \n\n")
  p1 <- tfse::trim_ws(gsub("\n+", " ", description))
  p1 <- gsub("<pre.*|<script.*|<code", "", p1)
  p1 <- strsplit(p1, "\\.\\s+")[[1]]
  p1 <- textclean::replace_html(p1)
  p1 <- p1[cumsum(nchar(p1)) <= 400]
  p1 <- paste0(p1, ".")
  p1 <- paste(p1, collapse = " ")
  if (length(p1) == 0) return(NULL)
  if (nchar(p1) < 20) return(NULL)
  p1 <- tfse::trim_ws(gsub("\n|\t", " ", gsub("<[^>]+>", "", p1)))
  p1 <- gsub("[[:punct:] ]+$", "", p1)
  p1 <- substr(p1, 1, 1000)
  p1 <- sub("\\s+\\S+$", "", p1)
  p1 <- sub("\\.+$", "", p1)
  p1 <- paste0(p1, "[... <i class=\"fas fa-external-link-alt\"></i>](",
    link, ")\n")
  txt <- paste0(txt, p1)
  save_as <- paste0(pubdate, "-", slug, ".md")
  cat(txt, file = file.path("content/post", save_as), fill = TRUE)
}

## write/overwrite posts
for (i in seq_len(nrow(blogs_data))) {
  with(blogs_data[i, ],
    write_post(url, pubdate, title, link, description))
  cat(i, " ")
}

## build with hugo
blogdown::hugo_build(local = TRUE)
