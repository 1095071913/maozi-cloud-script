@echo off

setlocal enabledelayedexpansion

set "current_directory=%cd%"

set /p maozi_cloud_services_directory=<maozi-cloud-services-directory

cd !maozi_cloud_services_directory!

call !current_directory!\..\maozi-cloud-build-jar-utils.bat !current_directory!

endlocal

exit