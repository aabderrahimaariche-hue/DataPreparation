#########################################################
# TIMESTAMP & STRING FEATURES
# Module: 03_timestamp_features.R
# Purpose: Functions for timestamp and string extraction
#########################################################

#' Extract Timestamp Features
#'
#' @param data A data frame (optional if dataset_name provided)
#' @param timestamp_col Timestamp column name
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Data frame with extracted timestamp features (year, month, day, wday)
#'
#' @export
extract_timestamp_features <- function(data = NULL, timestamp_col = "timestamp", dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  
  if(!(timestamp_col %in% colnames(data))) stop(paste("Column not found:", timestamp_col))
  data %>%
    mutate(
      ts = as.POSIXct(.data[[timestamp_col]], tz = "UTC"),
      ts_year = as.numeric(format(ts, "%Y")),
      ts_month = as.numeric(format(ts, "%m")),
      ts_day = as.numeric(format(ts, "%d")),
      ts_wday = as.numeric(format(ts, "%u"))
    ) %>% select(-ts)
}

#' Extract 4-Digit Year from String Column
#'
#' @param data A data frame (optional if dataset_name provided)
#' @param string_col String column name to extract year from
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Data frame with extracted year column
#'
#' @export
extract_year_from_string <- function(data = NULL, string_col = "string", dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  
  if(!(string_col %in% colnames(data))) stop(paste("Column not found:", string_col))
  data %>%
    mutate(year = str_extract(.data[[string_col]], "\\d{4}")) %>%
    mutate(year = as.numeric(year))
}
