#' Position-based N-gram Pattern Extraction
#'
#' Extract n-grams by position (prefix, infix, suffix) from n-gram candidate lists.
#' These functions filter n-grams based on their position within a string,
#' enabling analysis of position-specific patterns.
#'
#' @name position_extraction
#' @keywords internal
NULL

#' Extract Prefix Patterns from N-grams
#'
#' Extract the first n-gram(s) per item (prefix position) from a list of
#' n-gram datasets. Useful for analyzing opening patterns in strings.
#'
#' @param ngram_data_list A named list of n-gram datasets (output from
#'   \code{generate_ngram_char_variants()} or similar).
#' @param id_col Character. The ID column name that identifies unique items
#'   (default: "movieId").
#' @param n Numeric. Not used in this function; retained for API consistency.
#'
#' @return A named list of datasets with prefix patterns extracted. Each element
#'   includes an additional "position_type" column set to "prefix".
#'
#' @examples
#' \dontrun{
#' ngrams <- generate_ngram_char_variants(data, "title")
#' prefixes <- extract_prefix_patterns(ngrams$sliding$all)
#' }
#'
#' @export
extract_prefix_patterns <- function(ngram_data_list, id_col = "movieId", n = 3) {
  prefix_list <- list()
  
  for(dataset_name in names(ngram_data_list)) {
    dataset <- ngram_data_list[[dataset_name]]
    
    if(is.null(dataset) || nrow(dataset) == 0) next
    
    # Filter to first few positions (prefix)
    # Assumption: first n-gram is prefix
    prefix_data <- dataset %>%
      dplyr::group_by(!!rlang::sym(id_col)) %>%
      dplyr::slice(1) %>%  # First n-gram per item is prefix
      dplyr::ungroup() %>%
      dplyr::mutate(position_type = "prefix")
    
    prefix_list[[paste0(dataset_name, "_prefix")]] <- prefix_data
  }
  
  return(prefix_list)
}

#' Extract Infix Patterns from N-grams
#'
#' Extract the middle n-gram(s) per item (infix position) from a list of
#' n-gram datasets. Useful for analyzing interior patterns in strings.
#'
#' @param ngram_data_list A named list of n-gram datasets (output from
#'   \code{generate_ngram_char_variants()} or similar).
#' @param id_col Character. The ID column name that identifies unique items
#'   (default: "movieId").
#' @param n Numeric. Not used in this function; retained for API consistency.
#'
#' @return A named list of datasets with infix patterns extracted. Each element
#'   includes an additional "position_type" column set to "infix".
#'
#' @examples
#' \dontrun{
#' ngrams <- generate_ngram_char_variants(data, "title")
#' infixes <- extract_infix_patterns(ngrams$sliding$all)
#' }
#'
#' @export
extract_infix_patterns <- function(ngram_data_list, id_col = "movieId", n = 3) {
  infix_list <- list()
  
  for(dataset_name in names(ngram_data_list)) {
    dataset <- ngram_data_list[[dataset_name]]
    
    if(is.null(dataset) || nrow(dataset) == 0) next
    
    # Filter to middle positions (infix)
    infix_data <- dataset %>%
      dplyr::group_by(!!rlang::sym(id_col)) %>%
      dplyr::filter(dplyr::row_number() > 1 & dplyr::row_number() < dplyr::n()) %>%  # Middle positions
      dplyr::ungroup() %>%
      dplyr::mutate(position_type = "infix")
    
    infix_list[[paste0(dataset_name, "_infix")]] <- infix_data
  }
  
  return(infix_list)
}

#' Extract Suffix Patterns from N-grams
#'
#' Extract the last n-gram(s) per item (suffix position) from a list of
#' n-gram datasets. Useful for analyzing closing patterns in strings.
#'
#' @param ngram_data_list A named list of n-gram datasets (output from
#'   \code{generate_ngram_char_variants()} or similar).
#' @param id_col Character. The ID column name that identifies unique items
#'   (default: "movieId").
#' @param n Numeric. Not used in this function; retained for API consistency.
#'
#' @return A named list of datasets with suffix patterns extracted. Each element
#'   includes an additional "position_type" column set to "suffix".
#'
#' @examples
#' \dontrun{
#' ngrams <- generate_ngram_char_variants(data, "title")
#' suffixes <- extract_suffix_patterns(ngrams$sliding$all)
#' }
#'
#' @export
extract_suffix_patterns <- function(ngram_data_list, id_col = "movieId", n = 3) {
  suffix_list <- list()
  
  for(dataset_name in names(ngram_data_list)) {
    dataset <- ngram_data_list[[dataset_name]]
    
    if(is.null(dataset) || nrow(dataset) == 0) next
    
    suffix_data <- dataset %>%
      dplyr::group_by(!!rlang::sym(id_col)) %>%
      dplyr::slice(dplyr::n()) %>%  # Last n-gram per item is suffix
      dplyr::ungroup() %>%
      dplyr::mutate(position_type = "suffix")
    
    suffix_list[[paste0(dataset_name, "_suffix")]] <- suffix_data
  }
  
  return(suffix_list)
}
