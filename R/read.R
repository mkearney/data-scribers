## check dir
if (!file.exists("data-scribers.Rproj")) {
  stop("You're in the wrong working directory!")
}

## load mwk pkgs and rtweet
library(mwk)
library(rtweet)

## read-in list of blogs
b0 <- readRDS("~/Dropbox/list-of-blogs.rds")

## save backup
saveRDS(b0, "~/Dropbox/list-of-blogs-og.rds")

## search for new blogs
b <- search_tweets("python OR rstats OR keras OR tensorflow OR #R url:post",
  include_rts = FALSE, n = 5000)

## filter, format, and merge with original blog links
b_links <- b %>%
	filter(grepl("rstats|python|keras|tensorflow|\\#r\\b", text, ignore.case = TRUE)) %>%
	pull(urls_expanded_url) %>%
	unlist() %>%
	grep("\\/post\\/", ., value = TRUE) %>%
  grep("curiouscat|r-bloggers", ., invert = TRUE, value = TRUE) %>%
  sub("\\/post.*", "", .) %>%
  c(b0) %>%
	unique() %>%
	sort()

## drop any http duplicates of https versions
drop <- rev(b_links) %>%
	sub("https:", "http:", .) %>%
	duplicated()
b_links <- rev(b_links)[!drop]
b_links <- sort(b_links)

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
  filter(grepl("/post/|201\\d/\\d{2}/\\d{2}/\\S+", link)) %>%
  unique()

## save blogs data
saveRDS(blogs_data, "~/Dropbox/blogs_data.rds")
