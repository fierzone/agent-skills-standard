# Script to create 10 branches with commits and merge them
$ErrorActionPreference = "Stop"

# Configure git user if not set
git config user.name "Hoang Nguyen"
git config user.email "hoang@example.com"

Write-Host "=== Starting Git Workflow ===" -ForegroundColor Cyan

# Ensure we are in a clean state
git add .
git commit -m "Initial commit" 2>$null

# Step 1: Create main branch
Write-Host "`n[1/4] Setting up main branch..." -ForegroundColor Yellow
git checkout -b main 2>$null

# Step 2: Create develop branch
Write-Host "`n[2/4] Creating develop branch..." -ForegroundColor Yellow
git checkout -b develop 2>$null

# Step 3: Create 10 feature branches with commits
Write-Host "`n[3/4] Creating 10 feature branches..." -ForegroundColor Yellow

$features = @(
    @{n = "feature/skill-creator"; f = "README.md"; m = "Add Skill Creator documentation" },
    @{n = "feature/changelog-update"; f = "CHANGELOG.md"; m = "Update CHANGELOG with recent changes" },
    @{n = "feature/agents-config"; f = "AGENTS.md"; m = "Update agents configuration" },
    @{n = "feature/skillsrc-config"; f = ".skillsrc"; m = "Update skillsrc configuration" },
    @{n = "feature/package-update"; f = "package.json"; m = "Update package dependencies" },
    @{n = "feature/tsconfig-improve"; f = "tsconfig.json"; m = "Improve TypeScript configuration" },
    @{n = "feature/gitignore-update"; f = ".gitignore"; m = "Update gitignore rules" },
    @{n = "feature/markdown-lint"; f = ".markdownlint.json"; m = "Update markdown linting rules" },
    @{n = "feature/license-update"; f = "LICENSE"; m = "Update license information" },
    @{n = "feature/workspace-config"; f = "pnpm-workspace.yaml"; m = "Update workspace configuration" }
)

foreach ($item in $features) {
    $name = $item.n
    $file = $item.f
    $msg = $item.m
    
    Write-Host "  Creating branch: $name" -ForegroundColor Green
    
    # Create and checkout feature branch from develop
    git checkout develop
    git checkout -b $name
    
    # Make a small change to the file
    if (Test-Path $file) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content -Path $file -Value "`n# Updated: $timestamp"
    }
    
    # Commit the change
    git add $file
    git commit -m "$msg"
}

# Step 4: Merge all feature branches into develop
Write-Host "`n[4/4] Merging all branches..." -ForegroundColor Yellow
git checkout develop

foreach ($item in $features) {
    $name = $item.n
    Write-Host "    Merging $name..." -ForegroundColor Gray
    git merge $name --no-ff -m "Merge $name into develop"
}

# Merge develop into main
Write-Host "  Merging develop into main..." -ForegroundColor Green
git checkout main
git merge develop --no-ff -m "Merge develop into main"

Write-Host "`n=== Git Workflow Complete ===" -ForegroundColor Cyan
git branch
