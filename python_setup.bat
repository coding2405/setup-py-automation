@echo off
setlocal

:: Set the version of Python to install
set PYTHON_VERSION=3.11.5
set PYTHON_INSTALLER=python-%PYTHON_VERSION%-amd64.exe

:: Set the download URL
set DOWNLOAD_URL=https://www.python.org/ftp/python/%PYTHON_VERSION%/%PYTHON_INSTALLER%

:: Check if Python is already installed
where python >nul 2>&1
if %errorlevel% == 0 (
    echo Python is already installed.
    goto end
)

:: Download Python installer
echo Downloading Python %PYTHON_VERSION%...
powershell -Command "Invoke-WebRequest -Uri %DOWNLOAD_URL% -OutFile %PYTHON_INSTALLER%"
if %errorlevel% neq 0 (
    echo Failed to download Python installer.
    exit /b
)

:: Install Python
echo Installing Python...
start /wait %PYTHON_INSTALLER% /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
if %errorlevel% neq 0 (
    echo Failed to install Python.
    exit /b
)

:: Clean up the installer
del %PYTHON_INSTALLER%

:: Verify installation
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo Python installation failed.
    exit /b
)

:: Set the virtual environment name
set VENV_NAME=myenv

:: Create a virtual environment
echo Creating virtual environment...
python -m venv %VENV_NAME%
if %errorlevel% neq 0 (
    echo Failed to create virtual environment.
    exit /b
)

:: Activate the virtual environment
call %VENV_NAME%\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo Failed to activate the virtual environment.
    exit /b
)

echo Python %PYTHON_VERSION% installed successfully.
echo Virtual environment "%VENV_NAME%" created and activated.
echo You can now run your Python scripts.
echo To deactivate the virtual environment, type: deactivate

:end
endlocal
pause
