
# Below block will downloaded ManageEngine installer from official site into tmp path if not downloaded already
Start-Job -Name job1 -ScriptBlock {
if (!(Test-Path c:\ManageEngine.exe)) {

$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://www.manageengine.com/cgi-bin/download_exe?id=1-918","C:\ManageEngine.exe")

}
}
Wait-Job -Name job1

# Below block will download the installation paramater setup file from Github
Start-Job -Name job2 -ScriptBlock {
if (!(Test-Path C:\setup.iss)) {
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://raw.githubusercontent.com/sankara7/TFS_Repo/master/setup.iss","C:\setup.iss")
}
}
Wait-Job -Name job2

# Below command will start the installation process of ManageEngine application manager in slient mode using param.iss paramter file

Start-Job -Name job3 -ScriptBlock {
try
{
Set-ExecutionPolicy Unrestricted -Force
Start-Process c:\ManageEngine.exe -ArgumentList '/quiet /a /s /sms /f1c:\setup.iss' -Wait
}
Catch
{
$ErrorMessage = $_.Exception.Message
$Time=Get-Date
"This script failed at $Time and error message was $ErrorMessage" | out-file c:\log.txt -append
}
}
Wait-Job -Name job3
