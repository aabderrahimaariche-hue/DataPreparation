# Publishing DataPreparation to GitHub

## ✅ Quick Summary

Get your package on GitHub in 5 minutes with these steps.

---

## 🔧 Step-by-Step Guide

### Step 1: Initialize Git (Windows PowerShell)

```powershell
# Navigate to package folder
cd "c:\Users\aaric\projects\HARDVARD-DATA-SCIENCE--CAPSTONE-\DataPreparation"

# Initialize git repository
git init

# Add all files
git add .

# Make first commit
git commit -m "Initial commit: DataPreparation v1.0.0 - Production ready"
```

**Expected output:**
```
[main (root-commit) ...] Initial commit
 15 files changed, ...
```

---

### Step 2: Create GitHub Repository (Web Browser)

1. Open https://github.com/new
2. **Repository name**: `DataPreparation`
3. **Description**: "General-Purpose Data Preparation and Feature Engineering Library"
4. **Visibility**: Public (required for install_github)
5. **Initialize with README**: ❌ NO (we have one)
6. **Initialize with .gitignore**: ❌ NO (we have one)
7. Click **Create repository**

**You'll see this page after:**
```
Quick setup — if you've done this kind of thing before

or HTTPS Clone button with URL like:
https://github.com/aabderrahimaariche-hue/DataPreparation.git
```

---

### Step 3: Push to GitHub (PowerShell)

Copy the URL from Step 2 and run:

```powershell
cd "c:\Users\aaric\projects\HARDVARD-DATA-SCIENCE--CAPSTONE-\DataPreparation"

# Add GitHub as remote (replace URL)
git remote add origin https://github.com/aabderrahimaariche-hue/DataPreparation.git

# Verify remote was added
git remote -v

# Push to GitHub
git push -u origin main
```

**First time push may ask for credentials:**
- Username: your GitHub username
- Password: your GitHub password (or Personal Access Token)

**Expected output:**
```
Counting objects: 15, done.
...
To https://github.com/aabderrahimaariche-hue/DataPreparation.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

---

### Step 4: Verify on GitHub

1. Open https://github.com/aabderrahimaariche-hue/DataPreparation
2. You should see all your files and folders
3. README.md should display as the main page

---

### Step 5: Install from GitHub

Now you can install from anywhere:

```r
# Install from GitHub
devtools::install_github("aabderrahimaariche-hue/DataPreparation")

# Load the package
library(DataPreparation)

# Use it!
clean_data <- remove_na_columns(my_data, "column")
```

---

## 🔑 GitHub Authentication

### If You Get Auth Errors

**Option 1: Use PAT (Recommended)**

```r
# In R console:
usethis::create_github_token()

# This opens a browser to create a Personal Access Token:
# - Scopes: repo, user, workflow (already selected)
# - Expiration: 90 days
# - Click "Generate token"
# - Copy the token

# Back in R, store the token:
gitcreds::gitcreds_set()

# Paste your token when prompted
# R will securely store it for future use
```

**Option 2: GitHub CLI**

```powershell
# Install GitHub CLI: https://cli.github.com/
gh auth login

# Follow prompts:
# - Choose HTTPS
# - Paste or create auth token
```

---

## 📦 After Publishing to GitHub

### Installation Options

**For you and your team:**
```r
devtools::install_github("aabderrahimaariche-hue/DataPreparation")
```

**For public use (add to README):**
```r
# Install
devtools::install_github("aabderrahimaariche-hue/DataPreparation")

# Load and use
library(DataPreparation)
```

### Creating Releases

Releases create version tags on GitHub:

```powershell
# Tag current commit as v1.0.0
git tag v1.0.0

# Push tag to GitHub
git push origin v1.0.0
```

Then on GitHub:
- Go to Releases tab
- Click "Create a release"
- Select tag: v1.0.0
- Add description of what's new
- Click "Publish release"

**Now users can:**
```r
devtools::install_github("aabderrahimaariche-hue/DataPreparation@v1.0.0")
```

---

## 🔄 Updating on GitHub

When you make changes:

```powershell
# Make changes to files
# ...

# Commit changes
git add .
git commit -m "Description of changes"

# Push to GitHub
git push
```

---

## 🎯 Next Steps After Publishing

### 1. Share with Team
```
Share URL: https://github.com/aabderrahimaariche-hue/DataPreparation
```

### 2. Archive on Zenodo (Optional, for Academic Citation)

```
1. Go to https://zenodo.org
2. Sign in with GitHub
3. Find your DataPreparation repo
4. Click "ON" to connect it
5. Create a release on GitHub (v1.0.0)
6. Zenodo auto-creates archive with DOI
```

### 3. Add to README

```markdown
## Installation

# From GitHub:
devtools::install_github("aabderrahimaariche-hue/DataPreparation")

# Then load:
library(DataPreparation)
```

---

## ✅ Checklist

- [ ] Step 1: Initialize git locally
- [ ] Step 2: Create GitHub repository
- [ ] Step 3: Push code to GitHub
- [ ] Step 4: Verify files on GitHub
- [ ] Step 5: Test installation with `devtools::install_github()`
- [ ] Optional: Create v1.0.0 release
- [ ] Optional: Archive on Zenodo

---

## 🚀 Quick Command Reference

```powershell
# All in one block (after creating GitHub repo):

cd "c:\Users\aaric\projects\HARDVARD-DATA-SCIENCE--CAPSTONE-\DataPreparation"
git init
git add .
git commit -m "Initial commit: DataPreparation v1.0.0"
git remote add origin https://github.com/aabderrahimaariche-hue/DataPreparation.git
git branch -M main
git push -u origin main

# Then test:
```

```r
# In R:
devtools::install_github("aabderrahimaariche-hue/DataPreparation")
library(DataPreparation)
```

---

## 🆘 Troubleshooting

### "fatal: not a git repository"
```powershell
# Make sure you're in the right folder:
cd "c:\Users\aaric\projects\HARDVARD-DATA-SCIENCE--CAPSTONE-\DataPreparation"
pwd  # Shows current path
```

### "fatal: remote origin already exists"
```powershell
# Remove existing remote:
git remote remove origin

# Then add again:
git remote add origin https://github.com/aabderrahimaariche-hue/DataPreparation.git
```

### Authentication failed
```r
# Clear stored credentials and redo:
gitcreds::gitcreds_delete()
gitcreds::gitcreds_set()
```

### install_github says "does not exist"
- Make sure GitHub repo is **Public**
- Make sure you're using correct username/repo name
- Wait a minute if you just created it

---

## ✨ That's It!

You now have your professional R package on GitHub, ready to install with:

```r
devtools::install_github("aabderrahimaariche-hue/DataPreparation")
```

🎉 **Share the link with anyone who needs the package!**
