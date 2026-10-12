# # List all .Rmd files in the current render 
# files <- yaml::read_yaml("_bookdown.yml")$rmd_files
# 
# # Initialize a vector to store the extracted sections, starting with "# Term paper topics"
# term_paper_sections <- c("# Term paper topics", "")
# 
# # Initialize topic number counter
# topic_number <- 1
# 
# # Loop through each file
# for (file in files) {
#   # Read the content of the file
#   lines <- readLines(file)
#   
#   # Find the line number where "## Term paper topics" starts
#   idx_start <- grep("^## Term paper topics", lines)
#   
#   # Proceed only if the section exists in the file
#   if (length(idx_start) > 0) {
#     idx_start <- idx_start[1] + 1  # Skip the "## Term paper topics" line
#     
#     # Find the line numbers of all section headers that start with "## "
#     idx_headers <- grep("^## ", lines)
#     
#     # Find the line number where the next section starts after "## Term paper topics"
#     idx_end_candidates <- idx_headers[idx_headers > idx_start - 1]
#     idx_end <- ifelse(length(idx_end_candidates) > 0, idx_end_candidates[1] - 1, length(lines))
#     
#     # Extract the section
#     section <- lines[idx_start:idx_end]
#     
#     # Get the chapter title
#     chapter_title_line <- grep("^#", lines)[1]
#     chapter_title <- lines[chapter_title_line]
#     
#     # Modify chapter title to have "##" instead of "#"
#     chapter_title <- sub("^#+", "##", chapter_title)
#     
#     # Process the section to add continuous numbering to term paper topics
#     # Define the pattern to match term paper topic titles without numbering
#     pattern_unnumbered <- "^\\*\\*(.+)\\*\\*$"
#     
#     # Loop through section lines and add numbering
#     for (i in seq_along(section)) {
#       line <- section[i]
#       if (grepl(pattern_unnumbered, line)) {
#         # Extract the title
#         title <- sub(pattern_unnumbered, "\\1", line)
#         # Trim any leading/trailing whitespace
#         title <- trimws(title)
#         # Reconstruct the line with new numbering
#         new_line <- paste0("**", topic_number, ". ", title, "**")
#         # Replace the line
#         section[i] <- new_line
#         # Increment the topic number
#         topic_number <- topic_number + 1
#       }
#     }
#     
#     # Append the chapter title and the processed section to term_paper_sections
#     term_paper_sections <- c(term_paper_sections, chapter_title, "", section, "")
#   }
# }
# 
# # Write the collected sections to a new .Rmd file
# writeLines(term_paper_sections, "50_Term_papers.Rmd")

files <- yaml::read_yaml("_bookdown.yml")$rmd_files

term_paper_sections <- c("# Term paper topics", "")

topic_number <- 1

for (file in files) {
  
  lines <- readLines(file)
  
  idx_start <- grep("^## Term paper topics", lines)
  
  if (length(idx_start) == 0) next
  
  idx_start <- idx_start[1] + 1
  
  idx_headers <- grep("^## ", lines)
  idx_end_candidates <- idx_headers[idx_headers >= idx_start]
  
  idx_end <- if (length(idx_end_candidates) > 0) {
    idx_end_candidates[1] - 1
  } else {
    length(lines)
  }
  
  if (idx_start > idx_end) next
  
  section <- lines[idx_start:idx_end]
  
  # Get chapter title
  chapter_title <- lines[grep("^# ", lines)[1]]
  chapter_title <- sub("^# ", "## ", chapter_title)
  
  # Find title lines, including multiline titles
  idx_topics <- grep("^\\*\\*", section)
  
  for (i in idx_topics) {
    
    # Remove any existing numbering first
    title_line <- sub(
      "^\\*\\*[0-9]+\\.\\s*",
      "**",
      section[i]
    )
    
    # Add continuous numbering
    section[i] <- sub(
      "^\\*\\*",
      paste0("**", topic_number, ". "),
      title_line
    )
    
    topic_number <- topic_number + 1
  }
  
  term_paper_sections <- c(
    term_paper_sections,
    chapter_title,
    "",
    section,
    ""
  )
}

writeLines(term_paper_sections, "50_Term_papers.Rmd")