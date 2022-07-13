    $connection = $null
    $timeout = new-timespan -Minutes 5
    $sw = [diagnostics.stopwatch]::StartNew()
    while ($sw.elapsed -lt $timeout){
        $Connection = Get-NetRoute | ? DestinationPrefix -eq '0.0.0.0/0' | Get-NetIPInterface | Where ConnectionState -eq 'Connected'
        if ($connection -ne $null){
            $timeout = new-timespan -Minutes 0
            break
        }
        start-sleep -seconds 5
    }

    try {
        $NetInfo = Invoke-RestMethod -UseBasicParsing -Uri ('http://ipinfo.io/'+(Invoke-WebRequest -UseBasicParsing -uri "http://ifconfig.me/ip").Content) -ErrorAction:Stop
        $LogTime = (Invoke-RestMethod -UseBasicParsing -Uri ("http://worldtimeapi.org/api/timezone/" + $netinfo.timezone)).datetime
        $UTCOffset = Invoke-RestMethod -UseBasicParsing -Uri ('https://ipapi.co/' + (Invoke-WebRequest -UseBasicParsing -uri "http://ifconfig.me/ip").Content + '/utc_offset')
    } catch {
        $NetInfo = $null
    }

    $LogTime | Out-File -FilePath C:\time\time.log -Append

    if ($NetInfo -ne $null) {
         # NetInfo | Select *
        # ip
        # hostname
        # city
        # region
        # country
        # loc
        # postal
        # timezone
        # readme

       $zip = $NetInfo.postal
           #$region = $NetInfo.region

           #$currentTZ = Get-Date -UFormat "%Z"
           #$currentTZ = $currentTZ -as [int]
           #$utcoffset = $utcoffset /100

       #if ( $region -ne "Arizona" -or $region -ne "Hawaii" ) {
       #    if ( $currentTZ -ne $UTCOffset ){
       #        $utcoffset = '{0:d2}' -f $utcoffset
       #        get-timezone -listavailable | Where-Object {$_.BaseUtcOffset -like "*$utcoffset*" -and $_.SupportsDaylightSavingTime -Match "True"}
       #    }
       #}
       #else{

       #}


       $webRequest = (Invoke-WebRequest -UseBasicParsing -Uri "https://www.google.com/search?q=$zip+time").content

       $tempTime = ($webRequest.substring($webRequest.LastIndexOf('<div class="BNeawe iBp4i AP7Wnd">'), $webRequest.IndexOf('</div>'))).trim()
       $tempTime = $tempTime.substring(($tempTime.Indexof(">")+1))
       $time = $tempTime.substring(0,($tempTime.Indexof("<")))

       $tempDate = ($tempTime.substring($tempTime.IndexOf('<span class='), $tempTime.IndexOf('</span>'))).trim()
       $tempDate = $tempDate.substring(($tempDate.Indexof(">")+1))
       $date = ($tempDate.substring(0,($tempDate.Indexof("`n")+1))).trim()

       # $tempST = $webRequest.substring($webRequest.IndexOf('GMT/UTC')+8)
       # $tempDT = $tempST.substring($tempST.IndexOf('GMT/UTC')+8)
       # $DTZ = ($tempDT.substring(0, ($tempDT.Indexof("during Daylight")-2))).trim()
       # $STZ = ($tempST.substring(0, ($tempST.Indexof("during Standard")-2))).trim()

       # $date -match (get-date).DayOfWeek
       # Type is of System.Date

       #$currentdate = Get-Date -format "dddd, MMM d, yyyy"
       # Friday, May 13, 2022
       # type is of string

       # $currentTZ = Get-Date -UFormat "%Z"
       # Â±XX format

       # $currentTime = Get-Date -format "HH:mm tt"

       $concatDateTime = $date + " " + $time
       $webDateTime = get-date $concatDateTime
       $currentDateTime = Get-Date
       $difference = $webDateTime - $currentDateTime
       $minutes = [Math]::Round($difference.totalminutes,0)

       # if ($DTZ -ne $currentTZ){
       
       # }
   
       if ($minutes -gt 5 -or $minutes -lt -5){
          #Start-sleep -seconds 15
          set-date $webDateTime
       }
       }

       # $DTZ = $DTZ -replace '\s'
       # $DTZ = $DTZ -as [int]
       # $currentTZ = $currentTZ -as [int]

       # $STZ = $STZ -replace '\s'
       # $STZ = $STZ -as [int]

       # $DaylightSavingsEnd = Get-Date "Sunday, November 6, 2022 2:00 AM"
       # $TMinusMinutes = $DaylightSavingsEnd - $webDateTime

       # if ($TMinusMinutes.totalminutes -lt 0){
      
       # }

       # $getTZList = get-timezone -listavailable | Where-Object {$_.BaseUtcOffset -like '*-05*'}
