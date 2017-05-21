# ================================================================
#     Preformated messages
# ================================================================ 
function success([string] $msg ){
    Write-host "****************************************************"  -foreground green
    Write-host "[SUC] - " -foreground green  -NoNewline
    Write-host $msg -foreground white 
    Write-host "****************************************************"  -foreground green
}
function fail([string] $msg ){
    Write-host "****************************************************"  -foreground red
    Write-host "[FAL] -"$msg -foreground red
    Write-host "****************************************************"  -foreground red
}
function error([string] $msg ){
    Write-host "****************************************************"  -foreground red
    Write-host "[ERR] - " -foreground red  -NoNewline
    Write-host $msg -foreground white 
    Write-host "****************************************************"  -foreground red
}
function warning([string] $msg ){
    Write-host "****************************************************"  -foreground yellow
    Write-host "[WRN] - " -foreground yellow  -NoNewline
    Write-host $msg -foreground white 
    Write-host "****************************************************"  -foreground yellow
}
function warning2([string] $msg1, [string] $msg2){
    Write-host "****************************************************"  -foreground yellow
    Write-host "[WRN] - " -foreground yellow  -NoNewline
    Write-host $msg1 -foreground white 
    Write-host $msg2 -foreground white 
    Write-host "****************************************************"  -foreground yellow
}
function info([string] $msg ){
    Write-host "[INF] - " -foreground cyan  -NoNewline
    Write-host $msg -foreground white 
}
function message([string] $msg ){
    Write-host $msg -foreground cyan
}
