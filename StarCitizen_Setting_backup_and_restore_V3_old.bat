@echo off

echo --------------------------------------------------------------------------------------------------------------
echo 免責事項
echo 本バッチファイルの使用によって発生した、いかなる損害に対しても作者は一切の責任を負いません
echo.

echo 作者 
echo Luke514 Twitter:@rx_luke Discord:Shadow514#0642
echo --------------------------------------------------------------------------------------------------------------
echo.

set /P CHK="操作設定のバックアップ、復元どちらを実施しますか？ (backup/restore)"

if /i %CHK%==backup (
  set MODE=バックアップ
) else if /i %CHK%==b (
  set MODE=バックアップ
) else if /i %CHK%==restore (
  set MODE=復元
) else if /i %CHK%==r (
  set MODE=復元
) else (
  echo.
  echo 予期しない文字が入力されました
  echo 処理を中止します
  echo.
  pause
  EXIT
)

set /P CHK="LIVEかPTU、どちらの設定を%MODE%しますか？ (live/ptu)"

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
  echo 予期しない文字が入力されました
  echo 処理を中止します
  echo.
  pause
  EXIT
)

for /f "tokens=*" %%i in ('findstr /v "{ ( ) js: Error libraryFolder ." %APPDATA%\rsilauncher\log.log ^| findstr "\\"') do set LIBPATH=%%~i
set LIBPATH=%LIBPATH:\\=\%
set USRDIR_M=dir /s /b "%LIBPATH%\StarCitizen\%PLYVER%\USER\Client\0\Controls\Mappings\*.xml"*
set USRDIR_D=dir /s /b "%LIBPATH%\StarCitizen\%PLYVER%\USER\Client\0\Profiles\default\*.xml"*
for %%i in ("%LIBPATH%") do set STUSRPATH=%%~si
set STUSRDIR_M=%STUSRPATH%\StarCitizen\%PLYVER%\USER\Client\0\Controls\Mappings
set STUSRDIR_D=%STUSRPATH%\StarCitizen\%PLYVER%\USER\Client\0\Profiles\default
set RESDIR=dir /s /b ".\BackupData\%PLYVER%\*.xml"*

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

set /P CHK="%MODE%を実行してもよろしいですか？ (yes/no)"

if /i %CHK%==yes (goto CONTINUE)
if /i %CHK%==y (goto CONTINUE)

echo.
echo 予期しない文字が入力されました
echo 処理を中止します
echo.
pause
exit

:CONTINUE

if /i %MODE%==バックアップ (
  robocopy %STUSRDIR_M% .\BackupData\%PLYVER%\MappingProfile /r:1 /w:1 > nul
  robocopy %STUSRDIR_D% .\BackupData\%PLYVER%\CurrentSettting /r:1 /w:1 > nul
  echo.
  echo 設定を.\BackupData\%PLYVER%にバックアップしました
  echo.
) else if /i %MODE%==復元 (
  robocopy .\BackupData\%PLYVER%\MappingProfile %STUSRDIR_M% /r:1 /w:1 > nul
  robocopy .\BackupData\%PLYVER%\CurrentSettting %STUSRDIR_D% /r:1 /w:1 > nul
  echo.
  echo 設定を復元しました
  echo.
)

pause