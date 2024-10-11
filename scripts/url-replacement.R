# Load necessary library
library(stringr)

# Get list of all .Rmd files in the directory and subdirectories
rmd_files <- list.files(pattern = "\\.Rmd$")

# Define old and new URLs
old_url <- "https://ecampus.uni-bonn.de/goto_ecampus_copa_3152113.html"
new_url <- "https://ecampus.uni-bonn.de/goto_ecampus_copa_3530257.html"

# Loop over each file and perform the replacement
for (file in rmd_files) {
  content <- readLines(file)
  content <- str_replace_all(content, fixed(old_url), new_url)
  writeLines(content, file)
}



#### removing header IDs in summary file

file_name <- "50_Term_papers.Rmd"
content <- readLines(file_name)

remove_braces_from_headers <- function(line) {
  if (grepl("^#+\\s+.*\\{.*\\}\\s*$", line)) {
    line <- sub("\\s*\\{.*\\}\\s*$", "", line)
  }
  return(line)
}

modified_content <- sapply(content, remove_braces_from_headers)

writeLines(modified_content, file_name)
