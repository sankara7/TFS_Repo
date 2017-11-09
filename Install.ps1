Set-ExecutionPolicy Unrestricted -Force
try
{
# Below block will downloaded ManageEngine installer from official site into tmp path if not downloaded already
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
Start-Job -Name ijob -ScriptBlock {
Set-ExecutionPolicy Unrestricted -Force
"Sleep time started" | out-file c:/log.txt -append
"Start-Process c:\ManageEngine.exe -ArgumentList '/quiet /a /s /sms /f1c:\setup.iss /f2c:\log.txt'  -Wait" | out-file c:/installAPM.ps1 -append
Invoke-Command -Command {c:\installAPM.ps1}
Start-Sleep -s 120
"Sleep time ended" | out-file c:/log.txt -append
Wait-Job -Name ijob
Receive-Job -Name ijob | out-file c:/log.txt -append 
"instal completed" | out-file c:/log.txt -append
}

}
Catch
{
$ErrorMessage = $_.Exception.Message
$Time=Get-Date
"This script failed at $Time and error message was $ErrorMessage" | out-file c:\log.txt -append
}
