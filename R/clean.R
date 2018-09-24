## check dir
if (!file.exists("data-scribers.Rproj")) {
  stop("You're in the wrong working directory!")
}

## list of post files
posts <- list.files("content/post", full.names = TRUE)

## delete
unlink(posts)

## delete site
unlink("docs", recursive = TRUE)

## remove tmp resources dir
unlink("resources", recursive = TRUE)

