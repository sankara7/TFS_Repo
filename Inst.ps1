$log = "c:\log.txt"
# Get the credentials of the machine
$username = "user123"
$pass = ConvertTo-SecureString "testpass@123" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($username, $pass)

function download
{
try
{
# Below block will downloaded ManageEngine installer from official site into tmp path if not downloaded already
if (!(Test-Path c:\ManageEngine64.exe)) {

$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://www.manageengine.com/cgi-bin/download_exe?id=1-918","C:\ManageEngine64.exe")
Add-Content -Path $Log -value "ManageEngine Downloaded"
}

# Below block will download the installation paramater setup file from Github
if (!(Test-Path C:\set.iss)) {
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://raw.githubusercontent.com/sankara7/TFS_Repo/master/set.iss","C:\set.iss")
Add-Content -Path $Log -value "Setup file Downloaded"
}
}
catch
{

}
}
function install
{
try
{
Set-ExecutionPolicy Unrestricted -Force
"Policy set" | out-file c:/log.txt -append
"creating ps file" | out-file c:/log.txt -append
Start-Process c:\ManageEngine.exe -ArgumentList '/quiet /a /s /sms /f1c:\set.iss /f2c:\log1.txt' -Wait -Credential $cred
"Executing pse file" | out-file c:/log.txt -append
#Invoke-Command -Credential $cred -ComputerName myVM -Command {c:\installAPM.ps1}
"instal completed" | out-file c:/log.txt -append

}
catch
{
}
}

Add-Content -Path $Log -value "Downloads Started"
$status = download
if($?)
{
Add-Content -Path $Log -value "Install Started"
install
Add-Content -Path $Log -value "Install Finshed"
}





