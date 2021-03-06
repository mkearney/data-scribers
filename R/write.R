## check dir
if (!file.exists("data-scribers.Rproj")) {
  stop("You're in the wrong working directory!")
}

## read mwk lib
library(mwk)

## git pull
system("git pull")

## read data
blogs_data <- readRDS("~/Dropbox/blogs_data.rds")

## write function to create feed post
write_post <- function(url, pubdate, title, link, description) {
  if (is.na(url) || nchar(url) < 5) return(NULL)
  if (is.na(pubdate) || nchar(pubdate) < 5) return(NULL)
  if (is.na(title) || nchar(title) < 5) return(NULL)
  if (is.na(link) || nchar(link) < 5) return(NULL)
  if (is.na(pubdate) || as.Date("2010-01-01") > as.Date(pubdate)) return(NULL)
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
  if (grepl("rstats|dplyr|ggplot|tidyverse|library\\(|r-project|\\br\\b|tidy|rstudio|package",
    description, ignore.case = TRUE)) {
    cats[length(cats) + 1] <- "rstats"
  }
  if (grepl("python|panda|numpi|pytorch|numpy|library|jupyter",
    description, ignore.case = TRUE)) {
    cats[length(cats) + 1] <- "python"
  }
  if (grepl("neural|machine learn|tensorflow|keras|pytorch",
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
    link: {link}
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
  p1 <- substr(p1, 1, 1200)
  p1 <- sub("\\s+\\S+$", "", p1)
  p1 <- sub("\\.[^\\.]+$", "", p1)
  p1 <- paste0(p1, "[... <i class=\"fas fa-external-link-alt\"></i>](",
    link, ")\n")
  txt <- paste0(txt, p1)
  save_as <- paste0(pubdate, "-", slug, ".md")
  cat(txt, file = file.path("content/post", save_as), fill = TRUE)
}

## write function that derives file name
slug2saveas <- function(x) {
  slug2saveas_ <- function(title, pubdate) {
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
    save_as <- paste0(pubdate, "-", slug, ".md")
  }
  purrr::map_chr(seq_len(nrow(x)), ~
      slug2saveas_(x$title[.x], x$pubdate[.x]))
}

## vector of all file names
new_posts <- slug2saveas(blogs_data)

## files already posted
old_posts <- list.files("content/post")

## logical indicating whether rows are new posts
new_posts <- !new_posts %in% old_posts

## subset blogs data
blogs_data <- blogs_data[new_posts, ]

## write/overwrite posts
for (i in seq_len(nrow(blogs_data))) {
  with(blogs_data[i, ],
    write_post(url, pubdate, title, link, description))
  cat(i, " ")
}

## build with hugo
blogdown::hugo_build()

## alt build fun (don't cleanup resources)
build_ds <- function(local = TRUE) {
  config <- blogdown:::load_config()
  blogdown:::hugo_cmd(c(if (local) c("-b", blogdown:::site_base_dir(), "-D", "-F"),
    "-d", shQuote(blogdown:::publish_dir(config)), blogdown:::theme_flag(config)))
}

#build_ds()
#blogdown::serve_site()
#blogdown::stop_server()

## remove tmp resources dir
#unlink("resources", recursive = TRUE)

## update git
system("git add .")
system("git commit -m 'cron update'")
system("git push")
