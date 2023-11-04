@echo off

echo --------------------------------------------------------------------------------------------------------------
echo 免責事項
echo 本バッチファイルの使用によって発生した、いかなる損害に対しても作者は一切の責任を負いません
echo.

echo 作者 
echo Luke514 Twitter:@rx_luke
echo --------------------------------------------------------------------------------------------------------------
echo.

SETLOCAL enabledelayedexpansion

SET /P CHK="操作設定のバックアップ、復元どちらを実施しますか？ (backup/restore)"

if /i %CHK%==backup (
  SET MODE=バックアップ
) else if /i %CHK%==b (
  SET MODE=バックアップ
) else if /i %CHK%==restore (
  SET MODE=復元
) else if /i %CHK%==r (
  SET MODE=復元
) else (
  echo.
  echo 予期しない文字が入力されました
  echo 処理を中止します
  echo.
  pause
  EXIT
)

SET /P CHK="LIVEかPTU、どちらの設定を%MODE%しますか？ (live/ptu)"

if /i %CHK%==live (
  SET PLYVER=LIVE
) else if /i %CHK%==l (
  SET PLYVER=LIVE
) else if /i %CHK%==ptu (
  SET PLYVER=PTU
) else if /i %CHK%==p (
  SET PLYVER=PTU
) else (
  echo.
  echo 予期しない文字が入力されました
  echo 処理を中止します
  echo.
  pause
  EXIT
)

for /f "tokens=*" %%i in ('findstr /v "{ ( ) js: Error libraryFolder ." %APPDATA%\rsilauncher\logs\log.log ^| findstr "\\"') do SET LIBPATH=%%~i
SET LIBPATH=%LIBPATH:\\=\%
SET USRDIR_M=dir /s /b "%LIBPATH%\StarCitizen\%PLYVER%\USER\Client\0\Controls\Mappings\*.xml"*
SET USRDIR_D=dir /s /b "%LIBPATH%\StarCitizen\%PLYVER%\USER\Client\0\Profiles\default\*.xml"*
for %%i in ("%LIBPATH%") do SET STUSRPATH=%%~si
SET STUSRDIR_M=%STUSRPATH%\StarCitizen\%PLYVER%\USER\Client\0\Controls\Mappings
SET STUSRDIR_D=%STUSRPATH%\StarCitizen\%PLYVER%\USER\Client\0\Profiles\default
SET RESDIR=dir /s /b ".\BackupData\%PLYVER%\*.xml"*

echo.
echo %MODE%対象は以下です
echo.

if /i %MODE%==バックアップ (
  %USRDIR_M% 2>nul
  %USRDIR_D% 2>nul
) else if /i %MODE%==復元 (
  %RESDIR% 2>nul
)
if %errorlevel% neq 0 (
  echo.
  echo %MODE%対象のフォルダが存在しないため、処理を終了します
  echo.
  pause
  EXIT
)
echo.

SET /P CHK="%MODE%を実行してもよろしいですか？ (yes/no)"

if /i %CHK%==yes (goto CONTINUE)
if /i %CHK%==y (goto CONTINUE)

echo.
echo 予期しない文字が入力されました
echo 処理を中止します
echo.
pause
exit

:CONTINUE
echo.

if /i %MODE%==バックアップ (
  robocopy %STUSRDIR_M% .\BackupData\%PLYVER%\MappingProfile /r:1 /w:1 > nul
  if !errorlevel! leq 7 (
    echo 操作プロファイルを.\BackupData\%PLYVER%にバックアップしました
  ) else (
    echo 操作プロファイルのバックアップに失敗しました
  )
  robocopy %STUSRDIR_D% .\BackupData\%PLYVER%\CurrentSettting /r:1 /w:1 > nul
  if !errorlevel! leq 7 (
    echo 設定を.\BackupData\%PLYVER%にバックアップしました
  ) else (
    echo 設定のバックアップに失敗しました
  )
) else if /i %MODE%==復元 (
  robocopy .\BackupData\%PLYVER%\MappingProfile %STUSRDIR_M% /r:1 /w:1 > nul
  if !errorlevel! leq 7 (
    echo 操作プロファイルを復元しました
  ) else (
    echo 操作プロファイルの復元に失敗しました
  )
  robocopy .\BackupData\%PLYVER%\CurrentSettting %STUSRDIR_D% /r:1 /w:1 > nul
  if !errorlevel! leq 7 (
    echo 設定を復元しました
  ) else (
    echo 設定の復元に失敗しました
  )
)

echo.
pause