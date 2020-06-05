@ECHO OFF
SETLOCAL
TITLE pdf2img

::init
::set defaults in case settings.bat missing
SET imagetype=png
SET inputdir=input
SET outputdir=output
SET quality=mid

::load settings file
IF EXIST bin\settings.bat CALL bin\settings.bat

::create input and output directories if they are missing
IF NOT EXIST %inputdir% MKDIR %inputdir%
IF NOT EXIST %outputdir% MKDIR %outputdir%

::set the quality, default to mid
SET density=75x75
IF %quality%==mid SET density=95x95
IF %quality%==high SET density=125x125
IF %quality%==ultra SET density=300x300

ECHO ==========================================
ECHO               Running pdf2img
ECHO ==========================================
ECHO.
ECHO ================ Settings ================
ECHO Quality:       %quality% (%density%)
ECHO Input folder:  %inputdir%
ECHO Output folder: %outputdir%
ECHO Image Format:  %imagetype%
ECHO.

::prompt user to continue as all files in output will be deleted
SET /P AREYOUSURE=Continuing will empty the %output% folder. Are you sure (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

ECHO Deleteing all files in folder:%outputdir%
DEL /Q %outputdir%\*.*

ECHO. 
ECHO. 

SETLOCAL ENABLEDELAYEDEXPANSION
SET /a count=1
ECHO ================ Running =================
FOR /f "delims=|" %%f IN ('DIR /b %inputdir%\*.pdf') DO (
	SET inputfilename=%%f
	CALL SET outputfilename=!!inputfilename:.pdf=.%imagetype%!!
	SET inputfile=!inputdir!\!inputfilename!
	SET outputfile=!outputdir!\!outputfilename!
	SET converter=bin\image_mgk\convert.exe
	ECHO Converting file [!count!]: !inputfile!
	CALL !converter! -density !density! -units pixelsperinch !inputfile! -strip -background white -alpha remove -alpha off -antialias -compress none !outputfile!
	SET /a count+=1
)
ECHO ==========================================

ECHO. 
ECHO. 

ECHO Conversion completed

PAUSE
:END
ENDLOCAL