# =====================================
#        Script Author: ThioJoe
#        Github.com/ThioJoe
# =====================================
#        Version: 1.1
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
$ffmpeg_location="`"ffmpeg.exe`"" # Just put it in the same directory as the script
$output_location="`"$HOME\Desktop\Outputs\%(title)s.%(ext)s`"" # Outputs to a folder called "Outputs" in the same directory as the script, with filename as video title
$downloader_exe="yt-dlp.exe" # "yt-dlp.exe"  or  "youtube-dl.exe"
$options="--no-mtime --ffmpeg-location $ffmpeg_location --output $output_location --add-metadata"

#################### Functions ####################
function Format-PathVariable($path) {
    if ($path -notmatch '^".*"$') {
        $path = "`"$path`""
    } else {
        $path = $path -replace '(?<!`)("(?!"))', '``$1'
    }
    return $path
}

#Sets $format variable based on user-inputted choice, which is used in final command as format related parameters
function Set-Format {
	Switch ($choice)
	{
		1 {Write-Output $null} # Automatic default is best video + audio muxed
		2 {Write-Output "-f best"} # Best quality audio+video single file, no mux
		3 {Write-Output "-f bestvideo+bestaudio/best --merge-output-format mp4"} # Choose highest quality video and audio formats to combine
		4 {Write-Output -f $format --merge-output-format mp4} # Choose video and audio formats to combine
		5 {Write-Output -f $format} # Download only audio or video
		6 {Write-Output "-f $format"} # Specify single audio+video file
		# Note for later: Optiosn 5 and 6 likely need to be combined into one option, since they are the same thing
	}
}


# Outputs preview of format for user approval
function Check-Format {
	Write-Host "Output will be: " 
	Write-Host (& .\$downloader_exe $format $URL --get-format)
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
	elseif ($choice -eq 5) {Write-Host "INSTRUCTIONS: Choose the format code for the video or audio quality you want from the list at the top."
		$chosenFormat = Read-Host "Format Code"
		Write-Output $chosenFormat #Returns this variable out of the function
		 }
	
	elseif ($choice -eq 6) {Write-Host "INSTRUCTIONS: Choose the format code for a specific single audio+video file (one that DOESN'T say 'video only' or 'audio only')."
		$chosenFormat = Read-Host "Format Code"
		Write-Output $chosenFormat #Returns this variable out of the function
		 }
	}


# Updates youtube-dl (must be in same directory as script)
function Update-Program{
	& .\$downloader_exe --update
	exit
	}

# Function to check if the URL is a YouTube playlist
function Is-PlaylistUrl {
    param($url)
    return $url -like "*playlist?list=*"
}
	
##########################################################################	
# Run any utility functions
# $ffmpeg_location = Format-PathVariable($ffmpeg_location)
# $output_location = Format-PathVariable($output_location)

# =================================== Start Main Program ===================================
Write-Output ""
Write-Output '--------------------------------- Video Downloader Script ---------------------------------'
Write-Output ""
Write-Output 'REQUIRES the youtube-dl program from: https://youtube-dl.org/'
Write-Output 'Supported Video Sites: https://ytdl-org.github.io/youtube-dl/supportedsites.html'
Write-Output ""
$URL = Read-Host "Enter video URL here"

# Check if the URL is a playlist
if (Is-PlaylistUrl $URL) {
    Write-Output "Playlist detected. Skipping to format selection...`n"
    # [Insert any actions to take when a playlist URL is detected]
	$isPlaylist="true"
} else {
	isPlaylist="false"
    # Lists all formats for video
    Write-Output ""
    & .\$downloader_exe --list-formats $URL

}

while ($confirm -ne "y") {
	Write-Output ""
	Write-Output "---------------------------------------------------------------------------"
	Write-Output "Options:"
	Write-Output "1. Download automatically (default is best video + audio muxed)"
	Write-Output "2. Download the best quality audio+video single file, no mux"
	Write-Output "3. Download the highest quality audio + video formats, attempt merge to mp4"
	Write-Output "4. Let me individually choose the video and audio formats to combine"
	Write-Output "5. Download ONLY audio or video"
	Write-Output "6. Download a specific audio+video single file, no mux"
	Write-Output "7. -UPDATE PROGRAM- (Admin May Be Required)"
	Write-Output ""

	$choice = Read-Host "Type your choice number"
	if (($choice -eq 4) -or ($choice -eq 5) -or ($choice -eq 6)) { $format = Custom-Formats }
	if ($choice -eq 7) {Update-Program}
	# if ($choice -eq 6) {$id = Read-Host "Enter format ID"}
	$format = Set-Format
	if ($isPlaylist -eq "false"){
		$confirm = Check-Format
	}	else {
		Write-Host "Skipping format list for playlist..."
		$confirm = Read-Host "Proceed and download playlist videos? (Enter Y/N)"
	}
}

# Final Run
Write-Output ""
Write-Output "Running Command:   .\$downloader_exe $format $URL '--%' $options"
& .\$downloader_exe $format $URL '--%' $options #Final full command used on youtube-dl. The '--%' basically tells powershell not to interpret the rest of the line as powershell commands, so it can be passed to youtube-dl as is.
cmd /c pause


# SIG # Begin signature block
# MIIplwYJKoZIhvcNAQcCoIIpiDCCKYQCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDwr3hQuwPwpcF4
# QOBOUd+606Ne4TLamJKCiQRwbuX6P6CCDoMwggawMIIEmKADAgECAhAIrUCyYNKc
# TJ9ezam9k67ZMA0GCSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNV
# BAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0yMTA0MjkwMDAwMDBaFw0z
# NjA0MjgyMzU5NTlaMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcg
# UlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
# ggIKAoICAQDVtC9C0CiteLdd1TlZG7GIQvUzjOs9gZdwxbvEhSYwn6SOaNhc9es0
# JAfhS0/TeEP0F9ce2vnS1WcaUk8OoVf8iJnBkcyBAz5NcCRks43iCH00fUyAVxJr
# Q5qZ8sU7H/Lvy0daE6ZMswEgJfMQ04uy+wjwiuCdCcBlp/qYgEk1hz1RGeiQIXhF
# LqGfLOEYwhrMxe6TSXBCMo/7xuoc82VokaJNTIIRSFJo3hC9FFdd6BgTZcV/sk+F
# LEikVoQ11vkunKoAFdE3/hoGlMJ8yOobMubKwvSnowMOdKWvObarYBLj6Na59zHh
# 3K3kGKDYwSNHR7OhD26jq22YBoMbt2pnLdK9RBqSEIGPsDsJ18ebMlrC/2pgVItJ
# wZPt4bRc4G/rJvmM1bL5OBDm6s6R9b7T+2+TYTRcvJNFKIM2KmYoX7BzzosmJQay
# g9Rc9hUZTO1i4F4z8ujo7AqnsAMrkbI2eb73rQgedaZlzLvjSFDzd5Ea/ttQokbI
# YViY9XwCFjyDKK05huzUtw1T0PhH5nUwjewwk3YUpltLXXRhTT8SkXbev1jLchAp
# QfDVxW0mdmgRQRNYmtwmKwH0iU1Z23jPgUo+QEdfyYFQc4UQIyFZYIpkVMHMIRro
# OBl8ZhzNeDhFMJlP/2NPTLuqDQhTQXxYPUez+rbsjDIJAsxsPAxWEQIDAQABo4IB
# WTCCAVUwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUaDfg67Y7+F8Rhvv+
# YXsIiGX0TkIwHwYDVR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0P
# AQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHcGCCsGAQUFBwEBBGswaTAk
# BggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAC
# hjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9v
# dEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNybDAcBgNVHSAEFTATMAcGBWeBDAED
# MAgGBmeBDAEEATANBgkqhkiG9w0BAQwFAAOCAgEAOiNEPY0Idu6PvDqZ01bgAhql
# +Eg08yy25nRm95RysQDKr2wwJxMSnpBEn0v9nqN8JtU3vDpdSG2V1T9J9Ce7FoFF
# UP2cvbaF4HZ+N3HLIvdaqpDP9ZNq4+sg0dVQeYiaiorBtr2hSBh+3NiAGhEZGM1h
# mYFW9snjdufE5BtfQ/g+lP92OT2e1JnPSt0o618moZVYSNUa/tcnP/2Q0XaG3Ryw
# YFzzDaju4ImhvTnhOE7abrs2nfvlIVNaw8rpavGiPttDuDPITzgUkpn13c5Ubdld
# AhQfQDN8A+KVssIhdXNSy0bYxDQcoqVLjc1vdjcshT8azibpGL6QB7BDf5WIIIJw
# 8MzK7/0pNVwfiThV9zeKiwmhywvpMRr/LhlcOXHhvpynCgbWJme3kuZOX956rEnP
# LqR0kq3bPKSchh/jwVYbKyP/j7XqiHtwa+aguv06P0WmxOgWkVKLQcBIhEuWTatE
# QOON8BUozu3xGFYHKi8QxAwIZDwzj64ojDzLj4gLDb879M4ee47vtevLt/B3E+bn
# KD+sEq6lLyJsQfmCXBVmzGwOysWGw/YmMwwHS6DTBwJqakAwSEs0qFEgu60bhQji
# WQ1tygVQK+pKHJ6l/aCnHwZ05/LWUpD9r4VIIflXO7ScA+2GRfS0YW6/aOImYIbq
# yK+p/pQd52MbOoZWeE4wggfLMIIFs6ADAgECAhAIDbJ1eLBvhEUmSTXbMO0DMA0G
# CSqGSIb3DQEBCwUAMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcg
# UlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwHhcNMjMwMzA0MDAwMDAwWhcNMjUwMTA0
# MjM1OTU5WjCB0zETMBEGCysGAQQBgjc8AgEDEwJVUzEYMBYGCysGAQQBgjc8AgEC
# EwdXeW9taW5nMR0wGwYDVQQPDBRQcml2YXRlIE9yZ2FuaXphdGlvbjEXMBUGA1UE
# BRMOMjAyMS0wMDEwNTUxMTkxCzAJBgNVBAYTAlVTMRAwDgYDVQQIEwdXeW9taW5n
# MREwDwYDVQQHEwhTaGVyaWRhbjEbMBkGA1UEChMSVGhpbyBTb2Z0d2FyZSwgTExD
# MRswGQYDVQQDExJUaGlvIFNvZnR3YXJlLCBMTEMwggIiMA0GCSqGSIb3DQEBAQUA
# A4ICDwAwggIKAoICAQCyUph17S2KERvqfBBVI2wuQIVe+uZffJjzfWX1H9G0TnfS
# QWLTyXGxb/nT6nnwN/7ibHJldTwsSTaPOTkvaSnZuz0+AZPRXIiT/DuV3loOSqPX
# MYv1uQKDvLFzc+WOGkt2+cMXTFkP4joCPvkKb5+M2fapeNVxej7C5h4Ef3ABlg3o
# otc2xdZjGvPnxA9dnbdlNzJsRnjHHKPYwknl3QVra4PfP74D8K7dCxTzZUQpYYGy
# kZ05VHSuAG2HaPzr5o6CBnDv1ITvHX92JraAMcBd/gfcJsWoPH05mFgQfKDP3wru
# TQ9Ql2y67BFRXJR3RogMmu1FLsKzyP8yuZfcr7IWIiFgwYUzFs5k6FFy9kt1Cvs+
# zyFtUPUeWtv01hZY+MC2/Qdy/CqGPkyPs4woh5ajEx1GcY11laRFUADWtgXJY0gG
# gl5suB8V4iaGt9iA0frfLyWq/F0h9U4tKnHucgf3DT58hM29el/3VqJx7ERgAc78
# XRBgXDNxSsQpFsr/MvGGax27ayTvwMQm25UUbNTyFo0Nb0wxYXPYlA38+DwdXDYK
# q5BkNqqot44C/xZImP/F8ecnyIY9M2nhMtX49pC6zGJw6wtdhG5bKJFDRCwpy1wi
# vCVifhV2M3RuydUW1StYunzbhwQAAI6bg2Gz6vmLd6QZ69Zt6YxSDhrNVce41QID
# AQABo4ICAjCCAf4wHwYDVR0jBBgwFoAUaDfg67Y7+F8Rhvv+YXsIiGX0TkIwHQYD
# VR0OBBYEFHSwnMhQo43ayv0NcY2KnesS3hJWMA4GA1UdDwEB/wQEAwIHgDATBgNV
# HSUEDDAKBggrBgEFBQcDAzCBtQYDVR0fBIGtMIGqMFOgUaBPhk1odHRwOi8vY3Js
# My5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2lnbmluZ1JTQTQw
# OTZTSEEzODQyMDIxQ0ExLmNybDBToFGgT4ZNaHR0cDovL2NybDQuZGlnaWNlcnQu
# Y29tL0RpZ2lDZXJ0VHJ1c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hBMzg0MjAy
# MUNBMS5jcmwwPQYDVR0gBDYwNDAyBgVngQwBAzApMCcGCCsGAQUFBwIBFhtodHRw
# Oi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwgZQGCCsGAQUFBwEBBIGHMIGEMCQGCCsG
# AQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wXAYIKwYBBQUHMAKGUGh0
# dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNENvZGVT
# aWduaW5nUlNBNDA5NlNIQTM4NDIwMjFDQTEuY3J0MAkGA1UdEwQCMAAwDQYJKoZI
# hvcNAQELBQADggIBADDtgBDkKblvpa1Q24nmKq/hI8tRYPV7E2Umhk2BlSoBC+6M
# bNCDDltR/3OqFo6x9MxEuZnO4rC2eUMR4M/Xkj6E1GEKmm9ZOBTvgj6VDM5qv87G
# 8S1fq8yNr3srRLCtt7XXeVnRacSXAzD9NKr5QjZqOnD7uqWchvDMhVyT1WSvUACO
# 8K/Hr3kXtPIpLN3T6vxe9TwAwDxSk3/eeAHIQJN2EdcbhDEvDcOpkEse7bGNdZGG
# unlWOfBwCYuRarznUxz7kr8+MZIf3TixpOBHKjcGUeOAvPysqPBv+I6my7yrYirJ
# OlxqEOoY8psBU7z4L6vctr9/5DjltG4wQLjVfFpVHpizsk/EYr/jdHFmcqD6/edY
# PhMPaT8ItORC/EaXyBmOcKapegl9ay03kKztykuV/jsTRMFfGpGq/fTVY6R3bxMw
# HO3odlQnEvtGVXox8A4kp/6HZy4mh0BXJLjj+JZrEukizOnMa5Yr4H50GutgGfCL
# 7JqEBzv5pr+1Lyhkuwc2zBtcP9zrDdFqvi2rIQqU2OksE2wSuy2YnsiR1ekSxVNl
# JqrJXzEfZUprneVKOypREFFwek6cWbgXlJLr6XvBjq/hANBdhueMOJHkJoosL3SZ
# 7hAAPeUnGF5LQVK5dSHYVvcOT90g/eJ0NCX7wSDKjJ6A5weLkEZD+l/ef4VtMYIa
# ajCCGmYCAQEwfTBpMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIElu
# Yy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQgQ29kZSBTaWduaW5nIFJT
# QTQwOTYgU0hBMzg0IDIwMjEgQ0ExAhAIDbJ1eLBvhEUmSTXbMO0DMA0GCWCGSAFl
# AwQCAQUAoHwwEAYKKwYBBAGCNwIBDDECMAAwGQYJKoZIhvcNAQkDMQwGCisGAQQB
# gjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkE
# MSIEICsznTfLjD9abPI9bEn5XAB/9plhm0p9qK1EG6N0ixZWMA0GCSqGSIb3DQEB
# AQUABIICABGGHQ2luMXiRYp0n9B+Y+zm3IilwFNv04cS+dV6tzl6WFDRkzLi7jA8
# 2F7YLjGZrT4ecUrQZ+nN26bNTGG4oXlmGUI7Byk2v/gcbprEkllSx7L43Cukx3Na
# 8I9m3HndnVIgpOwyYfYRDhxi+/sov03e8JQfu9UPOOehE000Ze1xdNn+S92Ocp3e
# VCBMl/cybvB2D0KEoytte8MR8dnrWZAwUfuHejspzanVE5N3pdOw3hzfUReFwUmi
# i7wG65Jf9WQYx6Hr4Eu2H6VReibCqywuuD4T0f+v01xrs9wGRnIWNsyNsf4fy8SI
# sGhmmgJ++ShBMRazi/z4F9uk/DL0Op85k0YMI3WYAMB8/KCg/JPK6pjUMGspFrfb
# jG4SKsqpntcrQVklhhCkOorV1Su088iWm4Jj7vEiKYoPNJbGO7AxDOhZcbTfC8oT
# 5bZ9tjDDAyywkka00Fx2OUa7Yq+raBzQSQ2/CZjBP3UdZ1gygCVQ/ko8YbWNDS44
# K9LNF57Sceq8w7U1O9w3VZbKrEp7SWBLEXq5IplT3iToynzhC0F3sA7DSqB+YX00
# /Pcf4uQyp1gT14cvczXvVhqaiIyCNTVsStSm5DkKa0zOeQ/7OCUFf8to9XFw2e9S
# CGfpWmLa6nPgbOUEocD4BT5bgeq78fB2N/aZJIGFRzRbYVV3+kr/oYIXQDCCFzwG
# CisGAQQBgjcDAwExghcsMIIXKAYJKoZIhvcNAQcCoIIXGTCCFxUCAQMxDzANBglg
# hkgBZQMEAgEFADB4BgsqhkiG9w0BCRABBKBpBGcwZQIBAQYJYIZIAYb9bAcBMDEw
# DQYJYIZIAWUDBAIBBQAEIHbwloVFJP208SVHFFPMUjfPZkXmhK/2u8g3wkMtSxYQ
# AhEAzZ6gFt0xu/5HxN/X8hmb3RgPMjAyNDAxMDgwMTM1MzVaoIITCTCCBsIwggSq
# oAMCAQICEAVEr/OUnQg5pr/bP1/lYRYwDQYJKoZIhvcNAQELBQAwYzELMAkGA1UE
# BhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2Vy
# dCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBDQTAeFw0y
# MzA3MTQwMDAwMDBaFw0zNDEwMTMyMzU5NTlaMEgxCzAJBgNVBAYTAlVTMRcwFQYD
# VQQKEw5EaWdpQ2VydCwgSW5jLjEgMB4GA1UEAxMXRGlnaUNlcnQgVGltZXN0YW1w
# IDIwMjMwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCjU0WHHYOOW6w+
# VLMj4M+f1+XS512hDgncL0ijl3o7Kpxn3GIVWMGpkxGnzaqyat0QKYoeYmNp01ic
# NXG/OpfrlFCPHCDqx5o7L5Zm42nnaf5bw9YrIBzBl5S0pVCB8s/LB6YwaMqDQtr8
# fwkklKSCGtpqutg7yl3eGRiF+0XqDWFsnf5xXsQGmjzwxS55DxtmUuPI1j5f2kPT
# hPXQx/ZILV5FdZZ1/t0QoRuDwbjmUpW1R9d4KTlr4HhZl+NEK0rVlc7vCBfqgmRN
# /yPjyobutKQhZHDr1eWg2mOzLukF7qr2JPUdvJscsrdf3/Dudn0xmWVHVZ1KJC+s
# K5e+n+T9e3M+Mu5SNPvUu+vUoCw0m+PebmQZBzcBkQ8ctVHNqkxmg4hoYru8QRt4
# GW3k2Q/gWEH72LEs4VGvtK0VBhTqYggT02kefGRNnQ/fztFejKqrUBXJs8q818Q7
# aESjpTtC/XN97t0K/3k0EH6mXApYTAA+hWl1x4Nk1nXNjxJ2VqUk+tfEayG66B80
# mC866msBsPf7Kobse1I4qZgJoXGybHGvPrhvltXhEBP+YUcKjP7wtsfVx95sJPC/
# QoLKoHE9nJKTBLRpcCcNT7e1NtHJXwikcKPsCvERLmTgyyIryvEoEyFJUX4GZtM7
# vvrrkTjYUQfKlLfiUKHzOtOKg8tAewIDAQABo4IBizCCAYcwDgYDVR0PAQH/BAQD
# AgeAMAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwIAYDVR0g
# BBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMB8GA1UdIwQYMBaAFLoW2W1NhS9z
# KXaaL3WMaiCPnshvMB0GA1UdDgQWBBSltu8T5+/N0GSh1VapZTGj3tXjSTBaBgNV
# HR8EUzBRME+gTaBLhklodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRU
# cnVzdGVkRzRSU0E0MDk2U0hBMjU2VGltZVN0YW1waW5nQ0EuY3JsMIGQBggrBgEF
# BQcBAQSBgzCBgDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
# MFgGCCsGAQUFBzAChkxodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRUcnVzdGVkRzRSU0E0MDk2U0hBMjU2VGltZVN0YW1waW5nQ0EuY3J0MA0GCSqG
# SIb3DQEBCwUAA4ICAQCBGtbeoKm1mBe8cI1PijxonNgl/8ss5M3qXSKS7IwiAqm4
# z4Co2efjxe0mgopxLxjdTrbebNfhYJwr7e09SI64a7p8Xb3CYTdoSXej65CqEtcn
# hfOOHpLawkA4n13IoC4leCWdKgV6hCmYtld5j9smViuw86e9NwzYmHZPVrlSwrad
# OKmB521BXIxp0bkrxMZ7z5z6eOKTGnaiaXXTUOREEr4gDZ6pRND45Ul3CFohxbTP
# mJUaVLq5vMFpGbrPFvKDNzRusEEm3d5al08zjdSNd311RaGlWCZqA0Xe2VC1UIyv
# Vr1MxeFGxSjTredDAHDezJieGYkD6tSRN+9NUvPJYCHEVkft2hFLjDLDiOZY4rbb
# PvlfsELWj+MXkdGqwFXjhr+sJyxB0JozSqg21Llyln6XeThIX8rC3D0y33XWNmda
# ifj2p8flTzU8AL2+nCpseQHc2kTmOt44OwdeOVj0fHMxVaCAEcsUDH6uvP6k63ll
# qmjWIso765qCNVcoFstp8jKastLYOrixRoZruhf9xHdsFWyuq69zOuhJRrfVf8y2
# OMDY7Bz1tqG4QyzfTkx9HmhwwHcK1ALgXGC7KP845VJa1qwXIiNO9OzTF/tQa/8H
# dx9xl0RBybhG02wyfFgvZ0dl5Rtztpn5aywGRu9BHvDwX+Db2a2QgESvgBBBijCC
# Bq4wggSWoAMCAQICEAc2N7ckVHzYR6z9KGYqXlswDQYJKoZIhvcNAQELBQAwYjEL
# MAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3
# LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgVHJ1c3RlZCBSb290IEc0
# MB4XDTIyMDMyMzAwMDAwMFoXDTM3MDMyMjIzNTk1OVowYzELMAkGA1UEBhMCVVMx
# FzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBUcnVz
# dGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBDQTCCAiIwDQYJKoZI
# hvcNAQEBBQADggIPADCCAgoCggIBAMaGNQZJs8E9cklRVcclA8TykTepl1Gh1tKD
# 0Z5Mom2gsMyD+Vr2EaFEFUJfpIjzaPp985yJC3+dH54PMx9QEwsmc5Zt+FeoAn39
# Q7SE2hHxc7Gz7iuAhIoiGN/r2j3EF3+rGSs+QtxnjupRPfDWVtTnKC3r07G1decf
# BmWNlCnT2exp39mQh0YAe9tEQYncfGpXevA3eZ9drMvohGS0UvJ2R/dhgxndX7RU
# CyFobjchu0CsX7LeSn3O9TkSZ+8OpWNs5KbFHc02DVzV5huowWR0QKfAcsW6Th+x
# tVhNef7Xj3OTrCw54qVI1vCwMROpVymWJy71h6aPTnYVVSZwmCZ/oBpHIEPjQ2OA
# e3VuJyWQmDo4EbP29p7mO1vsgd4iFNmCKseSv6De4z6ic/rnH1pslPJSlRErWHRA
# KKtzQ87fSqEcazjFKfPKqpZzQmiftkaznTqj1QPgv/CiPMpC3BhIfxQ0z9JMq++b
# Pf4OuGQq+nUoJEHtQr8FnGZJUlD0UfM2SU2LINIsVzV5K6jzRWC8I41Y99xh3pP+
# OcD5sjClTNfpmEpYPtMDiP6zj9NeS3YSUZPJjAw7W4oiqMEmCPkUEBIDfV8ju2Tj
# Y+Cm4T72wnSyPx4JduyrXUZ14mCjWAkBKAAOhFTuzuldyF4wEr1GnrXTdrnSDmuZ
# DNIztM2xAgMBAAGjggFdMIIBWTASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQW
# BBS6FtltTYUvcyl2mi91jGogj57IbzAfBgNVHSMEGDAWgBTs1+OC0nFdZEzfLmc/
# 57qYrhwPTzAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0lBAwwCgYIKwYBBQUHAwgwdwYI
# KwYBBQUHAQEEazBpMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5j
# b20wQQYIKwYBBQUHMAKGNWh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdp
# Q2VydFRydXN0ZWRSb290RzQuY3J0MEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9j
# cmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRSb290RzQuY3JsMCAGA1Ud
# IAQZMBcwCAYGZ4EMAQQCMAsGCWCGSAGG/WwHATANBgkqhkiG9w0BAQsFAAOCAgEA
# fVmOwJO2b5ipRCIBfmbW2CFC4bAYLhBNE88wU86/GPvHUF3iSyn7cIoNqilp/GnB
# zx0H6T5gyNgL5Vxb122H+oQgJTQxZ822EpZvxFBMYh0MCIKoFr2pVs8Vc40BIiXO
# lWk/R3f7cnQU1/+rT4osequFzUNf7WC2qk+RZp4snuCKrOX9jLxkJodskr2dfNBw
# CnzvqLx1T7pa96kQsl3p/yhUifDVinF2ZdrM8HKjI/rAJ4JErpknG6skHibBt94q
# 6/aesXmZgaNWhqsKRcnfxI2g55j7+6adcq/Ex8HBanHZxhOACcS2n82HhyS7T6NJ
# uXdmkfFynOlLAlKnN36TU6w7HQhJD5TNOXrd/yVjmScsPT9rp/Fmw0HNT7ZAmyEh
# QNC3EyTN3B14OuSereU0cZLXJmvkOHOrpgFPvT87eK1MrfvElXvtCl8zOYdBeHo4
# 6Zzh3SP9HSjTx/no8Zhf+yvYfvJGnXUsHicsJttvFXseGYs2uJPU5vIXmVnKcPA3
# v5gA3yAWTyf7YGcWoWa63VXAOimGsJigK+2VQbc61RWYMbRiCQ8KvYHZE/6/pNHz
# V9m8BPqC3jLfBInwAM1dwvnQI38AC+R2AibZ8GV2QqYphwlHK+Z/GqSFD/yYlvZV
# VCsfgPrA8g4r5db7qS9EFUrnEw4d2zc4GqEr9u3WfPwwggWNMIIEdaADAgECAhAO
# mxiO+dAt5+/bUOIIQBhaMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYTAlVTMRUw
# EwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20x
# JDAiBgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yMjA4MDEw
# MDAwMDBaFw0zMTExMDkyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxE
# aWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMT
# GERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDCCAiIwDQYJKoZIhvcNAQEBBQADggIP
# ADCCAgoCggIBAL/mkHNo3rvkXUo8MCIwaTPswqclLskhPfKK2FnC4SmnPVirdprN
# rnsbhA3EMB/zG6Q4FutWxpdtHauyefLKEdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVy
# r2iTcMKyunWZanMylNEQRBAu34LzB4TmdDttceItDBvuINXJIB1jKS3O7F5OyJP4
# IWGbNOsFxl7sWxq868nPzaw0QF+xembud8hIqGZXV59UWI4MK7dPpzDZVu7Ke13j
# rclPXuU15zHL2pNe3I6PgNq2kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4Q
# kXCrVYJBMtfbBHMqbpEBfCFM1LyuGwN1XXhm2ToxRJozQL8I11pJpMLmqaBn3aQn
# vKFPObURWBf3JFxGj2T3wWmIdph2PVldQnaHiZdpekjw4KISG2aadMreSx7nDmOu
# 5tTvkpI6nj3cAORFJYm2mkQZK37AlLTSYW3rM9nF30sEAMx9HJXDj/chsrIRt7t/
# 8tWMcCxBYKqxYxhElRp2Yn72gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQp
# JYls5Q5SUUd0viastkF13nqsX40/ybzTQRESW+UQUOsxxcpyFiIJ33xMdT9j7CFf
# xCBRa2+xq4aLT8LWRV+dIPyhHsXAj6KxfgommfXkaS+YHS312amyHeUbAgMBAAGj
# ggE6MIIBNjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTs1+OC0nFdZEzfLmc/
# 57qYrhwPTzAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzAOBgNVHQ8B
# Af8EBAMCAYYweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
# cC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2lj
# ZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwRQYDVR0fBD4wPDA6
# oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElE
# Um9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQEMBQADggEB
# AHCgv0NcVec4X6CjdBs9thbX979XB72arKGHLOyFXqkauyL4hxppVCLtpIh3bb0a
# FPQTSnovLbc47/T/gLn4offyct4kvFIDyE7QKt76LVbP+fT3rDB6mouyXtTP0UNE
# m0Mh65ZyoUi0mcudT6cGAxN3J0TU53/oWajwvy8LpunyNDzs9wPHh6jSTEAZNUZq
# aVSwuKFWjuyk1T3osdz9HNj0d1pcVIxv76FQPfx2CWiEn2/K2yCNNWAcAgPLILCs
# WKAOQGPFmCLBsln1VWvPJ6tsds5vIy30fnFqI2si/xK4VC0nftg62fC2h5b9W9Fc
# rBjDTZ9ztwGpn1eqXijiuZQxggN2MIIDcgIBATB3MGMxCzAJBgNVBAYTAlVTMRcw
# FQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMyRGlnaUNlcnQgVHJ1c3Rl
# ZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0ECEAVEr/OUnQg5pr/b
# P1/lYRYwDQYJYIZIAWUDBAIBBQCggdEwGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJ
# EAEEMBwGCSqGSIb3DQEJBTEPFw0yNDAxMDgwMTM1MzVaMCsGCyqGSIb3DQEJEAIM
# MRwwGjAYMBYEFGbwKzLCwskPgl3OqorJxk8ZnM9AMC8GCSqGSIb3DQEJBDEiBCAc
# kavpGh8Tc16QAMOVEXOsedEC4k0ZNiNPyx1xL7bM1jA3BgsqhkiG9w0BCRACLzEo
# MCYwJDAiBCDS9uRt7XQizNHUQFdoQTZvgoraVZquMxavTRqa1Ax4KDANBgkqhkiG
# 9w0BAQEFAASCAgA7ADTz1gjRNYd3hvSghG3qresCsMeyqHKWbsKnuxqTZ4XXUwIe
# HeUuy/3IblqjA88IUkTbaPuBkJdEK7ek9eGXl3mj8CrFjbHCADVOdA1pidl4mvdE
# x9p0D9zYlXzOx9f8THdfimeZC3GUun7/fU1/gpay9GPjhzXhwfBerwp1LtYWCPkX
# T2uXL0+RjW1yvvU5mn3RXUov2N7AeMaVQbejDlp7WN5b3Fxt6ZlKZhHArCQMk3sG
# BDPsYu2gDQ0fnRQVWg+hEQNxQAQWlGIagrX9EFrI8jT7YzT60k+dv8uyYD3HruxI
# MiWB6drIPGSe71g19/Rpx24iSDREke48qEYjMOzbuBiodyk7JikC0oCFJOkvVunw
# pR5+Idh/F+ILuVA2+DWi5HUDmN0d48A7mD5p0dSjiIpSmirzRN5r5c/LIaZLu0SR
# BMEkIYns+Eg8D2Cu1fceMRqOSFnAQCMzmibE6yVlsROQU5OtuLLYp+nwL2QRNh/l
# XRwXN3RH167W7mMWlTpZ+bUts9mjR+L7CCYL10qoCV1balZ3WWgqXyP0N3YDdPJF
# RYjnAiOjDdrUGBrTn84Gl8l7lG22WOg1QDuhJCdKmCTm8UHYxgFBeo3Thk7jrbHW
# cBa2Ag7k+sv1BPtQaJVKmYygC8f5sokaG+iB9CRIVrJNVnbHhgm+37ELhg==
# SIG # End signature block
