##! RUN AS ADMINISTRATOR !## 
# Initial Setup - Requirement 

##* Functions *##
function TestChoco
{ 
    # Check OS
    If ((Get-WMIObject win32_operatingsystem).name -like "Microsoft Windows 10 *"){
        $OS="1"
    }
    # Check PS Version > 3
    if ($PSVersionTable.PSVersion.Major -ge "3"){
        $PSVer="1"
    }
    # Check .Net Version > 4.5
    if ((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release -ge 378389 -eq "True"){
        $NetVer="1"
    }
$ReturnValue = $OS -and $PSVer -and $NetVer
return ($ReturnValue)
} 


##* Test Choco requirement and if ok install it *##
If (TestChoco -eq "1")
{
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

##* Install Puppet Bolt *##
Write-Output 'Y' | choco install puppet-bolt 
refreshenv
Install-Module PuppetBolt -Confirm:$false -Force
if (Get-InstalledModule -Name "PuppetBolt")
{
    [System.Windows.Forms.MessageBox]::Show("Puppet is installed")
}

exit



