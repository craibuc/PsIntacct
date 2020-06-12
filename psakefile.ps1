FormatTaskName "-------- {0} --------"

Task default -depends Publish

Task Symlink {
    $Module='PsIntacct'
    $Here = Get-Location
    Push-Location ~/.local/share/powershell/Modules
    ln -s "$Here/$Module" $Module
    Pop-Location
}
  
Task Publish {
    publish-module -name ./PsIntacct -Repository Lorenz
}