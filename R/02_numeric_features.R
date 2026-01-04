#########################################################
# NUMERIC FEATURES FUNCTIONS
# Module: 02_numeric_features.R
# Purpose: Functions for numeric feature engineering
#########################################################

#' Scale Numeric Values to 0-1 Range
#'
#' @param data A data frame
#' @param col Column name (character)
#' @param min_val Minimum value (default: column min)
#' @param max_val Maximum value (default: column max)
#'
#' @return Data frame with scaled column
#'
#' @export
scale_betweenRange <- function(data, col, min_val = NULL, max_val = NULL) {
  if(!(col %in% colnames(data))) stop(paste("Column not found:", col))
  if(is.null(min_val)) min_val <- min(data[[col]], na.rm = TRUE)
  if(is.null(max_val)) max_val <- max(data[[col]], na.rm = TRUE)
  data %>% mutate(!!sym(col) := (.data[[col]] - min_val) / (max_val - min_val))
}

#' Standardize Numeric Column (Z-Score)
#'
#' @param data A data frame
#' @param col Column name (character)
#'
#' @return Data frame with standardized column (mean=0, sd=1)
#'
#' @export
scale_unbounded <- function(data, col) {
  if(!(col %in% colnames(data))) stop(paste("Column not found:", col))
  mean_val <- mean(data[[col]], na.rm = TRUE)
  sd_val <- sd(data[[col]], na.rm = TRUE)
  data %>% mutate(!!sym(col) := (.data[[col]] - mean_val) / sd_val)
}

#' Detect Half vs Full Ratings
#'
#' @param data A data frame
#' @param col Column name (character)
#'
#' @return Data frame with half/full flag
#'
#' @export
detect_extract_half_full <- function(data, col) {
  if(!(col %in% colnames(data))) stop(paste("Column not found:", col))
  new_col <- paste0(col, "_halffull")
  data %>% mutate(!!sym(new_col) := ifelse(.data[[col]] %% 1 == 0.5, 0.5, 1))
}

#' Apply Logarithmic Transformation
#'
#' @param data A data frame
#' @param col Column name (character)
#' @param offset Offset to add before log transformation
#'
#' @return Data frame with log-transformed column
#'
#' @export
transform_log <- function(data, col, offset = 1) {
  data %>%
    mutate(!!sym(paste0(col, "_log")) := log(!!sym(col) + offset))
}

#' Apply Square Root Transformation
#'
#' @param data A data frame
#' @param col Column name (character)
#'
#' @return Data frame with square root transformed column
#'
#' @export
transform_sqrt <- function(data, col) {
  data %>%
    mutate(!!sym(paste0(col, "_sqrt")) := sqrt(pmax(0, !!sym(col))))
}

#' Apply Exponential Transformation
#'
#' @param data A data frame
#' @param col Column name (character)
#' @param scale Scale factor for exponential
#'
#' @return Data frame with exponentially transformed column
#'
#' @export
transform_exp <- function(data, col, scale = 1) {
  data %>%
    mutate(!!sym(paste0(col, "_exp")) := exp(!!sym(col) * scale))
}

#' Create Polynomial Features
#'
#' @param data A data frame
#' @param col Column name (character)
#' @param degree Degree of polynomial (2 or 3)
#'
#' @return Data frame with polynomial feature columns
#'
#' @export
create_polynomial_features <- function(data, col, degree = 2) {
  result <- data
  
  if(degree >= 2) {
    result <- result %>%
      mutate(!!sym(paste0(col, "_squared")) := (!!sym(col))^2)
  }
  
  if(degree >= 3) {
    result <- result %>%
      mutate(!!sym(paste0(col, "_cubed")) := (!!sym(col))^3)
  }
  
  return(result)
}

#' Create Interaction Terms
#'
#' @param data A data frame
#' @param col1 First column name
#' @param col2 Second column name
#'
#' @return Data frame with interaction term
#'
#' @export
create_interaction_features <- function(data, col1, col2) {
  data %>%
    mutate(!!sym(paste0(col1, "_x_", col2)) := !!sym(col1) * !!sym(col2))
}

#' Create Ratio Features
#'
#' @param data A data frame
#' @param col1 Numerator column name
#' @param col2 Denominator column name
#' @param safe Handle division by zero (default: TRUE)
#'
#' @return Data frame with ratio column
#'
#' @export
create_ratio_features <- function(data, col1, col2, safe = TRUE) {
  if(safe) {
    data %>%
      mutate(!!sym(paste0(col1, "_div_", col2)) := 
             ifelse(!!sym(col2) == 0, 0, !!sym(col1) / !!sym(col2)))
  } else {
    data %>%
      mutate(!!sym(paste0(col1, "_div_", col2)) := !!sym(col1) / !!sym(col2))
  }
}

#' Bin Numeric Column (Quantile-Based)
#'
#' @param data A data frame
#' @param col Column name (character)
#' @param n_bins Number of bins
#'
#' @return Data frame with binned column
#'
#' @export
binning_quantile <- function(data, col, n_bins = 5) {
  data %>%
    mutate(!!sym(paste0(col, "_bin_q", n_bins)) := 
           as.integer(ntile(!!sym(col), n_bins)))
}

#' Bin Numeric Column (Equal-Width)
#'
#' @param data A data frame
#' @param col Column name (character)
#' @param n_bins Number of bins
#'
#' @return Data frame with binned column
#'
#' @export
binning_width <- function(data, col, n_bins = 5) {
  var_min <- min(data[[col]], na.rm = TRUE)
  var_max <- max(data[[col]], na.rm = TRUE)
  bin_width <- (var_max - var_min) / n_bins
  
  data %>%
    mutate(!!sym(paste0(col, "_bin_w", n_bins)) := 
           cut(!!sym(col), breaks = seq(var_min, var_max + bin_width, bin_width),
               labels = 1:n_bins, include.lowest = TRUE))
}

#' Flag Outliers (IQR Method)
#'
#' @param data A data frame
#' @param col Column name (character)
#' @param multiplier IQR multiplier
#'
#' @return Data frame with outlier flag
#'
#' @export
flag_outliers_iqr <- function(data, col, multiplier = 1.5) {
  Q1 <- quantile(data[[col]], 0.25, na.rm = TRUE)
  Q3 <- quantile(data[[col]], 0.75, na.rm = TRUE)
  IQR_val <- Q3 - Q1
  
  lower_bound <- Q1 - multiplier * IQR_val
  upper_bound <- Q3 + multiplier * IQR_val
  
  data %>%
    mutate(!!sym(paste0(col, "_outlier_iqr")) := 
           as.integer(!!sym(col) < lower_bound | !!sym(col) > upper_bound))
}

#' Flag Outliers (Z-Score Method)
#'
#' @param data A data frame
#' @param col Column name (character)
#' @param threshold Z-score threshold
#'
#' @return Data frame with outlier flag
#'
#' @export
flag_outliers_zscore <- function(data, col, threshold = 3) {
  col_mean <- mean(data[[col]], na.rm = TRUE)
  col_sd <- sd(data[[col]], na.rm = TRUE)
  
  data %>%
    mutate(!!sym(paste0(col, "_outlier_z", threshold)) := 
           as.integer(abs((!!sym(col) - col_mean) / col_sd) > threshold))
}

#' Normalize Numeric Column
#'
#' @param data A data frame
#' @param col Column name (character)
#' @param method Normalization method ("minmax", "zscore", "robust", "log")
#'
#' @return Data frame with normalized column
#'
#' @export
normalize_numeric <- function(data, col, method = "minmax") {
  col_data <- data[[col]]
  
  if(method == "minmax") {
    col_min <- min(col_data, na.rm = TRUE)
    col_max <- max(col_data, na.rm = TRUE)
    normalized <- (col_data - col_min) / (col_max - col_min)
  } else if(method == "zscore") {
    col_mean <- mean(col_data, na.rm = TRUE)
    col_sd <- sd(col_data, na.rm = TRUE)
    normalized <- (col_data - col_mean) / col_sd
  } else if(method == "robust") {
    col_median <- median(col_data, na.rm = TRUE)
    Q1 <- quantile(col_data, 0.25, na.rm = TRUE)
    Q3 <- quantile(col_data, 0.75, na.rm = TRUE)
    IQR_val <- Q3 - Q1
    normalized <- (col_data - col_median) / IQR_val
  } else if(method == "log") {
    normalized <- log(pmax(col_data, 0.001))
  }
  
  data %>%
    mutate(!!sym(paste0(col, "_norm_", method)) := normalized)
}

#' Compute Rolling Statistics
#'
#' @param data A data frame
#' @param group_col Grouping column name
#' @param numeric_col Numeric column name
#' @param window Window size
#' @param statistic Type of statistic ("mean", "sum", "sd")
#'
#' @return Data frame with rolling statistics
#'
#' @export
compute_rolling_statistics <- function(data, group_col, numeric_col, 
                                      window = 5, statistic = "mean") {
  
  result <- data %>%
    arrange(!!sym(group_col)) %>%
    group_by(!!sym(group_col)) %>%
    mutate(
      !!sym(paste0(numeric_col, "_rolling_", statistic, "_", window)) := 
        case_when(
          statistic == "mean" ~ zoo::rollmean(!!sym(numeric_col), 
                                              k = window, fill = NA, align = "right"),
          statistic == "sum" ~ zoo::rollsum(!!sym(numeric_col), 
                                            k = window, fill = NA, align = "right"),
          statistic == "sd" ~ zoo::rollapply(!!sym(numeric_col), 
                                             width = window, FUN = sd, fill = NA, align = "right")
        )
    ) %>%
    ungroup()
  
  return(result)
}

#' Compute Group-Wise Statistics
#'
#' @param data A data frame
#' @param group_col Grouping column name
#' @param numeric_col Numeric column name
#'
#' @return Data frame with group statistics joined
#'
#' @export
compute_group_statistics <- function(data, group_col, numeric_col) {
  
  group_stats <- data %>%
    group_by(!!sym(group_col)) %>%
    summarise(
      !!sym(paste0(group_col, "_", numeric_col, "_mean")) := mean(!!sym(numeric_col), na.rm = TRUE),
      !!sym(paste0(group_col, "_", numeric_col, "_median")) := median(!!sym(numeric_col), na.rm = TRUE),
      !!sym(paste0(group_col, "_", numeric_col, "_sd")) := sd(!!sym(numeric_col), na.rm = TRUE),
      !!sym(paste0(group_col, "_", numeric_col, "_min")) := min(!!sym(numeric_col), na.rm = TRUE),
      !!sym(paste0(group_col, "_", numeric_col, "_max")) := max(!!sym(numeric_col), na.rm = TRUE),
      !!sym(paste0(group_col, "_", numeric_col, "_count")) := n(),
      .groups = "drop"
    )
  
  result <- data %>%
    left_join(group_stats, by = group_col)
  
  return(result)
}

#' Standardize Numeric Column (Zero Mean, Unit Variance)
#'
#' @param data A data frame
#' @param col Column name (character)
#'
#' @return Data frame with standardized column
#'
#' @export
standardize_numeric <- function(data, col) {
  col_mean <- mean(data[[col]], na.rm = TRUE)
  col_sd <- sd(data[[col]], na.rm = TRUE)
  
  if(col_sd == 0) {
    warning(paste("Column", col, "has zero standard deviation"))
  }
  
  data %>%
    mutate(!!sym(paste0(col, "_standardized")) := 
           (!!sym(col) - col_mean) / col_sd)
}

#' Create Quantile Features
#'
#' @param data A data frame
#' @param col Column name (character)
#'
#' @return Data frame with quantile column
#'
#' @export
create_quantile_features <- function(data, col) {
  data %>%
    mutate(!!sym(paste0(col, "_quantile")) := 
           ecdf(!!sym(col))(!!sym(col)))
}

#' Create Rank Features
#'
#' @param data A data frame
#' @param col Column name (character)
#' @param group_col Optional grouping column
#'
#' @return Data frame with rank column
#'
#' @export
create_rank_features <- function(data, col, group_col = NULL) {
  if(is.null(group_col)) {
    data %>%
      mutate(!!sym(paste0(col, "_rank")) := rank(!!sym(col), na.last = "keep"))
  } else {
    data %>%
      group_by(!!sym(group_col)) %>%
      mutate(!!sym(paste0(col, "_rank_by_", group_col)) := 
             rank(!!sym(col), na.last = "keep")) %>%
      ungroup()
  }
}

#' Create Percentage Change Features
#'
#' @param data A data frame
#' @param col Column name (character)
#' @param lag Lag period
#'
#' @return Data frame with percentage change column
#'
#' @export
create_percentage_change <- function(data, col, lag = 1) {
  data %>%
    mutate(!!sym(paste0(col, "_pct_change_lag", lag)) := 
           ((!!sym(col) - lag(!!sym(col), lag)) / lag(!!sym(col), lag)) * 100)
}

#' Create Difference Features
#'
#' @param data A data frame
#' @param col Column name (character)
#' @param lag Lag period
#'
#' @return Data frame with difference column
#'
#' @export
create_difference_features <- function(data, col, lag = 1) {
  data %>%
    mutate(!!sym(paste0(col, "_diff_lag", lag)) := 
           !!sym(col) - lag(!!sym(col), lag))
}

#' Generate Numeric Feature Variants
#'
#' @param data A data frame
#' @param numeric_cols Vector of numeric column names
#'
#' @return List of candidate datasets with variants
#'
#' @export
generate_numeric_variants <- function(data, numeric_cols) {
  candidates <- list()
  for(col in numeric_cols) {
    if(!(col %in% colnames(data))) stop(paste("Column not found:", col))
    
    candidates[[col]] <- data
    candidates[[paste0(col, "_scaled")]] <- scale_betweenRange(data, col)
    candidates[[paste0(col, "_std")]] <- scale_unbounded(data, col)
    candidates[[paste0(col, "_halffull")]] <- detect_extract_half_full(data, col)
  }
  return(candidates)
}

#' Generate Advanced Numeric Variants
#'
#' @param data A data frame
#' @param numeric_cols Vector of numeric column names
#' @param include_poly Include polynomial features
#' @param include_transforms Include transformations
#' @param include_bins Include binning features
#' @param include_outliers Include outlier flags
#'
#' @return List of advanced variant datasets
#'
#' @export
generate_numeric_variants_advanced <- function(data, numeric_cols, 
                               include_poly = TRUE, 
                               include_transforms = TRUE,
                               include_bins = TRUE,
                               include_outliers = TRUE) {
  
  candidates <- list()
  
  for(col in numeric_cols) {
    
    candidates[[paste0(col, "_original")]] <- data %>% select(all_of(col))
    candidates[[paste0(col, "_scaled_0_1")]] <- scale_betweenRange(data, col = col) %>%
      select(all_of(col))
    candidates[[paste0(col, "_standardized")]] <- scale_unbounded(data, col = col) %>%
      select(all_of(col))
    
    if(include_poly) {
      poly_data <- create_polynomial_features(data, col, degree = 3) %>%
        select(contains(col) & (contains("squared") | contains("cubed")))
      
      if(ncol(poly_data) > 0) {
        candidates[[paste0(col, "_polynomial")]] <- poly_data
      }
    }
    
    if(include_transforms) {
      trans_data <- data %>%
        transform_log(col) %>%
        transform_sqrt(col) %>%
        select(contains(col) & (contains("log") | contains("sqrt")))
      
      if(ncol(trans_data) > 0) {
        candidates[[paste0(col, "_transforms")]] <- trans_data
      }
    }
    
    if(include_bins) {
      bin_data <- data %>%
        binning_quantile(col, n_bins = 5) %>%
        select(contains("_bin_"))
      
      if(ncol(bin_data) > 0) {
        candidates[[paste0(col, "_binned")]] <- bin_data
      }
    }
    
    if(include_outliers) {
      out_data <- data %>%
        flag_outliers_iqr(col) %>%
        flag_outliers_zscore(col) %>%
        select(contains("_outlier_"))
      
      if(ncol(out_data) > 0) {
        candidates[[paste0(col, "_outliers")]] <- out_data
      }
    }
    
    candidates[[paste0(col, "_quantile")]] <- create_quantile_features(data, col) %>%
      select(contains("_quantile"))
  }
  
  return(candidates)
}

#' Generate Categorical Encoding Variants
#'
#' @param data A data frame
#' @param label_cols Vector of categorical column names
#'
#' @return List of encoding variant datasets
#'
#' @export
generate_categorical_variants <- function(data, label_cols) {
  candidates <- list()
  for(col in label_cols) {
    if(!(col %in% colnames(data))) stop(paste("Column not found:", col))
    
    candidates[[col]] <- data
    
    ohe <- data %>%
      mutate(dummy = 1) %>%
      pivot_wider(names_from = !!sym(col), values_from = dummy, values_fill = 0)
    candidates[[paste0(col, "_OHE")]] <- ohe
  }
  return(candidates)
}
