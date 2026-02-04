@echo off
SETLOCAL EnableDelayedExpansion

echo === Starting Git Workflow ===

:: Initial state
git add .
git commit -m "Initial commit" 2>nul

:: Main branch
echo [1/4] Setting up main branch...
git checkout -b main 2>nul
if %ERRORLEVEL% NEQ 0 git checkout main

:: Develop branch
echo [2/4] Creating develop branch...
git checkout -b develop 2>nul
if %ERRORLEVEL% NEQ 0 git checkout develop

:: Feature branches
echo [3/4] Creating 10 feature branches...

:: Array simulation in CMD
set "branches=feature/skill-creator feature/changelog-update feature/agents-config feature/skillsrc-config feature/package-update feature/tsconfig-improve feature/gitignore-update feature/markdown-lint feature/license-update feature/workspace-config"
set "files=README.md CHANGELOG.md AGENTS.md .skillsrc package.json tsconfig.json .gitignore .markdownlint.json LICENSE pnpm-workspace.yaml"
set "msgs=Add-Skill-Creator-documentation Update-CHANGELOG-with-recent-changes Update-agents-configuration Update-skillsrc-configuration Update-package-dependencies Improve-TypeScript-configuration Update-gitignore-rules Update-markdown-linting-rules Update-license-information Update-workspace-configuration"

set i=0
for %%b in (%branches%) do (
    set /a i+=1
    set "b_!i!=%%b"
)
set i=0
for %%f in (%files%) do (
    set /a i+=1
    set "f_!i!=%%f"
)
set i=0
for %%m in (%msgs%) do (
    set /a i+=1
    set "m_!i!=%%m"
)

for /L %%x in (1,1,10) do (
    set "name=!b_%%x!"
    set "file=!f_%%x!"
    set "msg=!m_%%x!"
    set "msg=!msg:-= !"
    
    echo   Creating branch: !name!
    git checkout develop
    git checkout -b !name! 2>nul
    if !ERRORLEVEL! NEQ 0 git checkout !name!
    
    echo # Updated: %DATE% %TIME% >> !file!
    git add !file!
    git commit -m "!msg!"
)

:: Merge
echo [4/4] Merging all branches...
git checkout develop

for /L %%x in (1,1,10) do (
    set "name=!b_%%x!"
    echo     Merging !name!...
    git merge !name! --no-ff -m "Merge !name! into develop"
)

:: Merge to main
echo   Merging develop into main...
git checkout main
git merge develop --no-ff -m "Merge develop into main"

echo === Git Workflow Complete ===
git branch
