
# Below block will downloaded ManageEngine installer from official site into tmp path if not downloaded already
if (!(Test-Path c:\tmp\ManageEngine32.exe)) {

$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://www.manageengine.com/cgi-bin/download_exe?id=1-33","C:\tmp\ManageEngine32.exe")

}

# Below block will download the installation paramater setup file from Github
if (!(Test-Path C:\tmp\set.iss)) {
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://raw.githubusercontent.com/sankara7/TFS_Repo/ARM_Branch/set.iss","C:\tmp\set.iss")
}

# Below command will start the installation process of ManageEngine application manager in slient mode using param.iss paramter file

Start-Process "C:\tmp\ManageEngine32.exe" -ArgumentList "/s /a /s /sms /f1c:\tmp\set.iss" -Wait -NoNewWindow




