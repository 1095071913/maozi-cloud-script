@echo off

setlocal enabledelayedexpansion

set "current_directory=%cd%"

set /p maozi_cloud_basics_directory=<maozi-cloud-basics-directory

cd !maozi_cloud_basics_directory!

call !current_directory!\..\maozi-cloud-build-jar-utils.bat !current_directory!

endlocal

exit