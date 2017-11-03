
# Below block will downloaded ManageEngine installer from official site into tmp path if not downloaded already
if (!(Test-Path c:\ManageEngine.exe)) {

$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://www.manageengine.com/cgi-bin/download_exe?id=1-918","C:\ManageEngine.exe")

}

# Below block will download the installation paramater setup file from Github
if (!(Test-Path C:\setup.iss)) {
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://raw.githubusercontent.com/sankara7/TFS_Repo/master/setup.iss","C:\setup.iss")
}

# Below command will start the installation process of ManageEngine application manager in slient mode using param.iss paramter file
Set-ExecutionPolicy Unrestricted -Force
Start-Process c:\ManageEngine.exe -ArgumentList '/quiet /a /s /sms /f1c:\setup.iss' -Wait





