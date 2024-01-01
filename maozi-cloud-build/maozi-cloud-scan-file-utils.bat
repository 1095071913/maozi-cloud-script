@echo off

set "current_build_directory=%cd%"
for %%A in ("%current_build_directory%") do set "current_build_directory=%%~nxA"

set "current_env_build_directory=!current_build_directory!-env"

for /f "tokens=*" %%i in ('git branch --show-current') do (
  set current_branch=%%i
)

if not exist "!current_directory!\!current_env_build_directory!" (
  mkdir !current_directory!\!current_env_build_directory!
)

if exist !current_directory!\!current_env_build_directory!\CURRENT_BRANCH (

    set /p file_branch=<!current_directory!/!current_env_build_directory!/CURRENT_BRANCH

    set file_branch=!file_branch: =!

    if not "!current_branch!"=="!file_branch!" (

      echo %current_branch% > !current_directory!/!current_env_build_directory!/CURRENT_BRANCH

      for /f "delims=" %%a in ('git rev-parse HEAD') do echo %%a > !current_directory!/!current_env_build_directory!/CURRENT_SHA

      if exist "..\pom.xml" (
        set "buildFiles=!buildFiles!,!current_build_directory!"
      ) else (
        set "buildFiles=."
      )

    ) else (

      for /f "delims=" %%a in ('git rev-parse HEAD') do set current_sha=%%a

      set /p file_sha=<!current_directory!/!current_env_build_directory!/CURRENT_SHA

      set file_sha=!file_sha: =!

      if not "!current_sha!"=="!file_sha!" (

        echo !current_sha! > !current_directory!/!current_env_build_directory!/CURRENT_SHA

        for /F "tokens=*" %%A in ('git diff --name-only !file_sha!..!current_sha!') do (

            set /a array_index+=1

            if exist "..\pom.xml" (
                set "array[!array_index!]=!current_build_directory!/%%A"
            ) else (
                set "array[!array_index!]=%%A"
            )

        )

      )

    )

) else (

  echo !current_branch! > !current_directory!/!current_env_build_directory!/CURRENT_BRANCH

  for /f "delims=" %%a in ('git rev-parse HEAD') do echo %%a > !current_directory!/!current_env_build_directory!/CURRENT_SHA

  if exist "..\pom.xml" (
    set "buildFiles=!buildFiles!,!current_build_directory!"
  ) else (
    set "buildFiles=."
  )

)