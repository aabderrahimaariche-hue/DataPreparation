#' Get Total Memory Usage Summary
#'
#' Shows memory usage of all datasets currently in the environment.
#' Helps you understand which datasets are consuming the most RAM.
#'
#' @param top_n Integer: show only top N largest datasets? (default: NULL = all)
#' @param verbose Logical: print formatted table? (default: TRUE)
#'
#' @return Invisible data frame with columns: dataset, size_bytes, size_mb, size_gb
#'
#' @examples
#' \dontrun{
#' # See all datasets and their sizes
#' get_memory_summary()
#'
#' # See only top 5 largest datasets
#' get_memory_summary(top_n = 5)
#' }
#'
#' @export
get_memory_summary <- function(top_n = NULL, verbose = TRUE) {
  
  all_datasets <- ls(envir = globalenv())
  
  if (length(all_datasets) == 0) {
    if (verbose) {
      cat("[MEMORY] No datasets in environment\n")
    }
    return(invisible(NULL))
  }
  
  # Get sizes
  sizes <- sapply(all_datasets, function(ds) {
    as.numeric(object.size(get(ds, envir = globalenv())))
  })
  
  # Create summary data frame
  summary_df <- data.frame(
    dataset = names(sizes),
    size_bytes = sizes,
    size_mb = sizes / (1024 * 1024),
    size_gb = sizes / (1024 * 1024 * 1024),
    row.names = NULL
  )
  
  # Sort by size (largest first)
  summary_df <- summary_df[order(-summary_df$size_bytes), ]
  
  # Limit to top N if specified
  if (!is.null(top_n) && nrow(summary_df) > top_n) {
    summary_df <- summary_df[1:top_n, ]
  }
  
  if (verbose) {
    cat("[MEMORY SUMMARY]\n")
    cat("Dataset Name                Size (MB)     Size (GB)\n")
    cat("─────────────────────────────────────────────────────\n")
    
    total_size <- 0
    for (i in seq_len(nrow(summary_df))) {
      row <- summary_df[i, ]
      cat(sprintf("%-30s %10.1f MB   %8.2f GB\n",
                  row$dataset,
                  row$size_mb,
                  row$size_gb))
      total_size <- total_size + row$size_bytes
    }
    
    cat("─────────────────────────────────────────────────────\n")
    cat(sprintf("%-30s %10.1f MB   %8.2f GB\n",
                "TOTAL",
                total_size / (1024 * 1024),
                total_size / (1024 * 1024 * 1024)))
    cat("\n")
  }
  
  return(invisible(summary_df))
}
