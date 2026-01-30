@echo off


echo Hello, nice to see you again! :)
echo.

pause


tasm /zi %1.asm

set errorany=0
IF ERRORLEVEL 1 set errorany=1

if %errorany%==0 tlink /v %1.obj %1
if %errorany%==0 td %1

if %errorany%==1 echo There are some errors :)




