@echo off
chcp 65001 >nul
:: ===== push_auto.bat =====
:: 一键 add -> 带时间戳 commit -> push（无需输入）

where git >nul 2>nul || (echo [ERROR] 未检测到 Git；安装：https://git-scm.com/download/win & pause & exit /b 1)
git rev-parse --is-inside-work-tree >nul 2>nul || (echo [ERROR] 非 Git 仓库目录 & pause & exit /b 1)

for /f "delims=" %%i in ('git rev-parse --abbrev-ref HEAD') do set CURBR=%%i
for /f "tokens=1-4 delims=/-:. " %%a in ("%date% %time%") do set TS=%%a-%%b-%%c_%%d

echo 当前分支：%CURBR%
git pull --rebase origin %CURBR%
git add -A

git commit -m "auto: %TS%"
if errorlevel 1 (
  echo [INFO] 没有需要提交的改动或提交失败。
  pause
  exit /b 0
)

git push origin %CURBR%
if errorlevel 1 (
  echo [ERROR] 推送失败，请检查网络或权限（SSH Key/PAT）。
  pause
  exit /b 1
)

echo [DONE] %TS% 已推送到 origin/%CURBR%
pause
