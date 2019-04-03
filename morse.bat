@echo off
:: HELS Launch Script (HELS2)
:: Copyright (C) 2016 HES-SO Valais Wallis / HEI

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
::	 18.0216 : guo :
::	   * UPDATE : new server paths
::   17.0220 : guo :
::     * added call of HEUS file to update lab files
::   17.0217 : guo :
::     * first release

:: ----------------------------------------------------------------------------
::
SETLOCAL EnableExtensions EnableDelayedExpansion
set VERSION=18.0216
set NAME=HELS Launch Script (HELS2) v.%VERSION%
echo %NAME%
echo.

:: ----------------------------------------------------------------------------
:: Get parameters
:: local path
set BASE_DIR=%CD%
:: file name of this script without extension
set DESIGN_NAME=%~n0

:: ----------------------------------------------------------------------------
::
:: update lab files
echo Update SEm_labs files
echo.
call HEUS_SEm_labs.bat

:: ----------------------------------------------------------------------------
:: Find HEI Launch Script (HELS)
:: check at libs folder beside project folder, as used for standalone projects
set HELS=%BASE_DIR%\..\libs\scripts\HELS.bat
if not exist !HELS! (
  :: check at libs folder one level above project folder, as used on eda svn
  set HELS=%BASE_DIR%\..\..\libs\scripts\HELS.bat
  if not exist !HELS! (
    :: check on server, as used for ET labs
    set HELS=R:\ETE\ElN_8215\Labs\Libraries\scripts\HELS.bat
    if not exist !HELS! (
      :: check on server, as used for SI labs
      set HELS=R:\SYND\Ele_2131\ELN\Labs\Libraries\scripts\HELS.bat
      if not exist !HELS! (
        echo ERROR: No valid HELS found: please verify your project setup.
        pause
        exit
      )
    )
  )
)

echo Call %HELS% for project %DESIGN_NAME% at %BASE_DIR%
echo.
call %HELS% %BASE_DIR% %DESIGN_NAME%

:: ----------------------------------------------------------------------------
:: QUIT
echo.
echo Thanks for using %NAME%!
echo.
::pause

ENDLOCAL
