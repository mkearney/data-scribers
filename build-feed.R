

library(mwk)
library(rtweet)

b <- search_tweets("rstats post", include_rts = FALSE)
p2 <- h.rtweet::h.search_tweets("#rstats post until:2018-09-09", n = 5000)

d2 <- lookup_tweets(p2$status_id)
d <- rbind(d, d2)

df <- rbind(b, d)

df %>%
	filter(grepl("rstats", text, ignore.case = TRUE)) %>%
	pull(urls_expanded_url) %>%
	unlist() %>%
	grep("\\/post\\/", ., value = TRUE) %>%
	sub("\\/post.*", "", .) %>%
	unique() %>%
	sort() %>%
	saveRDS("list-of-blogs.rds")
