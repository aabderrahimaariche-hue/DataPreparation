# 🚀 Load from GitHub - Quick Start

## 5-Minute Setup

### 1️⃣ Initialize Git (Run in PowerShell)

```powershell
cd "c:\Users\aaric\projects\HARDVARD-DATA-SCIENCE--CAPSTONE-\DataPreparation"
git init
git add .
git commit -m "Initial commit: DataPreparation v1.0.0"
```

### 2️⃣ Create GitHub Repo (Web Browser)

1. Go to https://github.com/new
2. Name: **DataPreparation**
3. Visibility: **Public**
4. Click **Create repository**

### 3️⃣ Push to GitHub (Run in PowerShell)

```powershell
# Copy HTTPS URL from GitHub (Step 2)
# Replace aabderrahimaariche-hue with your actual GitHub username

git remote add origin https://github.com/aabderrahimaariche-hue/DataPreparation.git
git branch -M main
git push -u origin main
```

### 4️⃣ Load in R

Once pushed, install from anywhere:

```r
# Install from GitHub
devtools::install_github("aabderrahimaariche-hue/DataPreparation")

# Load it
library(DataPreparation)

# Use all 44 functions!
data_clean <- remove_na_columns(df, "column")
```

---

## 📚 Detailed Guide

See: `GITHUB_SETUP.md` in this folder for complete step-by-step instructions

---

## 🎯 What You'll Have

```
GitHub: https://github.com/aabderrahimaariche-hue/DataPreparation
Install: devtools::install_github("aabderrahimaariche-hue/DataPreparation")
```

Anyone can then install with one command! 🎉
