#-------------------------------------------------------------------------------
# Displays how to use this script.
#-------------------------------------------------------------------------------
function Help {
	"Sets the AssemblyVersion and AssemblyFileVersion of AssemblyInfo.cs files`n"
	".\SetVersion.ps1 VersionNumber`n"
	"   VersionNumber    The version number to set, for example: 1.1.9301.0"
	"                    If not provided, a version number will be generated.`n"
}
 
#-------------------------------------------------------------------------------
# Update version numbers of AssemblyInfo.cs
#-------------------------------------------------------------------------------
function Update-AssemblyInfoFiles ([string] $version) {
	$assemblyVersionPattern = 'AssemblyVersion\("[0-9]+(\.([0-9]+|\*)){1,3}"\)'
	$fileVersionPattern = 'AssemblyFileVersion\("[0-9]+(\.([0-9]+|\*)){1,3}"\)'
	$assemblyVersion = 'AssemblyVersion("' + $version + '")';
	$fileVersion = 'AssemblyFileVersion("' + $version + '")';
	
	Get-ChildItem -r -filter AssemblyInfo.cs | ForEach-Object {
		$filename = $_.Directory.ToString() + '\' + $_.Name
		$filename + ' -> ' + $version
		
		# If you are using a source control that requires to check-out files before 
		# modifying them, make sure to check-out the file here.
		# For example, TFS will require the following command:
		# tf checkout $filename
	
		(Get-Content $filename) | ForEach-Object {
			% {$_ -replace $assemblyVersionPattern, $assemblyVersion } |
			% {$_ -replace $fileVersionPattern, $fileVersion }
		} | Set-Content $filename
	}
}

#-------------------------------------------------------------------------------
# Parse arguments.
#-------------------------------------------------------------------------------
if ($args -ne $null) {
	$version = $args[0]
	if (($version -eq '/?') -or ($version -notmatch "[0-9]+(\.([0-9]+|\*)){1,3}")) {
		Help
		exit 1;
	}
} else {
	Help
	exit 1;
}

Update-AssemblyInfoFiles $version




