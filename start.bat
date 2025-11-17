@echo off
TITLE AI Companion - Quick Start Script

echo ========================================
echo AI Companion - Quick Setup and Launch
echo ========================================

echo.
echo Checking if Python is installed...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Python is not installed or not in PATH.
    echo Please install Python 3.10 or higher and try again.
    pause
    exit /b 1
)

echo.
echo Checking if uv is installed...
uv --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing uv package manager...
    pip install uv
    if %errorlevel% neq 0 (
        echo Error: Failed to install uv. Please install it manually.
        pause
        exit /b 1
    )
)

echo.
echo Creating virtual environment...
uv venv >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Failed to create virtual environment.
    pause
    exit /b 1
)

echo.
echo Activating virtual environment...
call Scripts\activate.bat >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Failed to activate virtual environment.
    pause
    exit /b 1
)

echo.
echo Installing dependencies...
uv pip install -r requirements.txt >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Failed to install dependencies.
    pause
    exit /b 1
)

echo.
echo Checking if configuration file exists...
if not exist conf.yaml (
    echo Creating configuration file from template...
    copy config_templates\conf.default.yaml conf.yaml >nul
    if %errorlevel% neq 0 (
        echo Error: Failed to create configuration file.
        pause
        exit /b 1
    )
) else (
    echo Configuration file already exists.
)

echo.
echo Initializing submodules...
git submodule update --init --recursive >nul 2>&1
if %errorlevel% neq 0 (
    echo Warning: Failed to initialize submodules. Continuing anyway...
)

echo.
echo Starting AI Companion server...
echo ========================================
echo The server will start shortly. 
echo Press Ctrl+C to stop the server
echo ========================================
uv run run_server.py

pause