@echo off

set /p sitename="Enter the site Name (as displayed in IIS): " %=%
set /p siteurl="Enter the site Host Header(the site url): " %=%
set /p siteip="Enter the site IP Address (ip address or *): " %=%
set /p siteprotocol="Enter the site Protocol (http, https, etc): " %=%
set /p siteport="Enter the site Port (80, 443): " %=%

appcmd set site /site.name:"%sitename%" /+bindings.[protocol='%siteprotocol%',bindingInformation='%siteip%:%siteport%:%siteurl%']

pause
