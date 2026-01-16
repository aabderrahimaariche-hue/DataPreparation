#########################################################
# GROUP INTELLIGENCE FUNCTIONS
# Module: 10_group_intelligence.R
# Purpose: Universal functions for computing statistics
#          by any identifier (userId, itemId, etc.)
#          Generalized architecture: ANY identifier + ANY value
# Author: AARICHE ABDERRAHIM
# Philosophy: Intelligence (Identifiers) + Valeurization (Values)
#########################################################

#' Compute Group Statistics for Any Identifier
#'
#' Calculate aggregated statistics (mean, std, min, max, median, count, variance)
#' for any identifier grouped by any numeric valeurization column.
#' Works with ANY pair: userId/rating, customerId/price, sensorId/measurement, etc.
#'
#' @param data A data frame (optional if dataset_name provided)
#' @param identifier_col Column name containing identifiers (character)
#' @param value_col Column name containing numeric values to aggregate (character)
#' @param include_stats Which statistics to include. Default: all
#'   c("mean", "std", "min", "max", "median", "count", "variance")
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Data frame with columns: identifier_col, *_mean, *_std, *_min, *_max, *_median, *_count, *_variance
#'
#' @examples
#' \dontrun{
#' # MovieLens: user rating statistics
#' user_stats <- compute_identifier_statistics(data, "userId", "rating")
#'
#' # E-commerce: customer spending statistics
#' customer_stats <- compute_identifier_statistics(data, "customerId", "purchase_amount")
#'
#' # Sensors: measurement statistics by sensor
#' sensor_stats <- compute_identifier_statistics(data, "sensorId", "temperature")
#' }
#'
#' @export
compute_identifier_statistics <- function(data = NULL, identifier_col, value_col, 
                                         include_stats = c("mean", "std", "min", "max", "median", "count", "variance"), dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  if(!(identifier_col %in% colnames(data))) stop(paste("Identifier column not found:", identifier_col))
  if(!(value_col %in% colnames(data))) stop(paste("Value column not found:", value_col))
  
  result <- data %>%
    group_by(!!sym(identifier_col)) %>%
    summarise(
      !!paste0(value_col, "_mean") := mean(.data[[value_col]], na.rm = TRUE),
      !!paste0(value_col, "_std") := sd(.data[[value_col]], na.rm = TRUE),
      !!paste0(value_col, "_min") := min(.data[[value_col]], na.rm = TRUE),
      !!paste0(value_col, "_max") := max(.data[[value_col]], na.rm = TRUE),
      !!paste0(value_col, "_median") := median(.data[[value_col]], na.rm = TRUE),
      !!paste0(value_col, "_count") := n(),
      !!paste0(value_col, "_variance") := var(.data[[value_col]], na.rm = TRUE),
      .groups = "drop"
    )
  
  return(result)
}

#' Compute Deviation/Bias Detection for Identifiers
#'
#' Calculate how each identifier deviates from a reference value (usually global mean or group mean).
#' Enables detection of user bias, item bias, etc.
#'
#' @param data A data frame with at least: identifier_col, value_col, reference_col (optional if dataset_name provided)
#' @param identifier_col Identifier column name (e.g., "userId")
#' @param value_col Value column name (e.g., "rating")
#' @param reference_col Reference column name for comparison (e.g., "movie_avg_rating")
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Data frame with original columns + deviation metrics:
#'   *_deviation (absolute difference)
#'   *_deviation_pct (percentage difference)
#'
#' @examples
#' \dontrun{
#' # User bias from movie mean
#' user_bias <- compute_identifier_deviation(data, "userId", "rating", "movie_avg_rating")
#'
#' # Customer spending deviation from merchant average
#' customer_deviation <- compute_identifier_deviation(data, "customerId", "amount", "merchant_avg_amount")
#' }
#'
#' @export
compute_identifier_deviation <- function(data = NULL, identifier_col, value_col, reference_col, dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  if(!(identifier_col %in% colnames(data))) stop(paste("Identifier column not found:", identifier_col))
  if(!(value_col %in% colnames(data))) stop(paste("Value column not found:", value_col))
  if(!(reference_col %in% colnames(data))) stop(paste("Reference column not found:", reference_col))
  
  data %>%
    mutate(
      !!paste0(value_col, "_deviation") := .data[[value_col]] - .data[[reference_col]],
      !!paste0(value_col, "_deviation_pct") := (.data[[value_col]] - .data[[reference_col]]) / abs(.data[[reference_col]]) * 100
    )
}

#' Classify Identifier Patterns from Statistics
#'
#' Convert numeric statistics into categorical patterns.
#' Examples: "lenient" vs "strict" raters, "high_variance" vs "consistent" users
#'
#' @param stats_data Data frame output from compute_identifier_statistics()
#' @param value_col Base name of value column (e.g., "rating")
#' @param pattern_type Type of pattern to classify:
#'   - "valeurization_level": classify by mean value (high/medium/low)
#'   - "consistency": classify by standard deviation (consistent/medium/variable)
#'
#' @return Data frame with original statistics + pattern column
#'
#' @examples
#' \dontrun{
#' user_stats <- compute_identifier_statistics(data, "userId", "rating")
#' user_patterns <- classify_identifier_patterns(user_stats, "rating", "valeurization_level")
#' }
#'
#' @export
classify_identifier_patterns <- function(stats_data, value_col, pattern_type = "valeurization_level") {
  
  mean_col <- paste0(value_col, "_mean")
  std_col <- paste0(value_col, "_std")
  pattern_col <- paste0(value_col, "_pattern")
  
  if(!(mean_col %in% colnames(stats_data))) stop(paste("Mean column not found:", mean_col))
  
  if(pattern_type == "valeurization_level") {
    # Classify based on mean value
    q75 <- quantile(stats_data[[mean_col]], 0.75, na.rm = TRUE)
    q25 <- quantile(stats_data[[mean_col]], 0.25, na.rm = TRUE)
    
    stats_data %>%
      mutate(
        !!pattern_col := case_when(
          .data[[mean_col]] >= q75 ~ "high",
          .data[[mean_col]] >= q25 ~ "medium",
          TRUE ~ "low"
        )
      )
  } else if(pattern_type == "consistency") {
    # Classify based on standard deviation
    if(!(std_col %in% colnames(stats_data))) stop(paste("Std column not found:", std_col))
    
    q75_std <- quantile(stats_data[[std_col]], 0.75, na.rm = TRUE)
    q25_std <- quantile(stats_data[[std_col]], 0.25, na.rm = TRUE)
    
    stats_data %>%
      mutate(
        !!pattern_col := case_when(
          .data[[std_col]] <= q25_std ~ "consistent",
          .data[[std_col]] <= q75_std ~ "medium_variance",
          TRUE ~ "high_variance"
        )
      )
  } else {
    stop("pattern_type must be 'valeurization_level' or 'consistency'")
  }
}

#########################################################
# END OF GROUP INTELLIGENCE MODULE
#########################################################
