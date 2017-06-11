@echo off

echo ############################################
echo      #                               #
echo      # Starting Build Process        #
echo      # Please wait for completion... #
echo      #                               #
echo ############################################

Setlocal EnableDelayedExpansion

set compile_only=false
if "%1" EQU "compile_only" set compile_only=true
if "%1" EQU "zip_only" goto :zip_only

set "compile_files=MyBot.run,MyBot.run.Watchdog,MyBot.run.Wmi"
set "compile_ext=_stripped.au3,.exe"

if !compile_only! NEQ true (
	for %%i in (%compile_files%) do (
		for %%j in (%compile_ext%) do (
			set "file=%%i%%j"
			If Exist "!file!" (
				echo Deleting !file!
				del "!file!"
				If Exist "!file!" (
					echo Error deleting !file!... STOP BUILD!!!
					pause
					exit /b 2
				)
			)
		)
	)
)
set "src=%cd%\"

rem retry compiling
:retry
for %%i in (%compile_files%) do (
	set "file=%%i"
	rem if !compile_only! NEQ true "build\au3check.exe" "%src%!file!.au3"
	if not exist "%src%!file!_stripped.au3" (
		"build\au3Stripper\Au3Stripper.exe" "%src%!file!.au3" 
		"build\au3check.exe" "%src%!file!_stripped.au3"
	)
	echo Compiling !file!.exe
	"build\aut2exe\aut2exe.exe" /in "%src%!file!_stripped.au3" /nopack /comp 2

	If Not Exist "!file!.exe" (
		echo Compile error... retry?
		pause
		goto :retry
	)
)

:zip_only
set "zip=MyBot.run.zip"
Setlocal DisableDelayedExpansion
if %compile_only% NEQ true (
	If Exist "%zip%" (
		echo Deleting %zip%
		del "%zip%"
	)
	echo Creating %zip%
	"build\7z.exe" a -x!*.7z -x!*.zip -xr!BackUp -x!.git* -x!Profiles "-x!OLD CODE" -x!build.bat -x!build -x!build\* -x!Zombies -x!Zombies\* -x!SkippedZombies -x!SkippedZombies\* -x!lib\ImgLocDebugData -x!lib\ImgLocDebugData\* -x!*debug.txt -x!lib\imglocdebug.txt -r "%zip%" *
)
pause