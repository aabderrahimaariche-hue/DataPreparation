#########################################################
# DATA UTILITIES - Support for data.frame and data.table
# Module: 00_data_utilities.R
# Purpose: Helper functions for format detection and conversion
#########################################################

#' Check if Object is data.table
#'
#' @param data Input object to check
#'
#' @return Logical: TRUE if object inherits from data.table, FALSE otherwise
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' df <- data.frame(x = 1:5)
#' dt <- data.table::data.table(x = 1:5)
#' is_datatable(df)  # FALSE
#' is_datatable(dt)  # TRUE
#' }
is_datatable <- function(data) {
  inherits(data, "data.table")
}

#' Convert data.table to data.frame if needed
#'
#' Converts data.table to data.frame for processing,
#' leaves data.frame unchanged. Used internally to ensure
#' compatibility with dplyr-based operations.
#'
#' @param data Input data (data.frame or data.table)
#'
#' @return data.frame (if input is data.table) or original data.frame
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' dt <- data.table::data.table(x = 1:5)
#' df <- ensure_dataframe(dt)
#' class(df)  # "data.frame"
#' }
ensure_dataframe <- function(data) {
  if (is_datatable(data)) {
    # Suppress data.table warning about converting to data.frame
    return(as.data.frame(data, stringsAsFactors = FALSE))
  }
  return(data)
}

#' Restore Original Class to Result
#'
#' If input was data.table, converts result back to data.table.
#' If input was data.frame, leaves result as data.frame.
#' Used to preserve user's preferred format throughout workflow.
#'
#' @param result Result data frame
#' @param original Original input data
#'
#' @return Result with same class as original input
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' original_dt <- data.table::data.table(x = 1:5)
#' result_df <- data.frame(x = 1:5, y = 2:6)
#' restored <- restore_class(result_df, original_dt)
#' class(restored)  # "data.table"
#' }
restore_class <- function(result, original) {
  if (is_datatable(original)) {
    # Only convert if data.table is available
    if (requireNamespace("data.table", quietly = TRUE)) {
      return(data.table::as.data.table(result))
    }
  }
  return(result)
}

#' Convert Between data.frame and data.table Formats
#'
#' Converts data between data.frame and data.table formats.
#' Useful for users who want to work with a specific format
#' regardless of function input/output format.
#'
#' @param data Input data (data.frame or data.table)
#' @param format Target format: "data.frame" (default) or "data.table"
#'
#' @return Data in requested format
#'
#' @export
#' @examples
#' \dontrun{
#' library(DataPreparation)
#'
#' # Create sample data
#' df <- data.frame(x = 1:5, y = letters[1:5])
#'
#' # Convert to data.table
#' dt <- convert_data_format(df, "data.table")
#' class(dt)  # "data.table" "data.frame"
#'
#' # Convert back to data.frame
#' df2 <- convert_data_format(dt, "data.frame")
#' class(df2)  # "data.frame"
#' }
convert_data_format <- function(data, format = c("data.frame", "data.table")) {
  format <- match.arg(format)

  if (format == "data.table") {
    # Check if data.table is available
    if (!requireNamespace("data.table", quietly = TRUE)) {
      stop("data.table package required. Install with: install.packages('data.table')")
    }
    return(data.table::as.data.table(data))
  } else {
    # Convert to data.frame
    return(as.data.frame(data, stringsAsFactors = FALSE))
  }
}

#' Get Data Format Info
#'
#' Returns information about the input data format.
#' Useful for debugging and understanding data structure.
#'
#' @param data Input data
#'
#' @return List with format information:
#'   - format: "data.table" or "data.frame"
#'   - rows: number of rows
#'   - cols: number of columns
#'   - col_names: column names
#'   - col_types: column types
#'
#' @export
#' @examples
#' \dontrun{
#' library(DataPreparation)
#'
#' df <- data.frame(x = 1:5, y = c("a", "b", "c", "d", "e"))
#' info <- get_data_format_info(df)
#' print(info)
#' # $format: "data.frame"
#' # $rows: 5
#' # $cols: 2
#' # $col_names: c("x", "y")
#' # $col_types: c("integer", "character")
#' }
get_data_format_info <- function(data) {
  list(
    format = if (is_datatable(data)) "data.table" else "data.frame",
    rows = nrow(data),
    cols = ncol(data),
    col_names = colnames(data),
    col_types = sapply(data, function(x) class(x)[1], USE.NAMES = FALSE)
  )
}

#' Check data.table Availability
#'
#' Checks if data.table package is installed and available.
#'
#' @return Logical: TRUE if data.table available, FALSE otherwise
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' has_datatable()  # TRUE or FALSE
#' }
has_datatable <- function() {
  requireNamespace("data.table", quietly = TRUE)
}

#' Validate Data Input
#'
#' Validates that input is a proper data.frame or data.table.
#'
#' @param data Input to validate
#' @param name Name of parameter (for error messages)
#'
#' @return NULL (invisibly), raises error if invalid
#'
#' @keywords internal
validate_data_input <- function(data, name = "data") {
  if (!is.data.frame(data) && !is_datatable(data)) {
    stop(paste0(
      name, " must be a data.frame or data.table, ",
      "got ", class(data)[1]
    ))
  }
  invisible(NULL)
}
