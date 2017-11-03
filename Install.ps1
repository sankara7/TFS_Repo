
# Below block will downloaded ManageEngine installer from official site into tmp path if not downloaded already
if (!(Test-Path c:\ManageEngine.exe)) {

$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://www.manageengine.com/cgi-bin/download_exe?id=1-918","C:\ManageEngine.exe")

}

# Below block will download the installation paramater setup file from Github
if (!(Test-Path C:\set.iss)) {
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://github.com/sankara7/TFS_Repo/blob/ARM_Branch/set.iss","C:\set.iss")
}

# Below command will start the installation process of ManageEngine application manager in slient mode using param.iss paramter file

Start-Process "C:\ManageEngine.exe" -ArgumentList "/s /a /s /sms /f1c:\set.iss" -Wait -NoNewWindow




