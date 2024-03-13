# youtube-dl-easy

Script for running youtube-dl with basic options using PowerShell.
Allows automatic download options, as well as manually choosing the formats.

## Features

- Automatic download options for best quality video + audio, best quality single file, or highest quality video and audio formats
- Manually choose video and audio formats to combine
- Download only audio or video
- Download specific audio+video single file
- Optional use of command line arguments to override hard-coded variables
- Update the downloader program from within the script

## REQUIREMENTS

- This is NOT a standalone script. It requires the youtube-dl program, which should be put in the same directory as this script. Download YouTube-dl here: https://yt-dl.org/

- Alternatively, you can use this script with a fork of youtube-dl called "yt-dlp", which has more features and may work better. It is found here: https://github.com/yt-dlp/yt-dlp

- Some download methods will require ffmpeg to be installed: https://ffmpeg.org/

## Screenshot Preview

![Script Screenshot](https://user-images.githubusercontent.com/12518330/88689286-282b4500-d0af-11ea-8053-ae4568144859.png)

## youtube-dl Links

- YouTube-dl documentation: https://github.com/ytdl-org/youtube-dl/blob/master/README.md#readme
- Supported sites for Downloading: https://ytdl-org.github.io/youtube-dl/supportedsites.html
- Direct link to latest youtube-dl executable: https://yt-dl.org/latest/youtube-dl.exe

## Script / Code Parameters

You may wish/need to change certain parameters in the script code, located in the section called "PARAMETERS YOU MAY NEED/WISH TO CHANGE". This includes the location of the ffmpeg file, the output directory (default is 'outputs' folder in current directory) and filename, and options. See YouTube-dl documentation for more parameters.

## Command Line Arguments

The script supports the following command line arguments:

- `-exe <string>`: Set the name of the YouTube downloader executable (default: "yt-dlp.exe")
- `-desktop`: Place the 'Outputs' folder on the desktop instead of the current directory
- `-options <string>`: Manually set additional parameters for the YouTube downloader executable (default: "--no-mtime --add-metadata")
- `-debug`: Display potentially helpful info for debugging, including resulting variable values

## Running the Script & PowerShell Execution Policy

By default, you may not be able to run any PowerShell scripts unless you change Windows' execution policy.

You can change the execution policy just for the current process by running the following before running the script. Note that if you close the PowerShell window, it will reset the policy.

`Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process`

Alternatively, because this script is signed, instead of "Unrestricted", you could use the "AllSigned" setting instead, like below. Note: If you changed anything inside the script at all, even optional settings, the signature will no longer be valid.

`Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope Process`

You can run the script by opening a PowerShell window in the folder with the script and entering this (after setting the execution policy if necessary, and don't forget the period):

`.\"youtube-dl Easy Script.ps1"`

### Troubleshooting

If you come across weird errors, the first thing to try should be updating the youtube-dl program. You can do this using option # 7. YouTube-dl is updated pretty frequently, and they usually fix issues quickly when YouTube.com makes breaking changes.

If you encounter issues, you can use the `-debug` command line argument to display helpful information for troubleshooting.
