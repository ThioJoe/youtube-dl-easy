# =====================================
#        Script Author: ThioJoe
#		   Github.com/ThioJoe
# =====================================

# ----------------------------------- IMPORTANT STUFF -----------------------------------------
#
# THIS SCRIPT REQUIRES the "youtube-dl" program: https://yt-dl.org/
#
# Direct link to latest youtube-dl executable: https://yt-dl.org/latest/youtube-dl.exe
# YouTube-dl documentation: https://github.com/ytdl-org/youtube-dl/blob/master/README.md#readme
# Supported sites for Downloading: https://ytdl-org.github.io/youtube-dl/supportedsites.html
# See this script's Readme for more details
# ---------------------------------------------------------------------------------------------

# PARAMETERS YOU MAY NEED/WISH TO CHANGE BELOW:
# Set ffmpeg location here. Make sure it is up to date (if using chocolatey:  chocolatey upgrade ffmpeg )
# Set output location and filename of downloaded files. Defaults to Desktop, with video title and video extension. See documentation on specifics.
# Set default options / parameters to apply to all downloads. See youtube-dl documentation for details. Includes ffmpeg location and output location using the other variables.
$ffmpeg_location="`"C:\ProgramData\chocolatey\bin\ffmpeg.exe`""
$output_location="`"$HOME\Desktop\%(title)s.%(ext)s`""
$options="--no-mtime --ffmpeg-location $ffmpeg_location --output $output_location"

#################### Functions ####################

#Sets $format variable based on user-inputted choice, which is used in final command as format related parameters
function Set-Format {
	Switch ($choice)
	{
		1 {Write-Output $null}
		2 {Write-Output "-f best"}
		3 {Write-Output "-f bestvideo+bestaudio/best --merge-output-format mp4"}
		4 {Write-Output -f $format --merge-output-format mp4}
		5 {Write-Output -f $format}
	}
}

# Outputs preview of format for user approval
function Check-Format {
	Write-Host "Output will be: " 
	Write-Host (& ./youtube-dl.exe $format $URL --get-format)
	Read-Host "Ok? (Enter Y/N)"
}

# For choices that require manually selecting formats using format codes (Choices 4 & 5)
function Custom-Formats {
	# Write-Host "I am inside custom-formats" #For Testing
	if ($choice -eq 4) {Write-Host "INSTRUCTIONS: Choose the format codes for the video and audio quality you want from the list at the top. ffmpeg must be installed and location specified in batch file."
		$videoFormat = Read-Host "Video Format Code"
		$audioFormat = Read-Host "Audio Format Code"
		$chosenFormat = ${videoFormat}+"+"+${audioFormat}
		Write-Output $chosenFormat #Returns this variable out of the function
	}
	else { if ($choice -eq 5) {Write-Host "INSTRUCTIONS: Choose the format code for the video or audio quality you want from the list at the top."
		$chosenFormat = Read-Host "Format Code"
		Write-Output $chosenFormat #Returns this variable out of the function
		 }
	}
}

# Updates youtube-dl (must be in same directory as script)
function Update-Program{
	& ./youtube-dl.exe --update
	exit
	}
	
##########################################################################	



# =================================== Start Main Program ===================================
Write-Output ""
Write-Output '--------------------------------- Video Downloader Script ---------------------------------'
Write-Output ""
Write-Output 'REQUIRES the youtube-dl program from: https://youtube-dl.org/'
Write-Output 'Supported Video Sites: https://ytdl-org.github.io/youtube-dl/supportedsites.html'
Write-Output ""
$URL = Read-Host "Enter video URL here"

# Lists all formats for video
Write-Output ""
& ./youtube-dl.exe --list-formats $URL

# While loop until user is satisfied with output and confirms using Check-Format function
while ($confirm -ne "y") {
	Write-Output ""
	Write-Output "---------------------------------------------------------------------------"
	Write-Output "Options:"
	Write-Output "1. Download automatically (default is best video + audio muxed)"
	Write-Output "2. Download the best quality single file, no mux"
	Write-Output "3. Download the highest quality audio + video formats, attempt merge to mp4"
	Write-Output "4. Let me choose the video and audio formats to combine"
	Write-Output "5. Download ONLY audio or video"
	Write-Output "6. -UPDATE PROGRAM- (Admin May Be Required)"
	Write-Output ""

	$choice = Read-Host "Type your choice number" #Takes in choice from user
	if (($choice -eq 4)	-or ($choice -eq 5)) { $format = Custom-Formats }
	if ($choice -eq 6) {Update-Program}
	$format = Set-Format
	$confirm = Check-Format
}

# Final Run
Write-Output ""
Write-Output "Running Command:   ./youtube-dl.exe $format $URL '--%' $options"
& ./youtube-dl.exe $format $URL '--%' $options #Final full command used on youtube-dl. I have no idea why '--%' is required in there but without it, it won't work. Got it from an obscure StackOverflow comment
cmd /c pause


