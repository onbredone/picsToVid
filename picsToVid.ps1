$directorypath = Get-Location 
$camName = $directorypath | Split-Path -Leaf

#dir -recurse |  ?{ $_.PSIsContainer } | %{ Dir *.jpg | ForEach-Object  -begin { $count=1 }  -process { $nameF = [string]$count; $newName = $nameF.PadLeft(5,'0');rename-item $_ -NewName “$newName.jpg”; $count++ } }
#dir -recurse |  ?{ $_.PSIsContainer } | %{ Write-Host  Dir *.jpg }

$dir = dir $directorypath | ?{$_.PSISContainer}

foreach ($d in $dir){
	$files = Get-ChildItem $d
	$id = 1
	$files | foreach {
		$nameF = 	[string]$id;
		$newName = $nameF.PadLeft(5,'0')
		Rename-Item -Path $_.fullname -NewName "$newName.jpg"
		$id++ 
	}
	
	$dirName = $camName+ "_" + $d | Split-Path -Leaf
	#$directorypath + '/' + $dirName
	#echo $dirName
	$finalVideo = "$directorypath\$dirName.mp4"
	Write-Host -ForegroundColor Green -Object "Creating file $finalVideo";
	#echo $d.fullname
	$ArgumentList = '-r 24 -start_number 00001 -i ' + $d.fullname + '/%05d.jpg -s 1920x1080 -vcodec libx264 ' + $finalVideo
	Start-Process -FilePath c:\tools\ffmpeg\bin\ffmpeg -ArgumentList $ArgumentList -Wait -NoNewWindow;
  }
