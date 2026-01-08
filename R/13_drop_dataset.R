#' Drop a Dataset from Memory
#'
#' Removes a dataset from the global environment, freeing up RAM.
#' Use this after you're done using a large dataset to optimize memory usage.
#'
#' @param dataset_name Character: name of the dataset to drop
#' @param verify_before_drop Logical: warn before removing? (default: TRUE)
#' @param verbose Logical: print status messages? (default: TRUE)
#'
#' @return Invisible logical. TRUE if dropped successfully, FALSE if not found.
#'
#' @examples
#' \dontrun{
#' # Drop a dataset and free its memory
#' drop_dataset('my_data')
#' # Output:  Dropped 'my_data' - Freed: 2.49 GB
#' }
#'
#' @export
drop_dataset <- function(
  dataset_name,
  verify_before_drop = TRUE,
  verbose = TRUE
) {
  
  # Check if exists
  if (!exists(dataset_name, envir = globalenv())) {
    if (verbose) {
      cat(sprintf("[DROP]  Dataset '%s' not found in memory\n", dataset_name))
    }
    return(invisible(FALSE))
  }
  
  # Get size before dropping
  size_before <- object.size(get(dataset_name, envir = globalenv()))
  size_str <- get_dataset_size(dataset_name, human_readable = TRUE)
  
  # Verify before dropping
  if (verify_before_drop) {
    if (verbose) {
      cat(sprintf("[DROP] Preparing to remove '%s' (%s)\n", dataset_name, size_str))
    }
  }
  
  # Drop the dataset
  rm(list = dataset_name, envir = globalenv())
  
  if (verbose) {
    cat(sprintf("[DROP]  Dropped '%s' - Freed: %s\n\n", dataset_name, size_str))
  }
  
  return(invisible(TRUE))
}
