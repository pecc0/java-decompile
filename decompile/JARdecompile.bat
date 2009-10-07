
for %%D in (%0) do set DIR=%%~dpD
for %%D in (%1) do set OUT=%%~dpnD
for %%D in (%1) do set EXT=%%~xD
if "%EXT%"==".class" (
	for %%D in (%1) do set OUT=%%~dpD
	for %%D in (%1) do set IN=%%~D
	goto l_class
)
dir /ad "%1"
echo %errorlevel%
if errorlevel 1 (
	%DIR%7za_zip.exe x -y -o"%OUT%" %1
) else (
	echo directory
	set OUT=%1_decompiled
	xcopy "%1" "%1_decompiled" /s /i
)
echo %OUT%
for /D /R "%OUT%" %%F in (*) do (
	%DIR%jad.exe -lnc -s .java -v -dead -o -d "%%F" "%%F\*.class" 
	del "%%F\*.class" 
)
%DIR%jad.exe -lnc -s .java -v -dead -o -d "%OUT%" "%OUT%\*.class" 
del "%OUT%\*.class" 
	
goto l_end

:l_class
for %%D in (%1) do %%~dD
cd %OUT%
%DIR%jad.exe -lnc -s .java -v -dead -o %1

:l_end
pause