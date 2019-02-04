#Example:
#https://sshfunction.azurewebsites.net/api/SSH?computer=linuxdlafunctions.westeurope.cloudapp.azure.com&username=root&password=password1999&command=free
#
# POST method: $req
#$requestBody = Get-Content $req -Raw | ConvertFrom-Json
#$name = $requestBody.name

# GET method: each querystring parameter is its own variable
if ($req_query_computer) 
{
    $Computer = $req_query_computer
    $username = $req_query_username
    $password = $req_query_password
    $command  = $req_query_command
}

#$result = Get-Module -ListAvailable |Select-Object Name, Version, ModuleBase |Sort-Object -Property Name |Format-Table -wrap |Out-String
#Write-output `n$result
#Please use module https://github.com/EliteLoser/SSHSessions

#$Computer = "linuxtestfunctions.westeurope.cloudapp.azure.com"
#$username = "root"
#$password = "mypassword"
$secureStringPwd = ConvertTo-SecureString $password -AsPlainText -Force
$creds= New-Object System.Management.Automation.PSCredential ($username, $secureStringPwd)
#$command ="(wall 'Reboot in 5 sec!' ; sleep 5 ; sudo reboot )&"
#$command = "cat /etc/resolv.conf"
$sblock  = [Scriptblock]::Create($command)

New-SshSession -ComputerName $Computer -Credential $creds -Reconnect
$result=Get-SshSession|invoke-SSHCommand -ScriptBlock $sblock
#Get-SshSession|invoke-SSHCommand -ScriptBlock {$Using:command}
#$result=$result|ConvertTo-Html
#$result|Format-Hex
#$result.contains("`n")
#$result.contains("`r")
#$result=$result -replace "`r`n", '<br>'
$result=$result -replace '@{ComputerName=', '<h3>ComputerName='
$result=$result -replace '; Result=', '; Result={</h3>'
$result=$result -replace '; Error=', '<h3>Error='
$result=$result -replace '\x0a', '<br>'
#$result
get-SshSession|Remove-SshSession
$html = @"
<title>SSH Azure Function Runtime by Mariusz Ferdyn</title>
<h1>$($command)</h1>
<h2>$(Get-Date)</h2>
"@
$html=$html+"<body>"+$result+"</body>"
@{
    headers = @{ "content-type" = "text/html" }
    body    = $html
} | ConvertTo-Json > $res

#Out-File -Encoding Ascii -FilePath $res -inputObject "Wykonano o: $(get-date) komende: $command z wynikiem: $result"