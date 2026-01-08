#' Drop Dataset if It Exists (Safe Removal)
#'
#' Safely removes datasets without throwing errors if they don't exist.
#' Useful for cleanup code where you're not sure which datasets are in memory.
#'
#' @param dataset_names Character vector or single name: datasets to remove
#' @param verbose Logical: print status messages? (default: TRUE)
#'
#' @return Invisible logical (always TRUE)
#'
#' @examples
#' \dontrun{
#' # Drop datasets safely (no error if missing)
#' drop_if_exists(c('data1', 'missing_data', 'temp'))
#' # Drops data1 and temp, silently skips missing_data
#' }
#'
#' @export
drop_if_exists <- function(dataset_names, verbose = TRUE) {
  
  # Normalize input
  if (is.character(dataset_names) && length(dataset_names) == 1) {
    dataset_names <- c(dataset_names)
  }
  
  if (verbose) {
    cat(sprintf("[DROP SAFE] Attempting to remove %d dataset(s)\n", length(dataset_names)))
  }
  
  existing_datasets <- ls(envir = globalenv())
  
  for (ds_name in dataset_names) {
    
    if (ds_name %in% existing_datasets) {
      size_str <- get_dataset_size(ds_name, human_readable = TRUE)
      rm(list = ds_name, envir = globalenv())
      
      if (verbose) {
        cat(sprintf("   Dropped '%s' (%s)\n", ds_name, size_str))
      }
    } else {
      if (verbose) {
        cat(sprintf("  - '%s' not in memory (skipped)\n", ds_name))
      }
    }
  }
  
  if (verbose) {
    cat("\n")
  }
  
  return(invisible(TRUE))
}
