$log = "c:\log.txt"
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
Start-Process "C:\ManageEngine64.exe" -ArgumentList "/s /a /s /sms /f1c:\set.iss" -Wait -NoNewWindow
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




