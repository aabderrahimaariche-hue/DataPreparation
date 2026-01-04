#########################################################
# TIMESTAMP & STRING FEATURES
# Module: 03_timestamp_features.R
# Purpose: Functions for timestamp and string extraction
#########################################################

#' Extract Timestamp Features
#'
#' @param data A data frame
#' @param timestamp_col Timestamp column name
#'
#' @return Data frame with extracted timestamp features (year, month, day, wday)
#'
#' @export
extract_timestamp_features <- function(data, timestamp_col = "timestamp") {
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
#' @param data A data frame
#' @param title_col String column name to extract year from
#'
#' @return Data frame with extracted year column
#'
#' @export
extract_year_from_title <- function(data, title_col = "title") {
  if(!(title_col %in% colnames(data))) stop(paste("Column not found:", title_col))
  data %>%
    mutate(year = str_extract(.data[[title_col]], "\\d{4}")) %>%
    mutate(year = as.numeric(year))
}
