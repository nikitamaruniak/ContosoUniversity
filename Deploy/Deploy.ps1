Param(
	[Parameter(Mandatory=$true)]
	[String]$BuildNumber,
	[Parameter(Mandatory=$true)]
	[ValidateScript({Test-Path -PathType Container $_})]
	[String]$PackagePath
)

function RunEntityFrameworkMigration
{
    Write-Verbose "EntityFramework database migration started..."
    $MigrateToolPath = Local "EntityFramework\migrate.exe"
    $originalWD=$PWD
    $errorCode=0
    try
    {      
        CD $($FullPackagePath + "\bin")

        $args=@(
            "ContosoUniversity.dll",
            "/startUpConfigurationFile=..\Web.config",
            "/startUpDirectory=.",
            "/Verbose")

        & $MigrateToolPath $args
        
        $errorCode=$LASTEXITCODE
    }
    finally
    {
        CD $originalWD
    }
    if ($errorCode -ne 0) {
        throw "Database migration failed."
    }
    Write-Information "EntityFramework database migration completed."
}

function Local(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$FileName
)
{
    Join-Path $PSScriptRoot $FileName
}

$FullPackagePath = $(Get-Item $PackagePath).FullName

Write-Verbose "Deployment started..."
Write-Verbose $("Build number: {0}" -f $BuildNumber)
Write-Verbose $("Package path: {0}" -f $FullPackagePath)

RunEntityFrameworkMigration
