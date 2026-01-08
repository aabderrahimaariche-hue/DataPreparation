#' Drop Multiple Datasets from Memory
#'
#' Removes multiple datasets at once, freeing up their combined memory.
#' More efficient than calling drop_dataset() multiple times.
#'
#' @param dataset_names Character vector: names of datasets to drop
#' @param verbose Logical: print status messages? (default: TRUE)
#'
#' @return Invisible logical (always TRUE if called successfully)
#'
#' @examples
#' \dontrun{
#' # Drop multiple datasets at once
#' drop_datasets(c('data1', 'data2', 'temp_data'))
#' # Output:  Dropped 3 datasets - Freed: 5.8 GB
#' }
#'
#' @export
drop_datasets <- function(dataset_names, verbose = TRUE) {
  
  if (verbose) {
    cat(sprintf("[DROP MULTIPLE] Removing %d datasets...\n", length(dataset_names)))
  }
  
  total_freed <- 0
  dropped_count <- 0
  
  for (ds_name in dataset_names) {
    
    if (!exists(ds_name, envir = globalenv())) {
      if (verbose) {
        cat(sprintf("   '%s' not found\n", ds_name))
      }
      next
    }
    
    # Get size before dropping
    size_bytes <- object.size(get(ds_name, envir = globalenv()))
    size_str <- get_dataset_size(ds_name, human_readable = TRUE)
    
    # Drop it
    rm(list = ds_name, envir = globalenv())
    dropped_count <- dropped_count + 1
    total_freed <- total_freed + as.numeric(size_bytes)
    
    if (verbose) {
      cat(sprintf("   '%s' - Freed: %s\n", ds_name, size_str))
    }
  }
  
  # Show summary
  if (verbose) {
    if (total_freed < 1024 * 1024) {
      total_str <- sprintf("%.1f KB", total_freed / 1024)
    } else if (total_freed < 1024 * 1024 * 1024) {
      total_str <- sprintf("%.1f MB", total_freed / (1024 * 1024))
    } else {
      total_str <- sprintf("%.2f GB", total_freed / (1024 * 1024 * 1024))
    }
    
    cat(sprintf("[DROP MULTIPLE]  Dropped %d dataset(s) - Total freed: %s\n\n", 
                dropped_count, total_str))
  }
  
  return(invisible(TRUE))
}
