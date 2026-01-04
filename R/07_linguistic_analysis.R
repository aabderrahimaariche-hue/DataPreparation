#' Linguistic Analysis and Feature Extraction
#'
#' Advanced linguistic analysis functions that dynamically discover patterns
#' from text data and compute effects on ratings, user preferences, and compatibility.
#' These functions extract structural features, word frequencies, and suffix patterns
#' to enable comprehensive linguistic analysis.
#'
#' @name linguistic_analysis
#' @keywords internal
NULL

#' Extract Linguistic Profile from String Data
#'
#' Dynamically extract linguistic features from string columns by discovering
#' patterns in the dataset. Creates both structural features (length, word count, etc.)
#' and binary flags for high-frequency words and suffix patterns found in the data.
#'
#' @param data A data frame containing the string column to analyze.
#' @param string_col Character. Name of the string column to analyze (default: "title").
#' @param id_col Character. Unique identifier column (default: "movieId").
#' @param min_word_frequency Numeric. Minimum frequency threshold for extracting
#'   high-frequency words (default: 5).
#'
#' @return A list containing:
#'   \describe{
#'     \item{profile}{Data frame with structural features and dynamic binary flags}
#'     \item{word_frequencies}{Data frame of word frequencies from the dataset}
#'     \item{suffix_patterns}{Data frame of common suffix patterns}
#'   }
#'
#' @examples
#' \dontrun{
#' profile <- extract_string_linguistic_profile(movies, "title", "movieId")
#' head(profile$profile)
#' }
#'
#' @export
extract_string_linguistic_profile <- function(data, string_col = "title", id_col = "movieId",
                                              min_word_frequency = 5) {
  
  # 1. Basic structural features (always consistent)
  string_profile <- data %>%
    dplyr::select(dplyr::all_of(id_col), dplyr::all_of(string_col)) %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      # Structural features
      string_length = nchar(gsub(" ", "", .data[[string_col]])),
      word_count = stringr::str_count(.data[[string_col]], "\\S+"),
      has_numbers = ifelse(grepl("\\d", .data[[string_col]]), 1, 0),
      has_special_chars = ifelse(grepl("[^a-zA-Z0-9 ]", .data[[string_col]]), 1, 0),
      starts_with_article = ifelse(grepl("^(The|A|An) ", .data[[string_col]]), 1, 0),
      starts_uppercase = ifelse(grepl("^[A-Z]", .data[[string_col]]), 1, 0),
      is_all_caps = ifelse(grepl("^[A-Z\\s]+$", .data[[string_col]]), 1, 0)
    )
  
  # 2. Extract unique words/tokens from dataset (DYNAMIC patterns)
  all_text <- paste(.data[[string_col]], collapse = " ")
  
  # Extract word frequencies
  word_frequencies <- data %>%
    dplyr::select(dplyr::all_of(string_col)) %>%
    tidyr::separate_rows(dplyr::all_of(string_col), sep = "\\s+") %>%
    dplyr::pull(dplyr::all_of(string_col)) %>%
    table() %>%
    as.data.frame() %>%
    dplyr::rename(word = ".", frequency = "Freq") %>%
    dplyr::filter(frequency >= min_word_frequency) %>%
    dplyr::arrange(dplyr::desc(frequency))
  
  # 3. Extract character-level suffix patterns from most common words (DYNAMIC)
  common_suffixes <- data %>%
    dplyr::select(dplyr::all_of(string_col)) %>%
    tidyr::separate_rows(dplyr::all_of(string_col), sep = "\\s+") %>%
    dplyr::pull(dplyr::all_of(string_col)) %>%
    stringr::str_extract("....$") %>%  # Last 4 characters
    table() %>%
    as.data.frame() %>%
    dplyr::rename(suffix = ".", frequency = "Freq") %>%
    dplyr::filter(frequency >= 10) %>%  # Only suffixes appearing 10+ times
    dplyr::arrange(dplyr::desc(frequency)) %>%
    head(10)  # Top 10 most common suffixes
  
  # 4. Create binary flags for top words/suffixes found in the data
  for(word in head(word_frequencies$word, 15)) {  # Top 15 words
    col_name <- paste0("has_word_", tolower(word))
    string_profile <- string_profile %>%
      dplyr::mutate(!!rlang::sym(col_name) := ifelse(grepl(word, .data[[string_col]], ignore.case = TRUE), 1, 0))
  }
  
  for(i in 1:nrow(common_suffixes)) {
    suffix <- common_suffixes$suffix[i]
    col_name <- paste0("has_suffix_", tolower(gsub("[^a-z]", "", suffix)))
    string_profile <- string_profile %>%
      dplyr::mutate(!!rlang::sym(col_name) := ifelse(grepl(paste0(suffix, "$"), .data[[string_col]], ignore.case = TRUE), 1, 0))
  }
  
  # Return profile with metadata
  result <- list(
    profile = string_profile,
    word_frequencies = word_frequencies,
    suffix_patterns = common_suffixes
  )
  
  return(result)
}

#' Compute Global Linguistic Effects on Target Variable
#'
#' Calculate the effect of linguistic features on a target variable (e.g., rating)
#' by comparing average ratings when features are present vs. absent.
#' Dynamically discovers linguistic features from the dataset.
#'
#' @param data A data frame with string column, target variable, and ID column.
#' @param string_col Character. String column to analyze (default: "title").
#' @param id_col Character. Unique identifier column (default: "movieId").
#' @param rating_col Character. Target variable column (default: "rating").
#' @param min_word_frequency Numeric. Minimum word frequency threshold (default: 5).
#'
#' @return A list containing:
#'   \describe{
#'     \item{global_effects}{Data frame of linguistic features and their effects}
#'     \item{feature_columns}{Character vector of feature column names}
#'     \item{title_profile}{Extracted linguistic profile}
#'     \item{word_frequencies}{Word frequency data}
#'     \item{suffix_patterns}{Suffix pattern data}
#'   }
#'
#' @examples
#' \dontrun{
#' effects <- compute_global_linguistic_effects(movies, "title", "movieId", "rating")
#' head(effects$global_effects)
#' }
#'
#' @export
compute_global_linguistic_effects <- function(data, string_col = "title", id_col = "movieId",
                                             rating_col = "rating", min_word_frequency = 5) {
  
  # Step 1: Extract linguistic profile dynamically from dataset
  linguistic_result <- extract_string_linguistic_profile(data, string_col, id_col, min_word_frequency)
  title_profile <- linguistic_result$profile
  
  # Step 2: Merge data with linguistic profile
  merged_data <- data %>%
    dplyr::left_join(title_profile, by = id_col)
  
  # Step 3: Identify all feature columns (those starting with "has_" or "is_" or "starts_")
  feature_cols <- colnames(title_profile) %>%
    grep("^(has_|is_|starts_)", ., value = TRUE)
  
  # Step 4: Calculate effects for each discovered feature
  effects_list <- list()
  
  for(feature in feature_cols) {
    feature_effect <- merged_data %>%
      dplyr::group_by(!!rlang::sym(feature)) %>%
      dplyr::summarise(
        avg_rating = mean(!!rlang::sym(rating_col), na.rm = TRUE),
        count = dplyr::n(),
        std_dev = sd(!!rlang::sym(rating_col), na.rm = TRUE),
        .groups = "drop"
      ) %>%
      dplyr::mutate(
        linguistic_feature = feature,
        effect = avg_rating - mean(merged_data[[rating_col]], na.rm = TRUE)
      )
    
    effects_list[[feature]] <- feature_effect
  }
  
  # Step 5: Combine all effects
  global_effects <- do.call(rbind, effects_list) %>%
    dplyr::select(linguistic_feature, dplyr::everything()) %>%
    dplyr::arrange(dplyr::desc(abs(effect)))
  
  # Return both effects and metadata
  result <- list(
    global_effects = global_effects,
    feature_columns = feature_cols,
    title_profile = title_profile,
    word_frequencies = linguistic_result$word_frequencies,
    suffix_patterns = linguistic_result$suffix_patterns
  )
  
  return(result)
}

#' Compute User-specific Linguistic Preferences
#'
#' Extract user-specific preferences for linguistic features by comparing
#' average ratings for each user when features are present vs. absent.
#' Dynamically discovers features from the dataset.
#'
#' @param data A data frame with user, string, and rating columns.
#' @param string_col Character. String column to analyze (default: "title").
#' @param id_col Character. Item ID column (default: "movieId").
#' @param user_col Character. User identifier column (default: "userId").
#' @param rating_col Character. Target variable column (default: "rating").
#' @param min_word_frequency Numeric. Minimum word frequency threshold (default: 5).
#'
#' @return A list containing:
#'   \describe{
#'     \item{user_preferences}{Data frame of user preferences for each feature}
#'     \item{feature_columns}{Character vector of discovered features}
#'     \item{title_profile}{Extracted linguistic profile}
#'     \item{word_frequencies}{Word frequency data}
#'     \item{suffix_patterns}{Suffix pattern data}
#'   }
#'
#' @examples
#' \dontrun{
#' prefs <- compute_user_linguistic_preferences(ratings, "title", "movieId", "userId")
#' }
#'
#' @export
compute_user_linguistic_preferences <- function(data, string_col = "title", id_col = "movieId",
                                               user_col = "userId", rating_col = "rating",
                                               min_word_frequency = 5) {
  
  # Step 1: Extract linguistic profile dynamically from dataset
  linguistic_result <- extract_string_linguistic_profile(data, string_col, id_col, min_word_frequency)
  title_profile <- linguistic_result$profile
  
  # Step 2: Merge data with linguistic profile
  merged_data <- data %>%
    dplyr::left_join(title_profile, by = id_col)
  
  # Step 3: Identify all feature columns (those starting with "has_" or "is_" or "starts_")
  feature_cols <- colnames(title_profile) %>%
    grep("^(has_|is_|starts_)", ., value = TRUE)
  
  # Step 4: Calculate user preferences for each discovered feature
  # User preference = avg rating when feature=1 minus avg rating when feature=0
  user_preferences <- merged_data
  
  for(feature in feature_cols) {
    pref_col_name <- paste0(feature, "_preference")
    
    user_preferences <- user_preferences %>%
      dplyr::group_by(!!rlang::sym(user_col)) %>%
      dplyr::mutate(
        !!rlang::sym(pref_col_name) := mean(!!rlang::sym(rating_col)[!!rlang::sym(feature) == 1], na.rm = TRUE) - 
                                mean(!!rlang::sym(rating_col)[!!rlang::sym(feature) == 0], na.rm = TRUE)
      ) %>%
      dplyr::ungroup()
  }
  
  # Step 5: Get unique user preferences (remove duplicates, keep only preference columns)
  user_prefs_final <- user_preferences %>%
    dplyr::select(dplyr::all_of(user_col), dplyr::ends_with("_preference")) %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      dplyr::across(dplyr::ends_with("_preference"), 
             ~ifelse(is.na(.), 0, .))  # Replace NAs with 0
    )
  
  # Return preferences with metadata
  result <- list(
    user_preferences = user_prefs_final,
    feature_columns = feature_cols,
    title_profile = title_profile,
    word_frequencies = linguistic_result$word_frequencies,
    suffix_patterns = linguistic_result$suffix_patterns
  )
  
  return(result)
}

#' Compute User-Linguistic Compatibility Scores
#'
#' Calculate compatibility scores between users and linguistic features.
#' Compatibility = feature presence × user preference for that feature.
#' Enables personalized linguistic feature matching.
#'
#' @param data A data frame with user, string, and rating columns.
#' @param string_col Character. String column to analyze (default: "title").
#' @param id_col Character. Item ID column (default: "movieId").
#' @param user_col Character. User identifier column (default: "userId").
#' @param rating_col Character. Target variable column (default: "rating").
#' @param min_word_frequency Numeric. Minimum word frequency threshold (default: 5).
#'
#' @return A list containing:
#'   \describe{
#'     \item{compatibility}{Data frame with individual and combined compatibility scores}
#'     \item{feature_columns}{Character vector of discovered features}
#'     \item{match_columns}{Character vector of individual match columns}
#'     \item{title_profile}{Extracted linguistic profile}
#'     \item{user_preferences}{User preference data}
#'   }
#'
#' @examples
#' \dontrun{
#' compat <- compute_user_linguistic_compatibility(ratings, "title", "movieId", "userId")
#' }
#'
#' @export
compute_user_linguistic_compatibility <- function(data, string_col = "title", id_col = "movieId",
                                                  user_col = "userId", rating_col = "rating",
                                                  min_word_frequency = 5) {
  
  # Step 1: Extract linguistic profile
  linguistic_result <- extract_string_linguistic_profile(data, string_col, id_col, min_word_frequency)
  title_profile <- linguistic_result$profile
  
  # Step 2: Compute user preferences
  user_prefs_result <- compute_user_linguistic_preferences(data, string_col, id_col, 
                                                          user_col, rating_col, min_word_frequency)
  user_preferences <- user_prefs_result$user_preferences
  feature_cols <- user_prefs_result$feature_columns
  
  # Step 3: Merge all components
  merged_data <- data %>%
    dplyr::left_join(title_profile, by = id_col) %>%
    dplyr::left_join(user_preferences, by = user_col)
  
  # Step 4: Calculate compatibility as interaction effect for each feature
  # Compatibility = feature_presence × user_preference for that feature
  compatibility <- merged_data
  
  for(feature in feature_cols) {
    match_col_name <- paste0(feature, "_match")
    pref_col_name <- paste0(feature, "_preference")
    
    compatibility <- compatibility %>%
      dplyr::mutate(
        !!rlang::sym(match_col_name) := !!rlang::sym(feature) * !!rlang::sym(pref_col_name)
      )
  }
  
  # Step 5: Calculate combined compatibility score
  match_cols <- colnames(compatibility) %>%
    grep("_match$", ., value = TRUE)
  
  compatibility <- compatibility %>%
    dplyr::mutate(
      linguistic_compatibility_score = rowMeans(dplyr::select(., dplyr::all_of(match_cols)), na.rm = TRUE)
    ) %>%
    dplyr::select(dplyr::all_of(user_col), dplyr::all_of(id_col), dplyr::all_of(string_col), 
           dplyr::all_of(match_cols), linguistic_compatibility_score)
  
  # Return compatibility with metadata
  result <- list(
    compatibility = compatibility,
    feature_columns = feature_cols,
    match_columns = match_cols,
    title_profile = title_profile,
    user_preferences = user_preferences
  )
  
  return(result)
}

#' Compute Position Importance from Effects
#'
#' Calculate which position (prefix, infix, suffix) has the most important
#' effect on the target variable by comparing effect magnitudes.
#'
#' @param prefix_effects Data frame of prefix position effects.
#' @param infix_effects Data frame of infix position effects.
#' @param suffix_effects Data frame of suffix position effects.
#'
#' @return A data frame with position importance metrics including effect magnitude,
#'   max/min effects, importance rank, and percentage importance.
#'
#' @examples
#' \dontrun{
#' position_importance <- compute_position_importance(prefix_fx, infix_fx, suffix_fx)
#' }
#'
#' @export
compute_position_importance <- function(prefix_effects, infix_effects, suffix_effects) {
  
  # Calculate average effect magnitude for each position
  position_importance <- tibble::tibble(
    position = c("prefix", "infix", "suffix"),
    avg_effect_magnitude = c(
      mean(abs(prefix_effects$effect), na.rm = TRUE),
      mean(abs(infix_effects$effect), na.rm = TRUE),
      mean(abs(suffix_effects$effect), na.rm = TRUE)
    ),
    max_effect = c(
      max(prefix_effects$effect, na.rm = TRUE),
      max(infix_effects$effect, na.rm = TRUE),
      max(suffix_effects$effect, na.rm = TRUE)
    ),
    min_effect = c(
      min(prefix_effects$effect, na.rm = TRUE),
      min(infix_effects$effect, na.rm = TRUE),
      min(suffix_effects$effect, na.rm = TRUE)
    )
  ) %>%
    dplyr::mutate(
      importance_rank = rank(dplyr::desc(avg_effect_magnitude)),
      importance_pct = round(avg_effect_magnitude / sum(avg_effect_magnitude) * 100, 2)
    ) %>%
    dplyr::arrange(importance_rank)
  
  return(position_importance)
}

#' Summarize Linguistic Analysis Findings
#'
#' Generate a comprehensive summary of linguistic analysis results including
#' top features, user preference statistics, and position importance.
#'
#' @param global_effects_result Result from \code{compute_global_linguistic_effects()}.
#'   Can be either the full list or just the global_effects data frame.
#' @param user_preferences_result Result from \code{compute_user_linguistic_preferences()}.
#'   Can be either the full list or just the user_preferences data frame.
#' @param position_importance Optional. Data frame from \code{compute_position_importance()}.
#'
#' @return A list containing:
#'   \describe{
#'     \item{top_features}{Top 10 most predictive features}
#'     \item{user_pref_stats}{Summary statistics for user preferences}
#'     \item{feature_count}{Total number of features discovered}
#'     \item{unique_features}{Count of unique feature names}
#'     \item{position_importance}{Position importance metrics (if provided)}
#'   }
#'
#' @examples
#' \dontrun{
#' summary <- summarize_linguistic_analysis(effects, prefs)
#' }
#'
#' @export
summarize_linguistic_analysis <- function(global_effects_result, user_preferences_result,
                                          position_importance = NULL) {
  
  # Extract components (handle both old and new format)
  if(is.list(global_effects_result) && "global_effects" %in% names(global_effects_result)) {
    global_effects <- global_effects_result$global_effects
  } else {
    global_effects <- global_effects_result
  }
  
  if(is.list(user_preferences_result) && "user_preferences" %in% names(user_preferences_result)) {
    user_prefs <- user_preferences_result$user_preferences
  } else {
    user_prefs <- user_preferences_result
  }
  
  # Get preference columns (those ending with "_preference")
  pref_cols <- colnames(user_prefs) %>%
    grep("_preference$", ., value = TRUE)
  
  summary_report <- list(
    
    # Top predictive linguistic features (global)
    top_features = global_effects %>%
      dplyr::arrange(dplyr::desc(abs(effect))) %>%
      dplyr::slice(1:10) %>%
      dplyr::select(linguistic_feature, avg_rating, effect, count),
    
    # User preference statistics (DYNAMIC - based on discovered features)
    user_pref_stats = user_prefs %>%
      dplyr::select(dplyr::all_of(pref_cols)) %>%
      dplyr::summarise(dplyr::across(dplyr::everything(), 
                       list(mean = ~mean(., na.rm = TRUE),
                            sd = ~sd(., na.rm = TRUE),
                            min = ~min(., na.rm = TRUE),
                            max = ~max(., na.rm = TRUE)))) %>%
      tidyr::pivot_longer(dplyr::everything()) %>%
      tidyr::separate(name, into = c("feature", "statistic"), sep = "_(?=[^_]+$)"),
    
    # Feature summary
    feature_count = nrow(global_effects),
    unique_features = dplyr::n_distinct(global_effects$linguistic_feature),
    
    # Position importance (if provided)
    position_importance = position_importance
  )
  
  return(summary_report)
}
