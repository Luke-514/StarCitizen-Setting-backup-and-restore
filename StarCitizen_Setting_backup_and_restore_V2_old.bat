@echo off

echo --------------------------------------------------------------------------------------------------------------
echo �Ɛӎ���
echo �{�o�b�`�t�@�C���̎g�p�ɂ���Ĕ��������A�����Ȃ鑹�Q�ɑ΂��Ă���҂͈�؂̐ӔC�𕉂��܂���
echo.

echo ��� 
echo Luke514 Twitter:@rx_luke
echo --------------------------------------------------------------------------------------------------------------
echo.

SETLOCAL enabledelayedexpansion

SET /P CHK="����ݒ�̃o�b�N�A�b�v�A�����ǂ�������{���܂����H (backup/restore)"

if /i %CHK%==backup (
  SET MODE=�o�b�N�A�b�v
) else if /i %CHK%==b (
  SET MODE=�o�b�N�A�b�v
) else if /i %CHK%==restore (
  SET MODE=����
) else if /i %CHK%==r (
  SET MODE=����
) else (
  echo.
  echo �\�����Ȃ����������͂���܂���
  echo �����𒆎~���܂�
  echo.
  pause
  EXIT
)

SET /P CHK="LIVE��PTU�A�ǂ���̐ݒ��%MODE%���܂����H (live/ptu)"

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
  echo �\�����Ȃ����������͂���܂���
  echo �����𒆎~���܂�
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

SET /P CHK="%MODE%�����s���Ă���낵���ł����H (yes/no)"

if /i %CHK%==yes (goto CONTINUE)
if /i %CHK%==y (goto CONTINUE)

echo.
echo �\�����Ȃ����������͂���܂���
echo �����𒆎~���܂�
echo.
pause
exit

:CONTINUE
echo.

if /i %MODE%==�o�b�N�A�b�v (
  robocopy %STUSRDIR_M% .\BackupData\%PLYVER%\MappingProfile /r:1 /w:1 > nul
  if !errorlevel! leq 7 (
    echo ����v���t�@�C����.\BackupData\%PLYVER%�Ƀo�b�N�A�b�v���܂���
  ) else (
    echo ����v���t�@�C���̃o�b�N�A�b�v�Ɏ��s���܂���
  )
  robocopy %STUSRDIR_D% .\BackupData\%PLYVER%\CurrentSettting /r:1 /w:1 > nul
  if !errorlevel! leq 7 (
    echo �ݒ��.\BackupData\%PLYVER%�Ƀo�b�N�A�b�v���܂���
  ) else (
    echo �ݒ�̃o�b�N�A�b�v�Ɏ��s���܂���
  )
) else if /i %MODE%==���� (
  robocopy .\BackupData\%PLYVER%\MappingProfile %STUSRDIR_M% /r:1 /w:1 > nul
  if !errorlevel! leq 7 (
    echo ����v���t�@�C���𕜌����܂���
  ) else (
    echo ����v���t�@�C���̕����Ɏ��s���܂���
  )
  robocopy .\BackupData\%PLYVER%\CurrentSettting %STUSRDIR_D% /r:1 /w:1 > nul
  if !errorlevel! leq 7 (
    echo �ݒ�𕜌����܂���
  ) else (
    echo �ݒ�̕����Ɏ��s���܂���
  )
)

echo.
pause