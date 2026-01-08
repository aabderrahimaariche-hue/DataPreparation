#' Get Memory Usage of a Dataset
#'
#' Check how much RAM a dataset uses in the environment.
#' Useful for monitoring which datasets are consuming the most memory.
#'
#' @param dataset_name Character: name of the dataset to check
#' @param human_readable Logical: format as MB/GB? (default: TRUE)
#'   If FALSE, returns raw bytes.
#'
#' @return Character string with formatted size (e.g., "2.49 GB") if human_readable=TRUE,
#'   or numeric bytes if human_readable=FALSE
#'
#' @examples
#' \dontrun{
#' # Check size of a dataset
#' get_dataset_size('my_data')
#' # Returns: "2.49 GB"
#'
#' # Get raw bytes
#' get_dataset_size('my_data', human_readable = FALSE)
#' }
#'
#' @export
get_dataset_size <- function(dataset_name, human_readable = TRUE) {
  
  if (!exists(dataset_name, envir = globalenv())) {
    cat(sprintf("[MEMORY]  Dataset '%s' not found\n", dataset_name))
    return(invisible(NULL))
  }
  
  size_bytes <- object.size(get(dataset_name, envir = globalenv()))
  
  if (human_readable) {
    # Convert to MB/GB
    if (size_bytes < 1024 * 1024) {
      # Less than 1 MB, show in KB
      size_str <- sprintf("%.1f KB", size_bytes / 1024)
    } else if (size_bytes < 1024 * 1024 * 1024) {
      # Less than 1 GB, show in MB
      size_str <- sprintf("%.1f MB", size_bytes / (1024 * 1024))
    } else {
      # 1 GB or more, show in GB
      size_str <- sprintf("%.2f GB", size_bytes / (1024 * 1024 * 1024))
    }
    return(size_str)
  }
  
  return(as.numeric(size_bytes))
}
