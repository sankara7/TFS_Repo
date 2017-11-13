#################################################################################################################################
#  Name        : Configure-WinRM.ps1                                                                                            #
#                                                                                                                               #
#  Description : Configures the WinRM on a local machine                                                                        #
#                                                                                                                               #
#  Arguments   : HostName, specifies the FQDN of machine or domain                                                           #
#################################################################################################################################

param
(
    [string] $hostname
)

#################################################################################################################################
#                                             Helper Functions                                                                  #
#################################################################################################################################

function Delete-WinRMListener
{
    $config = Winrm enumerate winrm/config/listener
    foreach($conf in $config)
    {
        if($conf.Contains("HTTPS"))
        {
            Write-Verbose "HTTPS is already configured. Deleting the exisiting configuration."

            winrm delete winrm/config/Listener?Address=*+Transport=HTTPS
            break
        }
    }
}

function Configure-WinRMHttpsListener
{
    param([string] $hostname,
          [string] $port)

    # Delete the WinRM Https listener if it is already configured
    Delete-WinRMListener

    # Create a test certificate
    $thumbprint = (Get-ChildItem cert:\LocalMachine\My | Where-Object { $_.Subject -eq "CN=" + $hostname } | Select-Object -Last 1).Thumbprint
    if(-not $thumbprint)
    {
        .\makecert -r -pe -n CN=$hostname -b 01/01/2012 -e 01/01/2022 -eku 1.3.6.1.5.5.7.3.1 -ss my -sr localmachine -sky exchange -sp "Microsoft RSA SChannel Cryptographic Provider" -sy 12
        $thumbprint=(Get-ChildItem cert:\Localmachine\my | Where-Object { $_.Subject -eq "CN=" + $hostname } | Select-Object -Last 1).Thumbprint

        if(-not $thumbprint)
        {
            throw "Failed to create the test certificate."
        }
    }    

    cmd.exe /c .\winrmconf.cmd $hostname $thumbprint
}

function Add-FirewallException
{
    param([string] $port)

    # Delete an exisitng rule
    netsh advfirewall firewall delete rule name="Windows Remote Management (HTTPS-In)" dir=in protocol=TCP localport=$port

    # Add a new firewall rule
    netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" dir=in action=allow protocol=TCP localport=$port
}


#################################################################################################################################
#                                              Configure WinRM                                                                  #
#################################################################################################################################

$winrmHttpsPort=5986

# Configure https listener
Configure-WinRMHttpsListener $hostname $port

# Add firewall exception
Add-FirewallException -port $winrmHttpsPort

#################################################################################################################################
#################################################################################################################################


$winrmPort = '5986'

# Get the credentials of the machine
$username = "MyWindowsVM\user123"
$pass = ConvertTo-SecureString "testpass@123" -AsPlainText –Force
$cred = New-Object -TypeName pscredential –ArgumentList $username, $pass

# Connect to the machine
# $soptions = New-PSSessionOption -SkipCACheck
# Enter-PSSession -ComputerName $hostName -Port $winrmPort -Credential $cred -SessionOption $soptions -UseSSL

Set-ExecutionPolicy Unrestricted -Force
try
{
# Below block will downloaded ManageEngine installer from official site into tmp path if not downloaded already
"Starting the script execution" | out-file c:/log.txt -append
"download exe started" | out-file c:/log.txt -append
Start-Job -Name job1 -ScriptBlock {
if (!(Test-Path c:\ManageEngine.exe)) {

$WebClient1 = New-Object System.Net.WebClient
$WebClient1.DownloadFile("https://www.manageengine.com/cgi-bin/download_exe?id=1-918","C:\ManageEngine.exe")
Start-Sleep -s 90
}
}
Wait-Job -Name job1
Receive-Job -Name job1 | out-file c:/log.txt -append 
"download exe completed" | out-file c:/log.txt -append

# Below block will download the installation paramater setup file from Github
"download param started" | out-file c:/log.txt -append
Start-Job -Name job2 -ScriptBlock {
if (!(Test-Path C:\setup.iss)) {
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://raw.githubusercontent.com/sankara7/TFS_Repo/master/setup.iss","C:\setup.iss")
}
}
Wait-Job -Name job2
Receive-Job -Name job2 | out-file c:/log.txt -append 
"download param completed" | out-file c:/log.txt -append
}
Catch
{
$ErrorMessage = $_.Exception.Message
$Time=Get-Date
"This script failed at $Time and error message was $ErrorMessage" | out-file c:\log.txt -append
}

# Below command will start the installation process of ManageEngine application manager in slient mode using param.iss paramter file
try
{
"install started" | out-file c:/log.txt -append
Invoke-Command -Command {Start-Process c:\ManageEngine.exe -ArgumentList '/quiet /a /s /sms /f1c:\setup.iss /f2c:\log.txt'  -Wait} -Credential $cred
}
catch
{
    $ErrorMessage = $_.Exception.Message
    $Time=Get-Date
"This script failed at $Time and error message was $ErrorMessage" | out-file c:\log.txt -append
}
write-host "invoke installation completed" | out-file c:\log.txt -append


