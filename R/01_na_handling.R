#########################################################
# NA HANDLING FUNCTIONS
# Module: 01_na_handling.R
# Purpose: Functions for handling missing values
#########################################################

#' Remove Rows with NA in Specified Columns
#'
#' @param data A data frame (optional if dataset_name provided)
#' @param columns_to_check Vector of column names to check for NA
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Data frame with rows containing NA removed
#'
#' @details
#' Supports both traditional and focus mode usage:
#' \itemize{
#'   \item Traditional: \code{remove_na_columns(data = df, columns_to_check = ...)}
#'   \item Focus mode: Set \code{focus_dataset("name")} then \code{remove_na_columns(columns_to_check = ...)}
#' }
#'
#' @examples
#' \dontrun{
#' remove_na_columns(mtcars, c("mpg", "cyl"))
#' }
#'
#' @export
remove_na_columns <- function(data = NULL, columns_to_check, dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  
  missing_cols <- setdiff(columns_to_check, colnames(data))
  if(length(missing_cols) > 0) {
    stop(paste("Columns not found in dataset:", paste(missing_cols, collapse = ", ")))
  }
  data %>% filter(!if_any(all_of(columns_to_check), is.na))
}

#' Impute NA in Numeric Column with Median
#'
#' @param data A data frame (optional if dataset_name provided)
#' @param col Column name (character)
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Data frame with NA values imputed with median
#'
#' @export
impute_na_numeric <- function(data = NULL, col, dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  
  if(!(col %in% colnames(data))) stop(paste("Column not found:", col))
  median_val <- median(data[[col]], na.rm = TRUE)
  data %>% mutate(!!sym(col) := ifelse(is.na(.data[[col]]), median_val, .data[[col]]))
}

#' Flag NA Values in Column
#'
#' @param data A data frame (optional if dataset_name provided)
#' @param col Column name (character)
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Data frame with new NA flag column
#'
#' @export
flag_na_column <- function(data = NULL, col, dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  
  if(!(col %in% colnames(data))) stop(paste("Column not found:", col))
  new_col <- paste0(col, "_NA_flag")
  data %>% mutate(!!sym(new_col) := ifelse(is.na(.data[[col]]), 1, 0))
}

#' Summarize NA Impact at Row Level
#'
#' @param data A data frame (optional if dataset_name provided)
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Tibble with NA summary statistics
#'
#' @export
summarize_na_rows <- function(data = NULL, dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  
  tibble(
    total_rows = nrow(data),
    rows_with_na = sum(!complete.cases(data)),
    rows_complete = sum(complete.cases(data)),
    percent_rows_with_na = round(
      sum(!complete.cases(data)) / nrow(data) * 100, 2
    )
  )
}
