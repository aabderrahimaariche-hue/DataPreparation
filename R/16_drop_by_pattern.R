#' Drop Datasets Matching a Pattern
#'
#' Removes all datasets whose names match a regex pattern.
#' Useful for cleanup if you consistently name temporary datasets (e.g., "temp_*")
#'
#' @param pattern Regex pattern to match (e.g., "^temp_" for temp_x, temp_y, etc.)
#' @param verbose Logical: print status messages? (default: TRUE)
#' @param confirm Logical: ask for confirmation before dropping? (default: TRUE)
#'
#' @return Invisible logical. TRUE if dropped, FALSE if cancelled or no matches.
#'
#' @examples
#' \dontrun{
#' # Drop all datasets starting with "temp_"
#' drop_by_pattern("^temp_")
#'
#' # Drop all datasets ending with "_old"
#' drop_by_pattern("_old$", confirm = FALSE)  # No confirmation needed
#' }
#'
#' @export
drop_by_pattern <- function(pattern, verbose = TRUE, confirm = TRUE) {
  
  # Find matching datasets
  all_datasets <- ls(envir = globalenv())
  matching <- grep(pattern, all_datasets, value = TRUE)
  
  if (length(matching) == 0) {
    if (verbose) {
      cat(sprintf("[DROP PATTERN] No datasets match pattern: %s\n\n", pattern))
    }
    return(invisible(FALSE))
  }
  
  if (verbose) {
    cat(sprintf("[DROP PATTERN] Found %d datasets matching pattern '%s':\n", 
                length(matching), pattern))
    for (ds in matching) {
      cat(sprintf("   %s (%s)\n", ds, get_dataset_size(ds, TRUE)))
    }
    cat("\n")
  }
  
  # Confirm before dropping
  if (confirm) {
    cat("Are you sure you want to drop these? (y/n): ")
    response <- readline()
    
    if (tolower(response) != "y") {
      cat("Cancelled.\n\n")
      return(invisible(FALSE))
    }
  }
  
  # Drop matching datasets
  total_freed <- 0
  for (ds in matching) {
    size_bytes <- object.size(get(ds, envir = globalenv()))
    rm(list = ds, envir = globalenv())
    total_freed <- total_freed + as.numeric(size_bytes)
  }
  
  if (verbose) {
    if (total_freed < 1024 * 1024) {
      total_str <- sprintf("%.1f KB", total_freed / 1024)
    } else if (total_freed < 1024 * 1024 * 1024) {
      total_str <- sprintf("%.1f MB", total_freed / (1024 * 1024))
    } else {
      total_str <- sprintf("%.2f GB", total_freed / (1024 * 1024 * 1024))
    }
    
    cat(sprintf("[DROP PATTERN]  Dropped %d datasets - Freed: %s\n\n", 
                length(matching), total_str))
  }
  
  return(invisible(TRUE))
}

