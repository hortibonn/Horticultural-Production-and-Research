# List all .Rmd files in the current directory
files <- list.files(pattern = "\\.Rmd$")

# subset for all relevant chapters
files <- files[c(1:13)]

# Loop through each file
for (file in files) {
  # Read the content of the file
  lines <- readLines(file)
  
  # Find the line number where "## Term paper topics" starts
  idx_start <- grep("^## Term paper topics", lines)
  
  # Proceed only if the section exists in the file
  if (length(idx_start) > 0) {
    idx_start <- idx_start[1] + 1  # Move to the line after "## Term paper topics"
    
    # Find the line numbers of all section headers that start with "## " or higher
    idx_headers <- grep("^## ", lines)
    
    # Find the line number where the next section starts after "## Term paper topics"
    idx_end_candidates <- idx_headers[idx_headers > idx_start - 1]
    idx_end <- ifelse(length(idx_end_candidates) > 0, idx_end_candidates[1] - 1, length(lines))
    
    # Extract the section
    section <- lines[idx_start:idx_end]
    
    # Define the pattern to match term paper topic titles with numbering
    pattern_numbered <- "^\\*\\*[0-9]+\\. (.+)\\*\\*$"
    
    # Define the pattern to match term paper topic titles without numbering
    pattern_unnumbered <- "^\\*\\*(.+)\\*\\*$"
    
    # Process the section to remove numbering
    for (i in seq_along(section)) {
      line <- section[i]
      if (grepl(pattern_numbered, line)) {
        # Extract the title without the numbering
        title <- sub(pattern_numbered, "\\1", line)
        # Reconstruct the line without numbering
        new_line <- paste0("**", title, "**")
        # Replace the line
        section[i] <- new_line
      } else if (grepl(pattern_unnumbered, line)) {
        # Line is already unnumbered; no action needed
        next
      }
    }
    
    # Replace the original section in lines
    lines[idx_start:idx_end] <- section
    
    # Write the modified content back to the file
    writeLines(lines, file)
  }
}
