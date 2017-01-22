@cls 
@echo off
set starttime=%time%

call get_usb_drive_letter.bat freeagent > nul
set path=/cygdrive/%ltr%/_Backup
set rsync=-aiz --partial --links --delete 
rem -b --backup-dir=%path%/_deleted/

echo Backup drive: %path%

if exist %ltr%:\ goto F

:F
	rem echo Compress old backup
	rem C:\Cygwin\bin\tar -czf %ltr%/Ableton.tar.gz %ltr%/Ableton

	set source=/cygdrive/c/Users/jens/Documents/Ableton/Library/.*
	set target=%path%/Ableton/Library/
	echo Backup: Ableton library (%source% : %target%)
	C:\Cygwin\bin\rsync %rsync% %source% %target% 
	
	set source=/cygdrive/c/Users/jens/Documents/Ableton/Tools/.*
	set target=%path%/Ableton/Tools/
	echo Backup: Audio Tools  (%source% : %target%)
	C:\Cygwin\bin\rsync %rsync% %source% %target%
	
	set source=/cygdrive/c/Users/jens/.*
	set target=%path%/Home/
	echo Backup: Home  (%source% : %target%)
	C:\Cygwin\bin\rsync %rsync% --exclude-from /cygdrive/c/Users/jens/Dropbox/Skripte/win7/sync_freeagent_home.exclude %source% %target%
	
	set source="/cygdrive/c/Program Files (x86)/OpenVPN Technologies/OpenVPN Client/etc/profile/.*"
	set target=%path%/OpenVPN/
	echo Backup: VPN Profiles  (%source% : %target%)
	C:\Cygwin\bin\rsync %rsync% %source% %target%
		
goto end

:end
set endtime=%time%
echo Starttime: %starttime% 
echo Endtime: %endtime% 
pause