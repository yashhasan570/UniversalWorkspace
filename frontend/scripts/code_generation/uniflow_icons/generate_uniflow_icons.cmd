@echo off

echo 'Generating uniflow icon files'

REM Store the current working directory
set "original_dir=%CD%"

REM Change the current working directory to the script's location
cd /d "%~dp0"

cd ..\..\..\universalworkspace_flutter

REM copy the resources/translations folder to
REM   the universalworkspace_flutter/assets/translation directory
echo Copying resources/uniflow_icons to universalworkspace_flutter/assets/uniflow_icons
xcopy /E /Y /I ..\resources\uniflow_icons assets\uniflow_icons

REM call flutter packages pub get

echo Generating UniflowSvg class
call dart run uniflow_svg

echo Done generating icon files.

REM Return to the original directory
cd /d "%original_dir%"
