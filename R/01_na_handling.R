#########################################################
# NA HANDLING FUNCTIONS
# Module: 01_na_handling.R
# Purpose: Functions for handling missing values
#########################################################

#' Remove Rows with NA in Specified Columns
#'
#' @param data A data frame
#' @param columns_to_check Vector of column names to check for NA
#'
#' @return Data frame with rows containing NA removed
#'
#' @examples
#' \dontrun{
#' remove_na_columns(mtcars, c("mpg", "cyl"))
#' }
#'
#' @export
remove_na_columns <- function(data, columns_to_check) {
  missing_cols <- setdiff(columns_to_check, colnames(data))
  if(length(missing_cols) > 0) {
    stop(paste("Columns not found in dataset:", paste(missing_cols, collapse = ", ")))
  }
  data %>% filter(!if_any(all_of(columns_to_check), is.na))
}

#' Impute NA in Numeric Column with Median
#'
#' @param data A data frame
#' @param col Column name (character)
#'
#' @return Data frame with NA values imputed with median
#'
#' @examples
#' \dontrun{
#' impute_na_numeric(mtcars, "mpg")
#' }
#'
#' @export
impute_na_numeric <- function(data, col) {
  if(!(col %in% colnames(data))) stop(paste("Column not found:", col))
  median_val <- median(data[[col]], na.rm = TRUE)
  data %>% mutate(!!sym(col) := ifelse(is.na(.data[[col]]), median_val, .data[[col]]))
}

#' Flag NA Values in Column
#'
#' @param data A data frame
#' @param col Column name (character)
#'
#' @return Data frame with new NA flag column
#'
#' @examples
#' \dontrun{
#' flag_na_column(mtcars, "mpg")
#' }
#'
#' @export
flag_na_column <- function(data, col) {
  if(!(col %in% colnames(data))) stop(paste("Column not found:", col))
  new_col <- paste0(col, "_NA_flag")
  data %>% mutate(!!sym(new_col) := ifelse(is.na(.data[[col]]), 1, 0))
}

#' Summarize NA Impact at Row Level
#'
#' @param data A data frame
#'
#' @return Tibble with NA summary statistics
#'
#' @examples
#' \dontrun{
#' summarize_na_rows(mtcars)
#' }
#'
#' @export
summarize_na_rows <- function(data) {
  tibble(
    total_rows = nrow(data),
    rows_with_na = sum(!complete.cases(data)),
    rows_complete = sum(complete.cases(data)),
    percent_rows_with_na = round(
      sum(!complete.cases(data)) / nrow(data) * 100, 2
    )
  )
}
