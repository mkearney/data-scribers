## check dir
if (!file.exists("data-scribers.Rproj")) {
  stop("You're in the wrong working directory!")
}

## load mwk pkgs and rtweet
library(mwk)
library(rtweet)

## read-in list of blogs
b0 <- readRDS("~/Dropbox/list-of-blogs-final.rds")

## save backup
saveRDS(b0, "~/Dropbox/list-of-blogs-og.rds")

## search for new blog/posts about rstats, python, and machine learning
r <- search_tweets(paste0('((rstats OR #R OR tidyverse OR ggplot2 OR ggplot OR ',
  'dplyr OR tidyeval OR rstudio) OR ("R package")) url:post'),
  include_rts = TRUE, n = 5000, verbose = FALSE)
r2 <- search_tweets(paste0('((rstats OR #R OR tidyverse OR ggplot2 OR ggplot OR ',
  'dplyr OR tidyeval OR rstudio) OR ("R package")) url:2018/', substr(Sys.Date(), 6, 7)),
  include_rts = TRUE, n = 5000, verbose = FALSE)
p <- search_tweets(paste0('((python AND pandas) OR numpy OR #python OR pytorch ',
  'OR #jupyter) OR ("python library") url:post'),
  include_rts = TRUE, n = 5000, verbose = FALSE)
p2 <- search_tweets(paste0('((python AND pandas) OR numpy OR #python OR pytorch ',
  'OR #jupyter) OR ("python library") url:2018/', substr(Sys.Date(), 6, 7)),
  include_rts = TRUE, n = 5000, verbose = FALSE)
m <- search_tweets(paste0('"machine learning" OR keras OR tensorflow OR "neural ',
  'network" OR "neural networks" OR "deep learning" url:post'),
  include_rts = TRUE, n = 5000, verbose = FALSE)
m2 <- search_tweets(paste0('"machine learning" OR keras OR tensorflow OR "neural ',
  'network" OR "neural networks" OR "deep learning" url:2018/', substr(Sys.Date(), 6, 7)),
  include_rts = TRUE, n = 5000, verbose = FALSE)

## merge into single data frame
b <- bind_rows(r, r2, p, p2, m, m2)

## filter, format, and merge with original blog links
b_links <- b %>%
	filter(grepl(paste0("rstats|python|keras|tensorflow|\\#r\\b|numpy|pytorch',
	  '|jupyter|neural|machine learning|ggplot|tidy|dplyr|rstudio|package|library"),
	  text, ignore.case = TRUE)) %>%
	pull(urls_expanded_url) %>%
	unlist() %>%
	grep("\\/post\\/|/2018/\\d{2}", ., value = TRUE) %>%
  grep("curiouscat|r-bloggers", ., invert = TRUE, value = TRUE) %>%
  sub("\\/post.*", "", .) %>%
  sub("/2018/\\d{2}/.*", "", .) %>%
  c(b0) %>%
  sub("\\#.*|\\?", "", .) %>%
  sub("/2018/\\d{2}/.*", "", .) %>%
  unique() %>%
	sort()

## remove duplicates
uq <- sub("https?://", "", b_links)
uq <- gsub("^www\\.|/$", "", uq)
b_links <- b_links[!(grepl("netlify", b_links) & duplicated(sub("\\.netlify", "", uq))) |
  duplicated(uq)]

drop <- sort(table(gsub("https?://|/[^/]+$", "", b_links)))
drop <- drop[drop > 1]
drop <- gsub("\\.", "\\\\.", names(drop))
drop <- paste0(drop, collapse = "|")
b_links <- grep(drop, b_links, ignore.case = TRUE, invert = TRUE,
  value = TRUE)

## save updated b_links list
saveRDS(b_links, "~/Dropbox/list-of-blogs-final.rds")

## write fun to parse RSS
parse_indexxml <- function(url) {
  require(magrittr, quietly = TRUE)
	h <- tryCatch(suppressWarnings(
	  xml2::read_xml(
	    paste0(url, "/index.xml"),
	    as_html = TRUE,
	    encoding = "UTF-8")),
	  error = function(e) NULL)
	if (is.null(h)) return(list())
	items <- rvest::html_nodes(h, "item")
	title <- items %>% rvest::html_nodes("title") %>%
	  rvest::html_text(trim = TRUE)
	title <- gsub("\\[", "(", title)
	title <- gsub("\\]", ")", title)
	pubdate <- items %>%
	  rvest::html_nodes("pubdate") %>%
	  rvest::html_text(trim = TRUE)
	link <- items %>%
	  rvest::html_nodes("guid") %>%
	  rvest::html_text(trim = TRUE)
	description <- items %>%
	  rvest::html_nodes("description") %>%
	  rvest::html_text(trim = TRUE)
	has_html <- grepl("^<html>|^<!DOCTYPE", description)
	description <- ifelse(has_html, "", description)
	has_ps <- grepl("<p>", description)
	description <- ifelse(has_ps,
	  description %>%
	    chr::chr_extract("<p>[^<][^/]+</p>") %>%
	    purrr::map_chr(paste, collapse = " ") %>%
	    gsub("<p>|</p>|^NA$", "", .),
	  description)
	description <- description %>%
	  gsub("<\\!--[^>]+>", "", .) %>%
	  gsub("<style>[^<][^/]+</style>", "", .) %>%
	  gsub("\\S+\\s?\\{\\s?\\S+\\s?:[^\\}]+\\}\\s{0,}", "", .) %>%
	  gsub("<script>[^<][^/]+</script>", "", .)
	base <- paste0(url, link)
	tibble::data_frame(url, title, pubdate, link, description)
}

## safe and verbose function to parse rss feeds
get_indexml <- function(x) {
	r <- tryCatch(parse_indexxml(x), error = function(e) return(NULL))
	if (is.null(r)) return(list())
	cat("+")
	r
}

## iterate through blogs
blogs <- purrr::map(b_links, get_indexml)

## collapse into single data frame (with unique obs)
blogs_data <- unique(bind_rows(blogs))

## convert date-time to date
blogs_data$pubdate <- blogs_data$pubdate %>%
  as.POSIXct(format =  "%a, %d %b %Y %H:%M:%S") %>%
  as.character() %>%
  as.Date()

## fix links
blogs_data$link <- ifelse(grepl("^http", blogs_data$link),
  blogs_data$link, paste0(blogs_data$url, blogs_data$link))

## filter only blog posts
blogs_data <- blogs_data %>%
  arrange(desc(pubdate)) %>%
  filter(grepl("(/post/)|(201\\d/\\d{2}/\\S+)", link)) %>%
  unique()

## remove duplicates
dups <- duplicated(blogs_data$link) | duplicated(blogs_data$link, fromLast = TRUE)
dups <- (dups & grepl("www|netflify", blogs_data$link)) |
  (duplicated(blogs_data$link) & !grepl("www|netflify", blogs_data$link))
blogs_data <- blogs_data[!dups, ]

## save blogs data
saveRDS(blogs_data, "~/Dropbox/blogs_data.rds")
