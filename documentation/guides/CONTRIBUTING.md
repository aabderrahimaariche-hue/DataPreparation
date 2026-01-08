# Contributing to DataPreparation

Thank you for your interest in contributing to DataPreparation! This document provides guidelines for developers who want to contribute to the project.

## 📋 Table of Contents

1. [Getting Started](#getting-started)
2. [Development Setup](#development-setup)
3. [Making Changes](#making-changes)
4. [Code Style](#code-style)
5. [Testing](#testing)
6. [Submitting Changes](#submitting-changes)
7. [Developer Documentation](#developer-documentation)

## Getting Started

### Prerequisites

- **R** (version 4.0 or higher)
- **Git** for version control
- **GitHub account** for contributing

### Required R Packages

```r
install.packages(c("devtools", "roxygen2", "testthat", "dplyr", "stringr"))
```

## Development Setup

### 1. Fork and Clone the Repository

```powershell
# Clone your fork
git clone https://github.com/YOUR_USERNAME/DataPreparation.git
cd DataPreparation
```

### 2. Load Development Environment

```r
# In R console
setwd("path/to/DataPreparation")
devtools::load_all()  # Load all functions for development
```

### 3. Set Up Git Branches

```powershell
# Create a feature branch
git checkout -b feature/your-feature-name

# Keep your branch up to date
git fetch origin
git merge origin/main
```

## Making Changes

### Adding New Functions

1. **Create function in appropriate R file** (e.g., `R/01_na_handling.R`)
2. **Add roxygen2 documentation** above the function:
   ```r
   #' Function Title
   #'
   #' Detailed description of what the function does.
   #'
   #' @param data A data frame
   #' @param col Column name as string
   #'
   #' @return Transformed data frame
   #'
   #' @examples
   #' # Example usage
   #' result <- my_function(data, "col_name")
   #'
   #' @export
   my_function <- function(data, col) {
     # Function body
   }
   ```

3. **Generate documentation**:
   ```r
   roxygen2::roxygenise()
   ```

### Modifying Existing Functions

1. Update the function code
2. Update roxygen2 documentation if parameters changed
3. Regenerate documentation: `roxygen2::roxygenise()`
4. Test the changes thoroughly

## Code Style

### R Code Style Guide

- **Indentation**: 2 spaces
- **Line length**: Maximum 80 characters
- **Naming conventions**:
  - Functions: `snake_case` (e.g., `extract_year_from_string`)
  - Variables: `snake_case`
  - Constants: `UPPER_CASE`

### Function Structure

```r
#' Clear Title
#'
#' @param data Data frame
#' @param col Column name
#'
#' @return Result description
#'
#' @export
function_name <- function(data, col) {
  # Validate inputs
  if (!is.data.frame(data)) stop("data must be a data frame")
  if (!(col %in% colnames(data))) stop(paste("Column not found:", col))
  
  # Function logic
  result <- data %>%
    # operations
  
  # Return result
  result
}
```

## Testing

### Running Tests

```r
# Load and test individual function
devtools::load_all()
result <- my_function(test_data, "column")
```

### Manual Testing Workflow

```r
# 1. Load all functions
devtools::load_all()

# 2. Create test data
test_df <- data.frame(
  id = 1:5,
  value = c(1, 2, NA, 4, 5)
)

# 3. Test your function
result <- your_function(test_df, "value")

# 4. Verify results
head(result)
str(result)
```

## Submitting Changes

### Before Submitting

1. **Clean up your code**:
   ```r
   # Regenerate documentation
   roxygen2::roxygenise()
   
   # Check for errors
   devtools::check()
   ```

2. **Update DESCRIPTION** file if adding new dependencies:
   ```
   Imports:
     package_name (>= version)
   ```

3. **Test your changes**:
   ```r
   devtools::load_all()
   # Run manual tests
   ```

### Git Workflow

```powershell
# Stage your changes
git add .

# Commit with descriptive message
git commit -m "Add: new feature description

- Detailed change 1
- Detailed change 2"

# Push to your fork
git push origin feature/your-feature-name
```

### Create Pull Request

1. Go to GitHub repository
2. Click "Pull requests" tab
3. Click "New pull request"
4. Select your branch
5. Provide clear description of changes
6. Click "Create pull request"

## Developer Documentation

### Project Structure

```
DataPreparation/
├── R/                                # Source code
│   ├── 01_na_handling.R             # NA handling functions
│   ├── 02_numeric_features.R        # Numeric feature functions
│   ├── 03_timestamp_features.R      # Timestamp functions
│   ├── 04_string_features.R         # String feature functions
│   ├── 05_ngram_generation.R        # N-gram functions
│   ├── 06_position_extraction.R     # Position extraction functions
│   └── 07_linguistic_analysis.R     # Linguistic analysis functions
├── DESCRIPTION                       # Package metadata
├── NAMESPACE                         # Package exports
├── README.md                         # User documentation
└── CONTRIBUTING.md                   # This file
```

### Important Developer Files

These files are for development reference:

| File | Purpose |
|------|---------|
| `IMPLEMENTATION_GUIDE.md` | Detailed implementation notes |
| `BUILD_SUMMARY.md` | Build and compilation status |
| `STATUS_REPORT.md` | Current project status |
| `VERIFICATION.md` | Verification checklist |
| `generate_namespace.R` | Namespace generation utility |
| `verify_package.R` | Package verification script |

### Development Process

1. **Review current status**: Read `STATUS_REPORT.md`
2. **Check implementation details**: See `IMPLEMENTATION_GUIDE.md`
3. **Verify your changes**: Use `verify_package.R`
4. **Document updates**: Update relevant status files

## Questions or Need Help?

1. **Check existing issues** on GitHub
2. **Open a discussion** for questions
3. **Create an issue** for bugs or feature requests

## License

By contributing to DataPreparation, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to DataPreparation! 🎉**
