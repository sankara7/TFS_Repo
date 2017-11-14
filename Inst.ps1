Configuration Install 
{ 
    try
{

"install started" | out-file c:/log.txt -append
Invoke-Command -Command {Start-Process c:\ManageEngine.exe -ArgumentList '/quiet /a /s /sms /f1c:\setup.iss /f2c:\log.txt'  -Wait}
"install completed" | out-file  c:/log.txt -append

}
catch
{
    $ErrorMessage = $_.Exception.Message
    $Time=Get-Date
"This script failed at $Time and error message was $ErrorMessage" | out-file c:\log.txt -append
} 

} 
