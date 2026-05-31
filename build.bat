@echo off
if "%~1"=="" (
    lune run Build bundle header=Build/Header.luau ci-mode=true
) else (
    lune run Build bundle header=Build/Header.luau ci-mode=true game=%~1
)
