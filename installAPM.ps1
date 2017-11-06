# Below command will start the installation process of ManageEngine application manager in slient mode using param.iss paramter file
try
{
"install started" | out-file c:/log.txt -append
Start-Job -Name ijob -ScriptBlock {
Set-ExecutionPolicy Unrestricted -Force
Start-Process c:\ManageEngine.exe -ArgumentList '/quiet /a /s /sms /f1c:\setup.iss' -Wait
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