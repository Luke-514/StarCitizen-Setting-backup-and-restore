@echo off

echo --------------------------------------------------------------------------------------------------------------
echo Disclaimer
echo Use this batch file at your own risk.
echo.

echo Creator
echo Luke514 Twitter:@rx_luke
echo --------------------------------------------------------------------------------------------------------------
echo.

SETLOCAL enabledelayedexpansion

set /P CHK="Do you want to backup or restore your settings? (backup/restore)"

if /i %CHK%==backup (
  set MODE=Backup
) else if /i %CHK%==b (
  set MODE=Backup
) else if /i %CHK%==restore (
  set MODE=Restore
) else if /i %CHK%==r (
  set MODE=Restore
) else (
  echo.
  echo An unexpected character was entered.
  echo Abort process.
  echo.
  pause
  EXIT
)

set /P CHK="Which setting do you want to %MODE%, LIVE or PTU? (live/ptu)"

if /i %CHK%==live (
  set PLYVER=LIVE
) else if /i %CHK%==l (
  set PLYVER=LIVE
) else if /i %CHK%==ptu (
  set PLYVER=PTU
) else if /i %CHK%==p (
  set PLYVER=PTU
) else (
  echo.
  echo An unexpected character was entered.
  echo Abort process.
  echo.
  pause
  EXIT
)

for /f "tokens=*" %%i in ('findstr /v "{ ( ) js: Error libraryFolder ." %APPDATA%\rsilauncher\logs\log.log ^| findstr "\\"') do set LIBPATH=%%~i
set LIBPATH=%LIBPATH:\\=\%
set USRDIR_M=dir /s /b "%LIBPATH%\StarCitizen\%PLYVER%\USER\Client\0\Controls\Mappings\*.xml"*
set USRDIR_D=dir /s /b "%LIBPATH%\StarCitizen\%PLYVER%\USER\Client\0\Profiles\default\*.xml"*
for %%i in ("%LIBPATH%") do set STUSRPATH=%%~si
set STUSRDIR_M=%STUSRPATH%\StarCitizen\%PLYVER%\USER\Client\0\Controls\Mappings
set STUSRDIR_D=%STUSRPATH%\StarCitizen\%PLYVER%\USER\Client\0\Profiles\default
set RESDIR=dir /s /b ".\BackupData\%PLYVER%\*.xml"*

echo.
echo %MODE% targets are
echo.

if /i %MODE%==Backup (
  %USRDIR_M% 2>nul
  %USRDIR_D% 2>nul
) else if /i %MODE%==Restore (
  %RESDIR% 2>nul
)
if %errorlevel% neq 0 (
  echo.
  echo MODE% process terminates because the target folder does not exist.
  echo.
  pause
  EXIT
)
echo.

set /P CHK="Are you sure you want to run %MODE%? (yes/no)"

if /i %CHK%==yes (goto CONTINUE)
if /i %CHK%==y (goto CONTINUE)

echo.
echo Abort process.
echo.
pause
exit

:CONTINUE
echo.

if /i %MODE%==Backup (
  robocopy %STUSRDIR_M% .\BackupData\%PLYVER%\MappingProfile /r:1 /w:1 > nul
  if !errorlevel! leq 7 (
    echo The operation profile has been backed up to .\BackupData\%PLYVER%\MappingProfile
  ) else (
    echo Backup of the operating profile failed.
  )
  robocopy %STUSRDIR_D% .\BackupData\%PLYVER%\CurrentSettting /r:1 /w:1 > nul
  if !errorlevel! leq 7 (
    echo Configuration is backed up to .\BackupData\%PLYVER%\CurrentSettting
  ) else (
    echo Configuration backup failed.
  )
) else if /i %MODE%==Restore (
  robocopy .\BackupData\%PLYVER%\MappingProfile %STUSRDIR_M% /r:1 /w:1 > nul
  if !errorlevel! leq 7 (
    echo Operating profile restored.
  ) else (
    echo Failed to restore operating profile.
  )
  robocopy .\BackupData\%PLYVER%\CurrentSettting %STUSRDIR_D% /r:1 /w:1 > nul
  if !errorlevel! leq 7 (
    echo Settings restored.
  ) else (
    echo Failed to restore settings.
  )
)

echo.
pause