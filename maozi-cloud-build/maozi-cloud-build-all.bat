@echo off

cd maozi-cloud-parent-build

start /B /wait cmd /c maozi-cloud-parent-build.bat

cd ../maozi-cloud-basics-build

start /B cmd /c maozi-cloud-basics-build.bat

cd ../maozi-cloud-services-build

start /B cmd /c maozi-cloud-services-build.bat

exit