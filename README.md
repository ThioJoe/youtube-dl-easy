# youtube-dl-easy
Script for running youtube-dl with basic options using Powershell. 
Allows automatic download options, as well as manually choosing the formats.

## REQUIREMENTS: 

- This is NOT  standalone script. It requires the youtube-dl program, which should be put in the same directory as this script. Download YouTube-dl here: https://yt-dl.org/
- Alternatively, you can use this script with a fork of youtube-dl called "yt-dlp", which has more features and may work better. It is found here: https://github.com/yt-dlp/yt-dlp
- Some download methods will require ffmpeg to be installed: https://ffmpeg.org/

## Screenshot Preview
![Script Screenshot](https://user-images.githubusercontent.com/12518330/88689286-282b4500-d0af-11ea-8053-ae4568144859.png)


## youtube-dl Links:

- YouTube-dl documentation: https://github.com/ytdl-org/youtube-dl/blob/master/README.md#readme
- Supported sites for Downloading: https://ytdl-org.github.io/youtube-dl/supportedsites.html
- Direct link to latest youtube-dl executable: https://yt-dl.org/latest/youtube-dl.exe

## Script / Code Parameters
You may wish/need to change certain paremeters in the script code, located in the section called "PARAMETERS YOU MAY NEED/WISH TO CHANGE". This includes the location of the ffmpeg file, the output directory (default is desktop) and filename, and options. See YouTube-dl documentation for more parameters.

### Running the Script & Powershell Execution Policy
By default you may not be able to run any powershell scripts unless you change Windows' execution policy.

You can change the execution policy just for the current process by running the following before running the script. Note that if you close the PowerShell window, it will reset the policy.

`Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process`

Alternatively if you like, because this script is signed, instead of "Unrestricted", you could use the "AllSigned" setting instead, like below. Note: If you changed any thing inside the script at all, even optional settings, the signature will no longer be valid.

`Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope Process`

You can run the script by opening a PowerShell window to the folder with the script and entering this (after setting the execution policy if necessary, and don't forget the period):

`.\"youtube-dl Easy Script.ps1"`

### Troubleshooting
If you come across weird errors the first thing to try should be updating the youtube-dl program. You can do this using option # 6. YouTube-dl is updated pretty frequently and they usually fix issues quickly when YouTube.com makes breaking changes.
