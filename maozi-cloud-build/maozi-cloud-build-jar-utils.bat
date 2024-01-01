@echo off

set array_index=0

set array[0]=

set buildFiles=

if not exist ".git" (

  for /d %%i in ("%cd%\*") do (

      cd %%~nxi

      call !current_directory!\..\maozi-cloud-scan-file-utils.bat !array! !buildFiles! !array_index!

      cd ../

  )

) else (
  call !current_directory!\..\maozi-cloud-scan-file-utils.bat !array! !buildFiles! !array_index!
)

if !array_index! NEQ 0 (

  for /l %%N in (1,1,!array_index!) do (

    set "file=!array[%%N]!"

    if "!file:~0,11!" EQU "maozi-cloud" (

      set "idx=0"

      for /L %%A in (1,1,100) do (

        set "pathName=!file:~%%A,3!"

        if "!pathName!" EQU "src" (

          if "!idx!"=="0" (

            set "idx=%%A"

            set "file=!file:~0,%%A!"

          )

        )

      )

      if "!idx!"=="0" (

        set "file=!file:\=/!"

        for %%F in ("!file!") do (
          set "file=!file:%%~nxF=!"
        )

      )

      echo !buildFiles! | findstr /C:"!file!" > nul
      if !errorlevel! neq 0 (
        set "buildFiles=!buildFiles!,!file!"
      )

    ) else (

      if not exist ".git" (

        for /f "delims=/" %%a in ("!file!") do set "file=%%a"

        echo !buildFiles! | findstr /C:"!file!" > nul
        if !errorlevel! neq 0 (
          set "buildFiles=!buildFiles!,!file!"
        )

      ) else (

        set "buildFiles=."

        goto :exitloop

      )

    )

  )

)

:exitloop
if not "!buildFiles!"=="" (

  start /B /wait cmd /c mvn clean -T 8C -Dmaven.compile.fork=true -Dmaven.test.skip=true

  start /B /wait cmd /c mvn install -T 8C -Dmaven.compile.fork=true -Dmaven.test.skip=true -pl !buildFiles! -amd

  for %%A in ("%cd%") do set "current_build_directory=%%~nxA"

  if not "!current_build_directory!"=="maozi-cloud-parent" (

    for /r %%F in (*.jar) do (

        set "file_path=%%~dpF"

        set "file_path=!file_path:~0,-8!"

        for %%I in ("!file_path!") do set "service_name=%%~nxI"

        set "image_directory=!current_directory!\..\..\maozi-cloud-image\!current_build_directory!-image"

        set "docker_directory=!current_directory!\..\..\maozi-cloud-docker\!current_build_directory!-docker"

        for %%F in ("!image_directory!\*") do (

          if "!service_name!-image"=="%%~nxF" (

            echo copy "!file_path!\target\!service_name!.jar" "!image_directory!\" >> !image_directory!/!service_name!-build-docker.bat

            echo cd !image_directory!\ >> !image_directory!/!service_name!-build-docker.bat

            echo docker buildx build -f !image_directory!\!service_name!-image -t !service_name!:laster . >> !image_directory!/!service_name!-build-docker.bat

            echo docker-compose -f !docker_directory!\docker-compose.yml up -d !service_name! >> !image_directory!/!service_name!-build-docker.bat

            echo del "!image_directory!\!service_name!.jar" >> !image_directory!/!service_name!-build-docker.bat

            echo del "!image_directory!\!service_name!-build-docker.bat" >> !image_directory!/!service_name!-build-docker.bat

            start /B cmd /c !image_directory!\!service_name!-build-docker.bat

          )

        )

    )

  )

)