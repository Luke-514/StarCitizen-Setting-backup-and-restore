@echo off

echo --------------------------------------------------------------------------------------------------------------
echo �Ɛӎ���
echo �{�o�b�`�t�@�C���̎g�p�ɂ���Ĕ��������A�����Ȃ鑹�Q�ɑ΂��Ă���҂͈�؂̐ӔC�𕉂��܂���
echo.

echo ��� 
echo Luke514 Twitter:@rx_luke Discord:Shadow514#0642
echo --------------------------------------------------------------------------------------------------------------
echo.

set /P CHK="����ݒ�̃o�b�N�A�b�v�A�����ǂ�������{���܂����H (backup/restore)"

if /i %CHK%==backup (
  set MODE=�o�b�N�A�b�v
) else if /i %CHK%==b (
  set MODE=�o�b�N�A�b�v
) else if /i %CHK%==restore (
  set MODE=����
) else if /i %CHK%==r (
  set MODE=����
) else (
  echo.
  echo �\�����Ȃ����������͂���܂���
  echo �����𒆎~���܂�
  echo.
  pause
  EXIT
)

set /P CHK="LIVE��PTU�A�ǂ���̐ݒ��%MODE%���܂����H (live/ptu)"

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
  echo �\�����Ȃ����������͂���܂���
  echo �����𒆎~���܂�
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
echo %MODE%�Ώۂ͈ȉ��ł�
echo.

if /i %MODE%==�o�b�N�A�b�v (
  %USRDIR_M% 2>nul
  %USRDIR_D% 2>nul
) else if /i %MODE%==���� (
  %RESDIR% 2>nul
)
if %errorlevel% neq 0 (
  echo.
  echo %MODE%�Ώۂ̃t�H���_�����݂��Ȃ����߁A�������I�����܂�
  echo.
  pause
  EXIT
)
echo.

set /P CHK="%MODE%�����s���Ă���낵���ł����H (yes/no)"

if /i %CHK%==yes (goto CONTINUE)
if /i %CHK%==y (goto CONTINUE)

echo.
echo �\�����Ȃ����������͂���܂���
echo �����𒆎~���܂�
echo.
pause
exit

:CONTINUE

if /i %MODE%==�o�b�N�A�b�v (
  robocopy %STUSRDIR_M% .\BackupData\%PLYVER%\MappingProfile /r:1 /w:1 > nul
  robocopy %STUSRDIR_D% .\BackupData\%PLYVER%\CurrentSettting /r:1 /w:1 > nul
  echo.
  echo �ݒ��.\BackupData\%PLYVER%�Ƀo�b�N�A�b�v���܂���
  echo.
) else if /i %MODE%==���� (
  robocopy .\BackupData\%PLYVER%\MappingProfile %STUSRDIR_M% /r:1 /w:1 > nul
  robocopy .\BackupData\%PLYVER%\CurrentSettting %STUSRDIR_D% /r:1 /w:1 > nul
  echo.
  echo �ݒ�𕜌����܂���
  echo.
)

pause