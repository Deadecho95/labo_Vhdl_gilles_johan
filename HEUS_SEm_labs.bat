@echo off
:: HEI Update Script (HEUS)
:: Copyright (C) 2017 HES-SO Valais Wallis / HEI

:: This program is free software: you can redistribute it and/or modify
:: it under the terms of the GNU General Public License as published by
:: the Free Software Foundation, either version 3 of the License, or
:: (at your option) any later version.
:: This program is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
:: GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License
:: along with this program.  If not, see <http://www.gnu.org/licenses/>.

::  Authors:
::    guo: [Oliver A. Gubler](oliver.gubler@hevs.ch)
:: Changelog:
::   18.0216 : guo :
::     * UPDATE : new server path
::   17.0926 : guo :
::     * NEW : base dir can be passed as parameter
::	 17.0919 : guo :
::	   * UPDATE: new server path
::   17.0404 : guo :
::     * NEW : overwrite older files => update files from sever
::   17.0220 : guo :
::     * first release

:: ----------------------------------------------------------------------------
::
SETLOCAL EnableExtensions EnableDelayedExpansion
set VERSION=18.0216_SEm_labs
set NAME=HEI Update Script (HEUS) v.%VERSION%
echo %NAME%
echo.

:: ----------------------------------------------------------------------------
:: Get parameters
set BASE_DIR=%~1
:: local path
if "%BASE_DIR%"=="" (
  set BASE_DIR=%CD%
)
:: set and verify server path
set SERVER_DIR=R:\SYND\SEm_225\3_Labos\Labos_cof\SEm_labs\
if not exist !SERVER_DIR!\ (
  echo ERROR: No valid server path found: please verify your SERVER_DIR settings.
  pause
  exit
)
echo Found Server at !SERVER_DIR!.
echo.

:: ----------------------------------------------------------------------------
:: Copy no overwrite
::   Robocopy <https://ss64.com/nt/robocopy.html>
::     /XO : eXclude Older - if destination file exists and is the same date
::           or newer than the source - don't bother to overwrite it.
::     /XC : eXclude Changed files
::     /XN : eXclude Newer files
::robocopy %SERVER_DIR% %BASE_DIR% /E /XO /XC /XN

:: ----------------------------------------------------------------------------
:: Copy and overwrite older destination files
::   Robocopy <https://ss64.com/nt/robocopy.html>
::     /XO : eXclude Older - if destination file exists and is the same date
::           or newer than the source - don't bother to overwrite it.
robocopy %SERVER_DIR% %BASE_DIR% /E /XO

:: ----------------------------------------------------------------------------
:: QUIT
echo.
echo Thanks for using %NAME%!
::pause

ENDLOCAL
