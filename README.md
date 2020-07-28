# youtube-dl-easy
Script for running youtube-dl with basic options using Powershell. 
Allows automatic download options, as well as manually choosing the formats.

## REQUIREMENTS: 

- This is NOT  standalone script. It requires the youtube-dl program, which should be put in the same directory as this script. Download YouTube-dl here: https://yt-dl.org/
- Some download methods will require ffmpeg to be installed: https://ffmpeg.org/

## Screenshot Preview
![Script Screenshot](https://user-images.githubusercontent.com/12518330/88689286-282b4500-d0af-11ea-8053-ae4568144859.png)


## youtube-dl Links:

- YouTube-dl documentation: https://github.com/ytdl-org/youtube-dl/blob/master/README.md#readme
- Supported sites for Downloading: https://ytdl-org.github.io/youtube-dl/supportedsites.html
- Direct link to latest youtube-dl executable: https://yt-dl.org/latest/youtube-dl.exe

## Script / Code Parameters
You may wish/need to change certain paremeters in the script code, located in the section called "PARAMETERS YOU MAY NEED/WISH TO CHANGE". This includes the location of the ffmpeg file, the output directory (default is desktop) and filename, and options. See YouTube-dl documentation for more parameters.

### Powershell Execution Policy
By default you may not be able to run any powershell scripts unless you change Windows' execution policy. Try setting to "RemoteSigned".

See tutorial on changing execution policy here: https://www.tenforums.com/tutorials/54585-change-powershell-script-execution-policy-windows-10-a.html

### Troubleshooting
If you come across weird errors the first thing to try should be updating the youtube-dl program. You can do this using option # 6. YouTube-dl is updated pretty frequently and they usually fix issues quickly when YouTube.com makes breaking changes.
