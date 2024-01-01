@echo off

setlocal enabledelayedexpansion

set "current_directory=%cd%"

set /p maozi_cloud_parent_directory=<maozi-cloud-parent-directory

cd !maozi_cloud_parent_directory!

call !current_directory!\..\maozi-cloud-build-jar-utils.bat !current_directory!

endlocal

exit