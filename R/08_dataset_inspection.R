#########################################################
# DATASET INSPECTION & VALIDATION
# Module: 08_dataset_inspection.R
# Purpose: Inspect and validate datasets before processing
#########################################################

#' Inspect Dataset Structure and Contents
#'
#' Provides a comprehensive overview of your dataset including structure,
#' data types, missing values, and memory usage. Helps identify which
#' columns are suitable for DataPreparation functions.
#'
#' @param data A data frame to inspect (optional if dataset_name provided)
#' @param verbose Logical. If TRUE (default), prints detailed report
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Invisibly returns a list with inspection results containing:
#'   - dimensions: rows and columns
#'   - column_info: names, types, non-null counts
#'   - missing_values: count and percentage per column
#'   - memory_size: estimated size in bytes
#'   - data_quality_score: overall quality percentage
#'
#' @examples
#' \dontrun{
#' data <- data.frame(
#'   id = 1:5,
#'   name = c("John", "Mary", "Bob", NA, "Alice"),
#'   age = c(25, 30, NA, 35, 28),
#'   score = c(85.5, 90.2, 88.1, 92.3, 87.6)
#' )
#' inspect_dataset(data)
#' }
#'
#' @export
inspect_dataset <- function(data = NULL, verbose = TRUE, dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  
  # Basic dimensions
  n_rows <- nrow(data)
  n_cols <- ncol(data)
  
  # Column information
  col_info <- data.frame(
    Column = colnames(data),
    Type = sapply(data, class),
    Non_Null = sapply(data, function(x) sum(!is.na(x))),
    row.names = NULL
  )
  col_info$Null_Count <- n_rows - col_info$Non_Null
  col_info$Null_Percent <- round((col_info$Null_Count / n_rows) * 100, 2)
  
  # Memory size
  memory_size <- object.size(data)
  
  # Data quality score
  total_values <- n_rows * n_cols
  non_null_values <- sum(col_info$Non_Null)
  quality_score <- round((non_null_values / total_values) * 100, 2)
  
  # Create results list
  results <- list(
    dimensions = list(rows = n_rows, columns = n_cols),
    column_info = col_info,
    memory_size = memory_size,
    quality_score = quality_score
  )
  
  # Print report if verbose
  if (verbose) {
    cat("\n")
    cat("=" %+% "=", strrep("=", 60), "\n")
    cat("| DATASET INSPECTION REPORT\n")
    cat("=" %+% "=", strrep("=", 60), "\n\n")
    
    # Dimensions
    cat("📊 DIMENSIONS\n")
    cat("  Rows:     ", n_rows, "\n")
    cat("  Columns:  ", n_cols, "\n")
    cat("  Memory:   ", format(memory_size, units = "auto"), "\n\n")
    
    # Data Quality
    cat("✨ DATA QUALITY\n")
    cat("  Quality Score: ", quality_score, "%\n\n")
    
    # Column Details
    cat("📋 COLUMN DETAILS\n")
    print(col_info, row.names = FALSE)
    cat("\n")
    
    # Function recommendations
    cat("💡 FUNCTION RECOMMENDATIONS\n")
    string_cols <- col_info$Column[col_info$Type == "character"]
    numeric_cols <- col_info$Column[col_info$Type %in% c("numeric", "integer")]
    
    if (length(string_cols) > 0) {
      cat("  String columns (", paste(string_cols, collapse = ", "), "):\n")
      cat("    ✓ Use: generate_ngram_char_variants()\n")
      cat("    ✓ Use: generate_ngram_word_variants()\n")
      cat("    ✓ Use: extract_string_linguistic_profile()\n")
      cat("    ✓ Use: extract_year_from_string()\n\n")
    }
    
    if (length(numeric_cols) > 0) {
      cat("  Numeric columns (", paste(numeric_cols, collapse = ", "), "):\n")
      cat("    ✓ Use: scale_betweenRange()\n")
      cat("    ✓ Use: normalize_numeric()\n")
      cat("    ✓ Use: flag_outliers_iqr()\n")
      cat("    ✓ Use: create_polynomial_features()\n\n")
    }
    
    # Missing data warnings
    cols_with_missing <- col_info$Column[col_info$Null_Count > 0]
    if (length(cols_with_missing) > 0) {
      cat("⚠️  MISSING DATA DETECTED\n")
      for (col in cols_with_missing) {
        null_pct <- col_info[col_info$Column == col, "Null_Percent"]
        cat("    ", col, ": ", null_pct, "% missing\n")
      }
      cat("    Recommendation: Use remove_na_columns() or impute_na_numeric()\n\n")
    }
    
    cat("=" %+% "=", strrep("=", 60), "\n\n")
  }
  
  invisible(results)
}

#' Validate Dataset for Specific Functions
#'
#' Checks if your dataset is suitable for using specific DataPreparation
#' functions. Validates column existence, data types, and data quality.
#'
#' @param data A data frame to validate (optional if dataset_name provided)
#' @param string_cols Character vector of column names to use as strings
#'   (for n-gram generation, linguistic analysis, etc.)
#' @param numeric_cols Character vector of column names to use as numerics
#'   (for scaling, transformations, etc.)
#' @param id_col Character. Name of the ID column that uniquely identifies
#'   each row (for linguistic analysis functions)
#' @param verbose Logical. If TRUE, prints validation report
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return Logical. TRUE if valid, FALSE otherwise (invisibly)
#'
#' @examples
#' \dontrun{
#' movies <- data.frame(
#'   movieId = 1:3,
#'   title = c("The Matrix", "Inception", "Interstellar"),
#'   rating = c(8.7, 8.8, 8.6)
#' )
#'
#' # Validate for suffix/prefix extraction workflow
#' validate_for_processing(
#'   data = movies,
#'   string_cols = "title",
#'   id_col = "movieId"
#' )
#' }
#'
#' @export
validate_for_processing <- function(data = NULL, string_cols = NULL, numeric_cols = NULL,
                                     id_col = NULL, verbose = TRUE, dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  
  issues <- c()
  
  # Check string columns
  if (!is.null(string_cols)) {
    for (col in string_cols) {
      if (!(col %in% colnames(data))) {
        issues <- c(issues, paste("❌ String column not found:", col))
      } else if (!is.character(data[[col]])) {
        issues <- c(issues, paste("❌ Column", col, "is not character type"))
      }
    }
  }
  
  # Check numeric columns
  if (!is.null(numeric_cols)) {
    for (col in numeric_cols) {
      if (!(col %in% colnames(data))) {
        issues <- c(issues, paste("❌ Numeric column not found:", col))
      } else if (!is.numeric(data[[col]])) {
        issues <- c(issues, paste("❌ Column", col, "is not numeric type"))
      }
    }
  }
  
  # Check ID column
  if (!is.null(id_col)) {
    if (!(id_col %in% colnames(data))) {
      issues <- c(issues, paste("❌ ID column not found:", id_col))
    } else if (length(unique(data[[id_col]])) != nrow(data)) {
      issues <- c(issues, paste("⚠️  ID column", id_col, "contains duplicates"))
    }
  }
  
  # Print report
  if (verbose) {
    cat("\n")
    cat("=" %+% "=", strrep("=", 60), "\n")
    cat("| VALIDATION REPORT\n")
    cat("=" %+% "=", strrep("=", 60), "\n\n")
    
    if (length(issues) == 0) {
      cat("✅ VALIDATION PASSED\n")
      cat("   Your dataset is ready for processing!\n\n")
      cat("   Suggested workflow:\n")
      if (!is.null(string_cols)) {
        cat("   1. Generate n-grams: generate_ngram_char_variants(data, '", string_cols[1], "')\n")
        cat("   2. Extract suffixes: extract_suffix_patterns(ngrams$sliding$all)\n")
        cat("   3. Extract prefixes: extract_prefix_patterns(ngrams$sliding$all)\n")
      }
      cat("\n")
    } else {
      cat("❌ VALIDATION FAILED\n\n")
      for (issue in issues) {
        cat("  ", issue, "\n")
      }
      cat("\n   Please fix the above issues before processing.\n\n")
    }
    
    cat("=" %+% "=", strrep("=", 60), "\n\n")
  }
  
  invisible(length(issues) == 0)
}

#' Display Dataset Preview
#'
#' Shows first few rows of each column with clear formatting,
#' useful for understanding data before processing.
#'
#' @param data A data frame to preview (optional if dataset_name provided)
#' @param n_rows Number of rows to display (default: 5)
#' @param dataset_name Character. Name of registered dataset to use.
#'
#' @return NULL (invisibly). Prints formatted preview.
#'
#' @examples
#' \dontrun{
#' movies <- data.frame(
#'   movieId = 1:3,
#'   title = c("The Matrix", "Inception", "Interstellar")
#' )
#' preview_dataset(movies, n_rows = 3)
#' }
#'
#' @export
preview_dataset <- function(data = NULL, n_rows = 5, dataset_name = NULL) {
  # Smart data resolution
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    data <- resolve_data_source(data)
  }
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  
  n_rows <- min(n_rows, nrow(data))
  
  cat("\n")
  cat("📄 DATASET PREVIEW (First", n_rows, "rows)\n")
  cat("=" %+% "=", strrep("=", 60), "\n\n")
  print(head(data, n_rows))
  cat("\n")
}

#' Check Memory Usage of Datasets
#'
#' Lists all data frames in the global environment and their memory usage.
#' Useful for identifying large datasets.
#'
#' @param envir Environment to search (default: global environment)
#'
#' @return Invisible data frame with dataset information
#'
#' @examples
#' \dontrun{
#' df1 <- data.frame(x = 1:1000)
#' df2 <- data.frame(y = 1:10000)
#' check_memory_usage()
#' }
#'
#' @export
check_memory_usage <- function(envir = .GlobalEnv) {
  # Get all objects in environment
  all_objects <- ls(envir = envir)
  
  # Filter to data frames only
  dataframes <- c()
  for (obj in all_objects) {
    if (is.data.frame(get(obj, envir = envir))) {
      dataframes <- c(dataframes, obj)
    }
  }
  
  if (length(dataframes) == 0) {
    cat("No data frames found in environment.\n")
    return(invisible(NULL))
  }
  
  # Get info for each data frame
  df_info <- data.frame(
    Dataset = dataframes,
    Rows = sapply(dataframes, function(x) nrow(get(x, envir = envir))),
    Columns = sapply(dataframes, function(x) ncol(get(x, envir = envir))),
    Memory = sapply(dataframes, function(x) {
      format(object.size(get(x, envir = envir)), units = "auto")
    }),
    row.names = NULL
  )
  
  # Print report
  cat("\n")
  cat("💾 MEMORY USAGE REPORT\n")
  cat("=" %+% "=", strrep("=", 60), "\n\n")
  print(df_info)
  cat("\n")
  
  invisible(df_info)
}
