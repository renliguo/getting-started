# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

echo "`nInstalling prerequisites. Please leave the window open until the installation completes."

$cmake_path = 'https://github.com/Kitware/CMake/releases/download/v3.18.4'
$cmake_file = 'cmake-3.18.4-win32-x86.msi'
$cmake_name = 'CMake v3.18.4'
$cmake_hash = 'A92A7CE26FC4BBB6F22590468D1260C95F82EB2C06C0DFDE0F810AD5979D0490'

$gccarm_path = 'https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4'
$gccarm_file = 'gcc-arm-none-eabi-9-2019-q4-major-win32-sha2.exe'
$gccarm_name = 'GCC-ARM 9-2019q4-major'
$gccarm_hash = '3580550590B3D2C0998DCF01673EBAD7D9DFD4F6F0436F86CF2C507539C62450'

$termite_path = 'https://www.compuphase.com/software'
$termite_file = 'termite-3.4.exe'
$termite_name = 'Termite v3.4'
$termite_hash = 'CA440B6C7F6EAA812BA5F8BF42AED86E02022CA50A1C72585168C9B671D0FE19'

$azure_cli_path = 'https://azurecliprod.blob.core.windows.net/msi'
$azure_cli_file = 'azure-cli-2.14.2.msi'
$azure_cli_name = 'Azure CLI v2.14.2'
$azure_cli_hash = 'C73E14B54C6371D85D7FB22121079D981A2A6A88F7F55460D487992114AFD149'

$iot_explorer_path = 'https://github.com/Azure/azure-iot-explorer/releases/download/v0.13.0'
$iot_explorer_file = 'Azure.IoT.Explorer.preview.0.13.0.msi'
$iot_explorer_name = 'Azure IoT Explorer v0.13.0'
$iot_explorer_hash = 'BF8DF6BC98A3E6F8262DC435779B44E6840C568ADAB8949004546449F2400D1E'

echo "`nDownloading packages..."

echo "(1/5) $cmake_name"
if ( -not (Test-Path "$env:TEMP\$cmake_file") -Or ((Get-FileHash "$env:TEMP\$cmake_file").Hash -ne $cmake_hash))
{
    (New-Object System.Net.WebClient).DownloadFile("$cmake_path\$cmake_file", "$env:TEMP\$cmake_file")
}

echo "(2/5) $gccarm_name"
if ( -not (Test-Path "$env:TEMP\$gccarm_file") -Or ((Get-FileHash "$env:TEMP\$gccarm_file").Hash -ne $gccarm_hash))
{
    (New-Object System.Net.WebClient).DownloadFile("$gccarm_path\$gccarm_file", "$env:TEMP\$gccarm_file")
}

echo "(3/5) $termite_name"
if ( -not (Test-Path "$env:TEMP\$termite_file") -Or ((Get-FileHash "$env:TEMP\$termite_file").Hash -ne $termite_hash))
{
    (New-Object System.Net.WebClient).DownloadFile("$termite_path\$termite_file", "$env:TEMP\$termite_file")
}

echo "(4/5) $azure_cli_name"
if ( -not (Test-Path "$env:TEMP\$azure_cli_file") -Or ((Get-FileHash "$env:TEMP\$azure_cli_file").Hash -ne $azure_cli_hash))
{
    (New-Object System.Net.WebClient).DownloadFile("$azure_cli_path\$azure_cli_file", "$env:TEMP\$azure_cli_file")
}

echo "(5/5) $iot_explorer_name"
if ( -not (Test-Path "$env:TEMP\$iot_explorer_file") -Or ((Get-FileHash "$env:TEMP\$iot_explorer_file").Hash -ne $iot_explorer_hash))
{
    (New-Object System.Net.WebClient).DownloadFile("$iot_explorer_path\$iot_explorer_file", "$env:TEMP\$iot_explorer_file")
}


echo "`nInstalling packages..."

echo "(1/5) $cmake_name"
Start-Process -FilePath "$env:TEMP\$cmake_file" -ArgumentList "ADD_CMAKE_TO_PATH=System /passive" -Wait

echo "(2/5) $gccarm_name"
Start-Process -FilePath "$env:TEMP\$gccarm_file" -ArgumentList "/S /P /R" -Wait

echo "(3/5) $termite_name"
Start-Process -FilePath "$env:TEMP\$termite_file" -ArgumentList "/S" -Wait

echo "(4/5) $azure_cli_name"
Start-Process -FilePath "$env:TEMP\$azure_cli_file" -ArgumentList "/passive" -Wait
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
Start-Process -FilePath "az" -ArgumentList "extension add --name azure-iot" -Wait

echo "(5/5) $iot_explorer_name"
Start-Process -FilePath "$env:TEMP\$iot_explorer_file" -ArgumentList "runAfterFinish=false /passive" -Wait

echo "`nInstallation complete!"

echo "`nPress any key to continue..."
Read-Host
