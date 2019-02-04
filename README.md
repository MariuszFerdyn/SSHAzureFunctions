# SSHAzureFunctions
SSH over PowerShell Azure Functions

## About

This repository contains complete solution that allows you to issue any commands via SSH requesting GET Azure Functions.

## Disclaimer

This software comes with no warranty of any kind.

## Solution

Tis solutions contains from two parts FunctionApps (Azure Functions) and StaticWebSite (Storage account Static website).

## FunctionApps

This files should be applied to FunctionApps v1.0 (PowerShell). It contains project https://github.com/EliteLoser/SSHSessions.

This function can be launch by:
https://your_functions_name.azurewebsites.net/api/SSH?computer=google.com&username=root&password=password&command=reboot

If FunctionApps will exist in your private network you can use it in internal addresses e.g. 192.168.0.1.

You can connect also to Windows Servers/Clients after installing SSH: https://rzetelnekursy.pl/ssh-demon-for-windows-jak-zainstalowac-demona-ssh-na-windows/

## StaticWebSite

This page can be deployed an any hosting e.g. Azure Storage account with Static website feature.

It was created by https://mobirise.com/ software (Create awesome mobile-friendly websites! No coding and free).

You can also add 

## To Do

Everyone is welcome to develop this solution.

1. Deploy script (DevOps)
2. Nice Return Page (FunctionApps)
3. Improve "$sblock  = [Scriptblock]::Create($command)" functionality that breaks some Linux commands  
4. Create Mobile Client (Cordova)
5. Convert from PowerShell to .Net Core (FunctionApps)

## Demo
You can test it using this page: https://spages.z6.web.core.windows.net/
