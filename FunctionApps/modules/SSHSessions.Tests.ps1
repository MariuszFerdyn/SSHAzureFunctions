#requires -version 3
<# Pester 4.x tests for SSH-Sessions/SSHSessions. Joakim Borger Svendsen.
Svendsen Tech.
#>

Import-Module -Name Pester -ErrorAction Stop #-Verbose:$False 
$VerbosePreference = "SilentlyContinue"

#$ComputerName = "www.svendsentech.no"
$ComputerName = ""

Import-Module -Name SSHSessions -ErrorAction Stop #-Verbose:$False

if (-not (Get-Variable -Name PesterSSHSessionsCredentials -Scope Global -ErrorAction SilentlyContinue)) {
    Write-Warning -Message "You need to: `$Global:PesterSSHSessionsCredentials = Get-Credential # and to provide the SSH user credentials before running the tests (I know this sucks...)"
    exit
}

if ($ComputerName -eq "") {
    Write-Warning -Message "You need to assign a computer name to the `$ComputerName variable at the top of SSHSessions.Tests.ps1 (I know this sucks...)"
    exit
}

Describe SshSessions {

    It "New-SshSession creates a new SSH session successfully to the test target." {
        <#if (((Get-SshSession -ComputerName $ComputerName -ErrorAction SilentlyContinue 3> $null)).Connected -eq $True) {
            Write-Verbose -Message "Terminating existing SSH session to $ComputerName." -Verbose
            $Null = Remove-SshSession -ComputerName $ComputerName -ErrorAction SilentlyContinue
        }#>
        $Result = (New-SshSession -ComputerName $ComputerName -Verbose `
            -Credential $Global:PesterSSHSessionsCredentials -ErrorAction Stop) 4>&1
        $Result.Message | Should -Match "\[$([Regex]::Escape($ComputerName))\]\s*(?:Successfully connected|You are already connected)"
    }

    It "Invoke-SshCommand produces expected simple remote 'echo' test output." {
        $Result = Invoke-SshCommand -ComputerName $ComputerName -Quiet -Command "echo 'This is a test'" -ErrorAction Stop
        $Result[0].Result | Should -Be "This is a test"
    }
    
    It "Piping Get-SshSession to Invoke-SshCommand works." {
        $Result = Get-SshSession -ComputerName $ComputerName | Invoke-SshCommand -Quiet -Command "echo 'This is a test'" `
            -ErrorAction Stop
        $Result[0].Result | Should -Be "This is a test"
    }

    It "Remove-SshSession works." {
        $Result = (Remove-SshSession -ComputerName $ComputerName -ErrorAction SilentlyContinue -Verbose) 4>&1
        $Result.Message | Should -Match "\[$([Regex]::Escape($ComputerName))\] Now disconnected and disposed"
    }

    It "The -Reconnect parameter for New-SshSession works." {
        $Result = (New-SshSession -ComputerName $ComputerName -Verbose `
            -Credential $Global:PesterSSHSessionsCredentials -ErrorAction Stop) 4>&1
        $Result.Message | Should -Match "\[$([Regex]::Escape($ComputerName))\]\s*(?:Successfully connected|You are already connected)"
        $Result = (New-SshSession -ComputerName $ComputerName -Reconnect -Credential $Global:PesterSSHSessionsCredentials `
            -ErrorAction SilentlyContinue -Verbose) 4>&1
        $Result[2].Message | Should -Match "\[$([Regex]::Escape($ComputerName))\]\s*Successfully\s+connected"
    }

    Get-SshSession | Remove-SshSession

}
