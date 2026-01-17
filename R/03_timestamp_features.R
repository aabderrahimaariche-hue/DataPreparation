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

#' Extract ALL 4-Digit Years from String with Positions
#'
#' Extracts all 4-digit years found in a string column, along with their
#' positions (starting index). Unlike extract_year_from_string() which gets
#' only the first year, this function finds ALL years and returns position
#' information for each.
#'
#' @param data A data frame (optional if dataset_name provided)
#' @param string_col String column name to extract years from
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @details
#' The function iteratively:
#' 1. Extracts the first 4-digit year found
#' 2. Records the year value and its position (starting index)
#' 3. Replaces the extracted year with "EXTRACTEDYEAR" placeholder
#' 4. Repeats until no more years are found
#'
#' Returns a list column where each element contains a data frame with:
#' - year: The extracted 4-digit year as numeric
#' - position: The starting index position in the original string (1-based)
#'
#' @return Data frame with original columns + new "years_list" column containing
#'         list of extracted years with positions for each row
#'
#' @examples
#' \dontrun{
#' # Example: phrases with multiple years
#' data <- data.frame(
#'   id = 1:3,
#'   phrase = c(
#'     "i was born in 2001",
#'     "between 1995 and 2005",
#'     "from 2010 to 2020 then 2022"
#'   )
#' )
#'
#' result <- extract_years_from_string(data, "phrase")
#' result$years_list
#' # [[1]] - Row 1 (id=1): "i was born in 2001"
#' #   year position
#' #   2001       17
#' #
#' # [[2]] - Row 2 (id=2): "between 1995 and 2005"
#' #   year position
#' #   1995        9
#' #   2005       18
#' #
#' # [[3]] - Row 3 (id=3): "from 2010 to 2020 then 2022"
#' #   year position
#' #   2010        6
#' #   2020       15
#' #   2022       25
#' }
#'
#' @export
extract_years_from_string <- function(data = NULL, string_col = "string", dataset_name = NULL) {
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
  
  # Function to extract all years from a single string
  extract_all_years <- function(text) {
    if (is.na(text)) {
      return(data.frame(year = numeric(), position = numeric()))
    }
    
    years_found <- data.frame(year = numeric(), position = numeric())
    remaining_text <- text
    char_position <- 1  # Track position in original string
    
    # Keep extracting years until none are found
    while (TRUE) {
      # Find first 4-digit year
      year_match <- stringr::str_locate(remaining_text, "\\d{4}")
      
      # If no year found, break
      if (is.na(year_match[1])) {
        break
      }
      
      # Extract the year value
      year_value <- as.numeric(stringr::str_extract(remaining_text, "\\d{4}"))
      
      # Calculate position in original string (position before the year)
      position_in_remaining <- year_match[1]
      actual_position <- char_position + position_in_remaining - 1
      
      # Append to results
      years_found <- rbind(years_found, data.frame(
        year = year_value,
        position = actual_position
      ))
      
      # Move past this year in remaining text
      text_after_year <- year_match[2] + 1  # Position right after the year (4 digits)
      
      # Update char_position and remaining_text for next iteration
      if (text_after_year <= nchar(remaining_text)) {
        char_position <- char_position + text_after_year
        remaining_text <- substring(remaining_text, text_after_year + 1)
      } else {
        break
      }
    }
    
    return(years_found)
  }
  
  # Apply extraction to each row and store as list column
  data$years_list <- lapply(data[[string_col]], extract_all_years)
  data
}

