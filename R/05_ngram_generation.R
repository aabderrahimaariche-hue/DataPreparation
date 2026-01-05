#' Character and Word Level N-gram Generation
#'
#' Generate and extract n-grams at both character and word levels using
#' multiple extraction methods. Includes validation for clean vs. distorted n-grams.
#'
#' @name ngram_generation
#' @keywords internal
NULL

#' Generate Character-level N-grams with Multiple Methods
#'
#' Extract character-level n-grams from string columns using four different methods:
#' 1. **Sliding**: Overlapping n-grams (step by 1)
#' 2. **Stride**: Non-overlapping n-grams (step by n, spaces excluded)
#' 3. **Strict**: Non-overlapping n-grams with underscore padding
#' 4. **Null**: Non-overlapping n-grams, incomplete chunks removed
#'
#' Returns a nested list with $all, $clean_only, and $distorted_only variants
#' for each method, allowing selection based on n-gram quality.
#'
#' @param data A data frame containing string columns.
#' @param string_cols Character vector of column names to extract n-grams from.
#' @param ngram_min Numeric. Minimum n-gram size (default: 2).
#' @param ngram_max Numeric. Maximum n-gram size (default: 4).
#'
#' @return A nested list structure:
#'   \code{candidates[[method]][[variant]][[dataset_name]]} where:
#'   - method: "sliding", "stride", "strict", or "null_incomplete"
#'   - variant: "all", "clean_only", or "distorted_only"
#'   - Each dataset contains the original data plus extracted n-grams
#'
#' @examples
#' \dontrun{
#' data <- data.frame(title = c("The Matrix", "Inception", "Interstellar"))
#' candidates <- generate_ngram_char_variants(data, "title", 2, 3)
#' # Access sliding n-grams, clean only: candidates$sliding$clean_only
#' }
#'
#' @export
generate_ngram_char_variants <- function(data, string_cols, ngram_min = 2, ngram_max = 4) {
  candidates <- list(
    sliding = list(all = list(), clean_only = list(), distorted_only = list()),
    stride = list(all = list(), clean_only = list(), distorted_only = list()),
    strict = list(all = list(), clean_only = list(), distorted_only = list()),
    null_incomplete = list(all = list(), clean_only = list(), distorted_only = list())
  )
  
  for(col in string_cols) {
    if(!(col %in% colnames(data))) stop(paste("Column not found:", col))
    
    # Process each n-gram size
    for(n in ngram_min:ngram_max) {
      
      # ========== METHOD 1: SLIDING WINDOW (overlapping, step by 1) ==========
      sliding_data <- data %>%
        dplyr::rowwise() %>%
        dplyr::mutate(
          str_val = .data[[col]],
          str_len = nchar(str_val),
          # Validate this n value
          validation = list(validate_ngram(str_len, n)),
          # Generate n-grams
          ngrams = list({
            if(str_len >= n) {
              sapply(1:(str_len - n + 1), 
                     function(i) substr(str_val, i, i + n - 1))
            } else {
              NA_character_
            }
          })
        ) %>%
        tidyr::unnest(validation) %>%
        tidyr::unnest_longer(ngrams, keep_empty = TRUE) %>%
        dplyr::select(-str_val, -str_len) %>%
        dplyr::mutate(
          extraction_type = "sliding",
          ngram_size = n,
          col_name = col,
          complete_flag = ifelse(is.na(ngrams), 0, 1)
        ) %>%
        dplyr::rename(ngram = ngrams)
      
      # Store in all three variants
      candidates$sliding$all[[paste0(col, "_sliding_", n)]] <- sliding_data
      candidates$sliding$clean_only[[paste0(col, "_sliding_", n)]] <- 
        sliding_data %>% dplyr::filter(is_clean == TRUE)
      candidates$sliding$distorted_only[[paste0(col, "_sliding_", n)]] <- 
        sliding_data %>% dplyr::filter(is_clean == FALSE)
      
      # ========== METHODS 2-4: STRIDE/STRICT/NULL (spaces excluded, step by n) ==========
      stride_strict_null_data <- data %>%
        dplyr::rowwise() %>%
        dplyr::mutate(
          str_original = .data[[col]],
          # Remove spaces for clean calculation
          str_no_space = gsub(" ", "", .data[[col]]),
          str_len = nchar(str_no_space),
          # Validate
          validation = list(validate_ngram(str_len, n))
        ) %>%
        tidyr::unnest(validation) %>%
        # Generate all three types
        dplyr::mutate(
          # STRIDE: non-overlapping, keep incomplete as-is
          stride_ngrams = list({
            str_val <- str_no_space
            result <- character(0)
            for(i in seq(1, str_len, by = n)) {
              if(i + n - 1 <= str_len) {
                result <- c(result, substr(str_val, i, i + n - 1))
              } else {
                remainder <- substr(str_val, i, str_len)
                result <- c(result, remainder)
              }
            }
            result
          }),
          # STRICT: non-overlapping, padded with underscores
          strict_ngrams = list({
            str_val <- str_no_space
            result <- character(0)
            for(i in seq(1, str_len, by = n)) {
              partial <- substr(str_val, i, min(i + n - 1, str_len))
              if(nchar(partial) < n) {
                partial <- paste0(partial, strrep("_", n - nchar(partial)))
              }
              result <- c(result, partial)
            }
            result
          }),
          # NULL: non-overlapping, incomplete → NA
          null_ngrams = list({
            str_val <- str_no_space
            result <- character(0)
            for(i in seq(1, str_len, by = n)) {
              if(i + n - 1 <= str_len) {
                result <- c(result, substr(str_val, i, i + n - 1))
              } else {
                result <- c(result, NA_character_)
              }
            }
            result
          })
        ) %>%
        dplyr::select(-str_original, -str_no_space, -str_len)
      
      # Process STRIDE
      stride_final <- stride_strict_null_data %>%
        dplyr::select(-strict_ngrams, -null_ngrams) %>%
        tidyr::unnest_longer(stride_ngrams, keep_empty = TRUE) %>%
        dplyr::rename(ngram = stride_ngrams) %>%
        dplyr::mutate(
          extraction_type = "stride",
          ngram_size = n,
          col_name = col,
          complete_flag = ifelse(is.na(ngram), 0, 1)
        )
      
      candidates$stride$all[[paste0(col, "_stride_", n)]] <- stride_final
      candidates$stride$clean_only[[paste0(col, "_stride_", n)]] <- 
        stride_final %>% dplyr::filter(is_clean == TRUE)
      candidates$stride$distorted_only[[paste0(col, "_stride_", n)]] <- 
        stride_final %>% dplyr::filter(is_clean == FALSE)
      
      # Process STRICT
      strict_final <- stride_strict_null_data %>%
        dplyr::select(-stride_ngrams, -null_ngrams) %>%
        tidyr::unnest_longer(strict_ngrams, keep_empty = TRUE) %>%
        dplyr::rename(ngram = strict_ngrams) %>%
        dplyr::mutate(
          extraction_type = "strict",
          ngram_size = n,
          col_name = col,
          complete_flag = ifelse(grepl("_", ngram), 0, 1)
        )
      
      candidates$strict$all[[paste0(col, "_strict_", n)]] <- strict_final
      candidates$strict$clean_only[[paste0(col, "_strict_", n)]] <- 
        strict_final %>% dplyr::filter(is_clean == TRUE)
      candidates$strict$distorted_only[[paste0(col, "_strict_", n)]] <- 
        strict_final %>% dplyr::filter(is_clean == FALSE)
      
      # Process NULL_INCOMPLETE
      null_final <- stride_strict_null_data %>%
        dplyr::select(-stride_ngrams, -strict_ngrams) %>%
        tidyr::unnest_longer(null_ngrams, keep_empty = TRUE) %>%
        dplyr::rename(ngram = null_ngrams) %>%
        dplyr::mutate(
          extraction_type = "null_incomplete",
          ngram_size = n,
          col_name = col,
          complete_flag = ifelse(is.na(ngram), 0, 1)
        ) %>%
        dplyr::filter(!is.na(ngram))  # Remove null rows for this method
      
      candidates$null_incomplete$all[[paste0(col, "_null_", n)]] <- null_final
      candidates$null_incomplete$clean_only[[paste0(col, "_null_", n)]] <- 
        null_final %>% dplyr::filter(is_clean == TRUE)
      candidates$null_incomplete$distorted_only[[paste0(col, "_null_", n)]] <- 
        null_final %>% dplyr::filter(is_clean == FALSE)
    }
  }
  
  return(candidates)
}

#' Generate Word-level N-grams
#'
#' Extract word-level n-grams from string columns. Splits strings by whitespace
#' and creates n-grams of consecutive words joined by underscores.
#'
#' @param data A data frame containing string columns.
#' @param string_cols Character vector of column names to extract word n-grams from.
#' @param ngram_min Numeric. Minimum n-gram size (default: 1 for single words).
#' @param ngram_max Numeric. Maximum n-gram size (default: 3).
#'
#' @return A named list where each element is a data frame containing:
#'   - Original data columns
#'   - A new column with word-level n-grams
#'   - For word_sep variant: data with words split into separate rows
#'
#' @examples
#' \dontrun{
#' data <- data.frame(title = c("The Matrix", "Inception", "Interstellar"))
#' candidates <- generate_ngram_word_variants(data, "title", 1, 2)
#' }
#'
#' @export
generate_ngram_word_variants <- function(data, string_cols, ngram_min = 1, ngram_max = 3) {
  candidates <- list()
  
  for(col in string_cols) {
    if(!(col %in% colnames(data))) stop(paste("Column not found:", col))
    
    # --- Original: word-by-word separation ---
    word_split <- data %>% tidyr::separate_rows(dplyr::all_of(col), sep = "\\s+")
    candidates[[paste0(col, "_words_sep")]] <- word_split
    
    # --- Word-level n-grams ---
    for(n in ngram_min:ngram_max) {
      ngram_col <- paste0(col, "_word_ngrams_", n)
      
      # Split by words and create n-grams
      ngram_data <- data %>%
        dplyr::rowwise() %>%
        dplyr::mutate(!!ngram_col := list({
          words <- stringr::str_split(.data[[col]], "\\s+")[[1]]
          if(length(words) >= n) {
            sapply(1:(length(words) - n + 1), 
                   function(i) paste(words[i:(i+n-1)], collapse = "_"))
          } else if(length(words) == 1 & n == 1) {
            words
          } else {
            NA_character_
          }
        })) %>%
        tidyr::unnest_longer(dplyr::all_of(ngram_col), keep_empty = TRUE)
      
      candidates[[ngram_col]] <- ngram_data
    }
  }
  
  return(candidates)
}
