# ================================================================
#     Visual Countdown instead of plain sleep
# ================================================================ 
function countdown ($counter) {

    :outer while ($counter -gt 0) {
        Write-host -NoNewline "Count Down $counter `r"
        $innerLoop = 10
        while ($innerLoop -gt 0) {
            Start-Sleep -m 100 

            if ([console]::KeyAvailable)
            {
                $x = [console]::ReadKey("noecho")
                break outer
            }
            $innerLoop = $innerLoop - 1
        }
        $counter = $counter - 1
    }
    Write-host "Count Down $counter   "
}