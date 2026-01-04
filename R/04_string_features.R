#' String Feature Engineering and N-gram Validation
#'
#' Functions for extracting and validating n-gram features from text strings,
#' as well as generating feature variants for categorical and numeric data.
#'
#' @name string_features
#' @keywords internal
NULL

#' Validate N-gram Extraction
#'
#' Validate n-gram extraction by checking if the string length divides evenly
#' into n-gram chunks. Returns information about clean vs. distorted n-grams.
#'
#' @param str_len Numeric. String length (or character count) to validate.
#' @param n Numeric. N-gram size.
#'
#' @return A tibble with validation results including remainder, clean flag, and chunk counts.
#'
#' @examples
#' \dontrun{
#' validate_ngram(12, 3)  # 12 / 3 = 4 complete chunks (CLEAN)
#' validate_ngram(13, 3)  # 13 / 3 = 4 remainder 1 (DISTORTED)
#' }
#'
#' @export
validate_ngram <- function(str_len, n) {
  remainder <- str_len %% n
  is_clean <- remainder == 0
  
  tibble::tibble(
    str_len = str_len,
    n = n,
    remainder = remainder,
    is_clean = is_clean,
    status = ifelse(is_clean, "CLEAN", "DISTORTED"),
    complete_chunks = str_len %/% n,
    incomplete_chars = remainder
  )
}

#' Generate Numeric Feature Variants
#'
#' Create candidate datasets with various transformations of numeric columns
#' including scaling, standardization, and half/full detection.
#'
#' @param data A data frame containing numeric columns.
#' @param numeric_cols Character vector of numeric column names to transform.
#'
#' @return A named list of candidate datasets, each containing the original data
#'   with one numeric column transformed in different ways.
#'
#' @examples
#' \dontrun{
#' candidates <- generate_numeric_variants(mtcars, c("mpg", "hp"))
#' names(candidates)  # Shows different variant names
#' }
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

#' Generate Categorical Feature Variants
#'
#' Create candidate datasets with categorical encoding methods such as
#' one-hot encoding for categorical columns.
#'
#' @param data A data frame containing categorical columns.
#' @param label_cols Character vector of categorical column names to encode.
#'
#' @return A named list of candidate datasets with different categorical encodings.
#'
#' @examples
#' \dontrun{
#' candidates <- generate_categorical_variants(iris, "Species")
#' }
#'
#' @export
generate_categorical_variants <- function(data, label_cols) {
  candidates <- list()
  for(col in label_cols) {
    if(!(col %in% colnames(data))) stop(paste("Column not found:", col))
    
    # Original
    candidates[[col]] <- data
    
    # One-hot encoding
    ohe <- data %>%
      dplyr::mutate(dummy = 1) %>%
      tidyr::pivot_wider(names_from = !!rlang::sym(col), values_from = dummy, values_fill = 0)
    candidates[[paste0(col, "_OHE")]] <- ohe
  }
  return(candidates)
}
