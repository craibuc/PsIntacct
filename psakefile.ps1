FormatTaskName "-------- {0} --------"

Task default -depends Publish

Task Publish {
    publish-module -name ./PsIntacct -Repository Lorenz
}