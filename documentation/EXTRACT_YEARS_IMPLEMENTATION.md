# New Function: extract_years_from_string()

**Created**: January 17, 2026  
**Module**: Module 3 - Timestamp Features  
**Status**: ✅ Complete & Tested

---

## Overview

`extract_years_from_string()` is an advanced enhancement to the existing `extract_year_from_string()` function. While `extract_year_from_string()` extracts only the **first** 4-digit year found, `extract_years_from_string()` extracts **ALL** years with their **position information**.

---

## What Makes It Special

The function implements a sophisticated iterative algorithm that:

1. **Finds** the first 4-digit year in the text
2. **Records** both the year value AND its starting position (1-based index)
3. **Removes** the extracted year from the working text
4. **Repeats** until no more years are found
5. **Returns** all results in a structured list-column format

---

## Function Signature

```r
extract_years_from_string(
  data = NULL,
  string_col = "string",
  dataset_name = NULL
)
```

**Parameters:**
- `data`: Optional data frame
- `string_col`: Column name containing strings to analyze
- `dataset_name`: Optional registered dataset name (for focus mode)

**Returns:**
- Original data frame with new `years_list` column
- Each element is a data frame with columns: `year`, `position`

---

## Example Usage

### Basic Example

```r
library(DataPreparation)

data <- data.frame(
  id = 1:3,
  text = c(
    "i was born in 2001",
    "between 1995 and 2005",
    "from 2010 to 2020 then 2022"
  )
)

result <- extract_years_from_string(data, "text")
result$years_list[[1]]
#   year position
# 1 2001       15

result$years_list[[2]]
#   year position
# 1 1995        9
# 2 2005       18

result$years_list[[3]]
#   year position
# 1 2010        6
# 2 2020       14
# 3 2022       24
```

---

## Key Features

✅ **Extracts ALL occurrences** - Not just the first year
✅ **Position tracking** - Know WHERE in the text each year appears
✅ **Handles multiple years** - Works with any number of years per string
✅ **List-column output** - Clean, analyzable structure
✅ **Focus mode compatible** - Works with dataset registry
✅ **Complete documentation** - Full roxygen2 docs with examples
✅ **Edge cases handled** - NA, NULL, no-years-found all work correctly

---

## Algorithm Details

### Position Calculation

The function accurately tracks positions using:

```
Position = characters_processed_before + match_position_in_remaining_text
```

For example, in `"from 2010 to 2020 then 2022"`:
- First year `2010` at position 6 (0-indexed: 5)
- After removing 2010, working text becomes `"from EXTRACTEDYEAR to 2020 then 2022"`
- Position tracking ensures subsequent years have correct absolute positions

### Iteration Logic

```
Original: "from 2010 to 2020 then 2022"
          ^^^^^^ ^^^^                      <- Find "2010" at position 6
          Extract: 2010, Record position: 6

Remaining: "from EXTRACTEDYEAR to 2020 then 2022"
                                 ^^^^ <- Find "2020" at position 14 (adjusted)
Extract: 2020, Record position: 14

Remaining: "from EXTRACTEDYEAR to EXTRACTEDYEAR then 2022"
                                                ^^^^ <- Find "2022" at position 24
Extract: 2022, Record position: 24

Result: (2010, 6), (2020, 14), (2022, 24)
```

---

## Use Cases

### 1. Timeline Analysis
Extract all dates mentioned in historical documents to create timelines

### 2. Version Tracking
Find all version years in software documentation
```
"Version 2.1 (2020) based on 2018 spec, released 2022"
→ Years: 2020, 2018, 2022
```

### 3. Range Detection
Find start and end years in year ranges
```
"1995-2005" → Finds both 1995 and 2005
```

### 4. Publication Tracking
Extract all dates from publication records
```
"Submitted 2020, accepted 2021, published 2022"
→ All three years captured with positions
```

### 5. Multi-Project Analysis
Track years across multiple projects in descriptions

---

## Performance Characteristics

| Aspect | Details |
|--------|---------|
| **Time Complexity** | O(n × m) - n rows, m avg years per row |
| **Space Complexity** | O(n × m) - stores all year/position pairs |
| **String Operations** | 3-4 regex operations per year found |
| **Large Datasets** | Consider filtering results before further processing |

---

## Comparison: extract_year_from_string() vs extract_years_from_string()

| Feature | extract_year_from_string | extract_years_from_string |
|---------|--------------------------|--------------------------|
| **Function Type** | Simple extraction | Advanced extraction |
| **Years Extracted** | First only | All found |
| **Position Info** | No | Yes |
| **Return Format** | Single column | List-column |
| **Use Case** | Single year per record | Multiple years per record |
| **Performance** | O(n) | O(n × m) |

---

## Integration with Other Functions

### Combining with tidyr::unnest()

```r
library(tidyr)

# Flatten the list-column for analysis
expanded <- result %>%
  tidyr::unnest(years_list, keep_empty = TRUE)

# Now each year is a separate row
# Enables grouped analysis
```

### Combining with dplyr

```r
library(dplyr)

result %>%
  mutate(num_years = sapply(years_list, nrow)) %>%
  filter(num_years > 1)  # Records with multiple years
```

---

## Files Created/Modified

| File | Change | Details |
|------|--------|---------|
| R/03_timestamp_features.R | Added | New function implementation |
| man/extract_years_from_string.Rd | Created | Auto-generated roxygen2 docs |
| examples/EXTRACT_YEARS_EXAMPLES.R | Created | 8 comprehensive examples |

---

## Testing & Validation

✅ **Tested Examples**:
- Simple: "i was born in 2001" → Position 15 (correct)
- Multiple: "from 2010 to 2020 then 2022" → All positions verified
- None: "no years here" → Empty data frame (correct)
- Edge: NA/NULL values → Handled gracefully

✅ **Position Accuracy Verified**:
```r
phrase <- "from 2010 to 2020 then 2022"
substring(phrase, 6, 9)   # "2010" ✓
substring(phrase, 14, 17) # "2020" ✓
substring(phrase, 24, 27) # "2022" ✓
```

---

## Documentation

Complete documentation available in:
- **Function docs**: `?extract_years_from_string` (after loading package)
- **Examples**: `examples/EXTRACT_YEARS_EXAMPLES.R` (8 detailed examples)
- **Roxygen2 file**: `man/extract_years_from_string.Rd`

---

## Future Enhancements (Optional)

Potential improvements for future versions:
- Extract other date formats (MM-DD-YYYY, DD/MM/YY, etc.)
- Filter by year range (e.g., only 1900-2100)
- Extract month-year combinations
- Support for relative dates ("last year", "2 years ago")

---

## Summary

The `extract_years_from_string()` function successfully addresses your requirement to:
- ✅ Extract **ALL** years from a string (not just the first)
- ✅ Track the **position/index** of each year
- ✅ Handle **multiple years** in a single string
- ✅ Return a **structured, analyzable** result format
- ✅ Integrate seamlessly with DataPreparation **ecosystem**

The implementation uses an elegant iterative algorithm that maintains position accuracy throughout the extraction process, making it suitable for complex text analysis and timeline reconstruction tasks.

---

**Created**: January 17, 2026  
**Status**: Production Ready ✅  
**Module**: Module 3 (Timestamp Features)  
**Total Functions**: Module 3 now has 3 functions
