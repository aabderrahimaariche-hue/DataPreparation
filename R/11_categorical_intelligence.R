#########################################################
# CATEGORICAL INTELLIGENCE FUNCTIONS
# Module: 11_categorical_intelligence.R
# Purpose: Universal functions for processing categorical 
#          data (delimited categories: PIPE|COMMA|SEMICOLON)
#          Works with ANY categorical: genres, tags, categories, etc.
#          Generalized architecture: ANY identifier_col + ANY category_col + ANY delimiter
# Author: AARICHE ABDERRAHIM
# Philosophy: Intelligence (Identifiers) + Readables (Categorical Data)
#########################################################

#' Encode Categorical Data into Binary Flags (One-Hot Encoding)
#'
#' Convert delimited categorical data (PIPE|COMMA|SEMICOLON) into binary indicator columns.
#' Works with ANY categorical structure: genres|tags|categories|attributes
#'
#' @param data A data frame containing categorical column (optional if dataset_name provided)
#' @param categorical_col Column name with delimited categories (e.g., "genres")
#' @param identifier_col Optional: ID column to preserve unique records
#' @param delimiter Pattern to split categories (default: "\\\\|" for pipe)
#' @param prefix Optional: prefix for output columns (default: category name)
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Data frame with one-hot encoded binary columns (0/1 for each category)
#'
#' @examples
#' \dontrun{
#' # MovieLens: encode genres
#' genre_flags <- encode_categorical_flags(data, "genres", "movieId", "\\\\|")
#'
#' # E-commerce: encode product tags
#' tag_flags <- encode_categorical_flags(data, "tags", "productId", ",")
#'
#' # Healthcare: encode symptoms
#' symptom_flags <- encode_categorical_flags(data, "symptoms", "patientId", ";")
#' }
#'
#' @export
encode_categorical_flags <- function(data = NULL, categorical_col, identifier_col = NULL, 
                                    delimiter = "\\\\|", prefix = NULL, dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  if(!(categorical_col %in% colnames(data))) stop(paste("Categorical column not found:", categorical_col))
  
  # Preserve ID column if provided
  if(!is.null(identifier_col)) {
    if(!(identifier_col %in% colnames(data))) stop(paste("ID column not found:", identifier_col))
    result <- data %>% select(!!sym(identifier_col), !!sym(categorical_col))
  } else {
    result <- data %>% select(!!sym(categorical_col))
  }
  
  result <- result %>%
    distinct() %>%
    separate_rows(!!sym(categorical_col), sep = delimiter) %>%
    mutate(category_present = 1) %>%
    pivot_wider(
      names_from = !!sym(categorical_col),
      values_from = category_present,
      values_fill = 0
    )
  
  # Add prefix if provided
  if(!is.null(prefix)) {
    cols_to_rename <- setdiff(colnames(result), identifier_col)
    names(result)[names(result) %in% cols_to_rename] <- paste0(prefix, "_", cols_to_rename)
  }
  
  return(result)
}

#' Count Categories per Entity
#'
#' Count how many categories exist for each entity (diversity measure).
#' Returns count and multi-category flag.
#'
#' @param data A data frame (optional if dataset_name provided)
#' @param identifier_col Column name containing entity identifiers (optional)
#' @param categorical_col Column name with delimited categories
#' @param delimiter Pattern to split categories (default: "\\\\|")
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Data frame with identifier_col (if provided), category_count, and is_multi_category flag
#'
#' @examples
#' \dontrun{
#' genre_count <- count_categories(data, "movieId", "genres", "\\\\|")
#' }
#'
#' @export
count_categories <- function(data = NULL, identifier_col = NULL, categorical_col, delimiter = "\\\\|", dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  if(!(categorical_col %in% colnames(data))) stop(paste("Categorical column not found:", categorical_col))
  
  result <- data %>%
    select(all_of(c(identifier_col, categorical_col))) %>%
    distinct() %>%
    mutate(
      category_count = str_count(.data[[categorical_col]], delimiter) + 1,
      is_multi_category = ifelse(category_count > 1, 1, 0)
    )
  
  return(result)
}

#' Extract Primary (First) Category
#'
#' Get the first category from delimited categorical data.
#' Useful for deriving main category or category classification.
#'
#' @param data A data frame (optional if dataset_name provided)
#' @param identifier_col Column name containing entity identifiers
#' @param categorical_col Column name with delimited categories
#' @param delimiter Pattern to split categories (default: "\\\\|")
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Data frame with identifier_col and primary_category column
#'
#' @examples
#' \dontrun{
#' primary_genres <- extract_primary_category(data, "movieId", "genres", "\\\\|")
#' }
#'
#' @export
extract_primary_category <- function(data = NULL, identifier_col, categorical_col, delimiter = "\\\\|", dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  if(!(identifier_col %in% colnames(data))) stop(paste("ID column not found:", identifier_col))
  if(!(categorical_col %in% colnames(data))) stop(paste("Categorical column not found:", categorical_col))
  
  # Extract first category before delimiter
  first_cat_pattern <- paste0("^([^", strsplit(delimiter, "\\\\")[[1]][1], "]+)")
  
  data %>%
    select(!!sym(identifier_col), !!sym(categorical_col)) %>%
    distinct() %>%
    mutate(!!paste0(categorical_col, "_primary") := str_extract(.data[[categorical_col]], first_cat_pattern))
}

#' Compute Category-Valeurization Statistics
#'
#' Calculate aggregated statistics (mean, std, count, median) for each category
#' grouped by identifier and value column.
#'
#' @param data A data frame with delimited categorical column (optional if dataset_name provided)
#' @param categorical_col Column name with delimited categories
#' @param value_col Column name with numeric values to aggregate
#' @param delimiter Pattern to split categories (default: "\\\\|")
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Data frame with one row per category showing statistics:
#'   category, *_mean, *_std, *_count, *_median
#'
#' @examples
#' \dontrun{
#' # Genre statistics: mean rating, count, etc. per genre
#' genre_stats <- compute_category_statistics(data, "genres", "rating", "\\\\|")
#'
#' # Tag statistics: mean price per tag
#' tag_stats <- compute_category_statistics(data, "tags", "price", ",")
#' }
#'
#' @export
compute_category_statistics <- function(data = NULL, categorical_col, value_col, delimiter = "\\\\|", dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  if(!(categorical_col %in% colnames(data))) stop(paste("Categorical column not found:", categorical_col))
  if(!(value_col %in% colnames(data))) stop(paste("Value column not found:", value_col))
  
  data %>%
    separate_rows(!!sym(categorical_col), sep = delimiter) %>%
    group_by(!!sym(categorical_col)) %>%
    summarise(
      !!paste0(value_col, "_mean") := mean(.data[[value_col]], na.rm = TRUE),
      !!paste0(value_col, "_std") := sd(.data[[value_col]], na.rm = TRUE),
      !!paste0(value_col, "_count") := n(),
      !!paste0(value_col, "_median") := median(.data[[value_col]], na.rm = TRUE),
      .groups = "drop"
    ) %>%
    rename(category = !!sym(categorical_col))
}

#' Compute Entity-Category Preferences
#'
#' Calculate preference deviation (from global mean) for each identifier-category pair.
#' Used to find what categories each entity prefers based on valeurization values.
#'
#' @param data A data frame with identifier, categories, and values (optional if dataset_name provided)
#' @param identifier_col Column name with entity identifiers (e.g., "userId")
#' @param categorical_col Column name with delimited categories (e.g., "genres")
#' @param value_col Column name with numeric values (e.g., "rating")
#' @param delimiter Pattern to split categories (default: "\\\\|")
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Data frame with one row per entity showing preference per category
#'   (pivot_wider format: entity_id + pref_category1 + pref_category2 + ...)
#'
#' @examples
#' \dontrun{
#' # User genre preferences: which genres does each user prefer?
#' user_prefs <- compute_category_preferences(data, "userId", "genres", "rating", "\\\\|")
#'
#' # Customer product preferences
#' customer_prefs <- compute_category_preferences(data, "customerId", "product_type", "purchase_value", ",")
#' }
#'
#' @export
compute_category_preferences <- function(data = NULL, identifier_col, categorical_col, 
                                               value_col, delimiter = "\\\\|", dataset_name = NULL) {
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
  if(!(categorical_col %in% colnames(data))) stop(paste("Categorical column not found:", categorical_col))
  if(!(value_col %in% colnames(data))) stop(paste("Value column not found:", value_col))
  
  global_mean <- mean(data[[value_col]], na.rm = TRUE)
  
  data %>%
    separate_rows(!!sym(categorical_col), sep = delimiter) %>%
    group_by(!!sym(identifier_col), !!sym(categorical_col)) %>%
    summarise(
      entity_category_mean = mean(.data[[value_col]], na.rm = TRUE),
      entity_category_count = n(),
      .groups = "drop"
    ) %>%
    mutate(entity_category_preference = entity_category_mean - global_mean) %>%
    pivot_wider(
      identifier_cols = !!sym(identifier_col),
      names_from = !!sym(categorical_col),
      values_from = entity_category_preference,
      values_fill = 0,
      names_prefix = "pref_"
    )
}

#' Compute Category Diversity Score
#'
#' Measure how specialized (niche) vs generalist (mainstream) categories are.
#' Based on category frequency and representation across entities.
#'
#' @param data A data frame (optional if dataset_name provided)
#' @param categorical_col Column name with delimited categories
#' @param delimiter Pattern to split categories (default: "\\\\|")
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Data frame with category, category_count, and diversity metrics
#'
#' @export
compute_category_diversity <- function(data = NULL, categorical_col, delimiter = "\\\\|", dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  if(!(categorical_col %in% colnames(data))) stop(paste("Categorical column not found:", categorical_col))
  
  data %>%
    separate_rows(!!sym(categorical_col), sep = delimiter) %>%
    group_by(!!sym(categorical_col)) %>%
    summarise(
      category_frequency = n(),
      .groups = "drop"
    ) %>%
    mutate(
      category_count = nrow(.),
      category_diversity = category_frequency / max(category_frequency),
      is_niche = ifelse(category_diversity < 0.25, 1, 0),
      is_mainstream = ifelse(category_diversity >= 0.5, 1, 0)
    ) %>%
    rename(category = !!sym(categorical_col))
}

#' Compute Category Combination Patterns
#'
#' Find most common multi-category combinations (e.g., genres that appear together).
#'
#' @param data A data frame with delimited categories (optional if dataset_name provided)
#' @param identifier_col Column name containing entity identifiers
#' @param categorical_col Column name with delimited categories
#' @param delimiter Pattern to split categories (default: "\\\\|")
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Data frame with multi-category combinations and their frequency
#'
#' @export
compute_category_combinations <- function(data = NULL, identifier_col, categorical_col, delimiter = "\\\\|", dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  if(!(identifier_col %in% colnames(data))) stop(paste("ID column not found:", identifier_col))
  if(!(categorical_col %in% colnames(data))) stop(paste("Categorical column not found:", categorical_col))
  
  multi_category_data <- data %>%
    select(!!sym(identifier_col), !!sym(categorical_col)) %>%
    distinct() %>%
    filter(str_detect(.data[[categorical_col]], delimiter))
  
  multi_category_data %>%
    group_by(!!sym(categorical_col)) %>%
    summarise(
      combination_count = n(),
      .groups = "drop"
    ) %>%
    arrange(desc(combination_count)) %>%
    rename(category_combination = !!sym(categorical_col))
}

#########################################################
# END OF CATEGORICAL INTELLIGENCE MODULE
#########################################################

