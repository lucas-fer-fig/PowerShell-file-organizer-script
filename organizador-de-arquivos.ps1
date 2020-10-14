#### SFOS ####
#
### Simple files organizer Script ###
#
## Change the work diretory to the desktop ##
##Set-Location -Path C:\Users\lucas\Desktop\ 
################################################################################

## Function that get all file extensions in the directory ##
function Get-FileExtension {
    param (
        $Files
    )

    $filesExtensionArray = [System.Collections.ArrayList]@()
    
    foreach($File in $Files){

        $fileExtension = $File.Extension

        if($filesExtensionArray -like $fileExtension){
            <# Do nothing #>
        }
        else {
            if($fileExtension -notmatch '.ps1' -and $fileExtension -notmatch '.lnk'){
                $null = $filesExtensionArray.Add($fileExtension)  
            }  
        }
    }

    return $filesExtensionArray 
}

function CreateFolder {
    param (
        $FilesExtension,
        $Path
    )
    
    foreach($extension in $FilesExtension){
        New-Item -Force -Path "$($Path)\Arquivos $($extension)" -ItemType Directory
    }
}

function MoveFiles {
    param (
        $Files,
        $Extensions,
        $Path
    )
    
    foreach($File in $Files){

        $fileName = $File.Name
        $fileExtension = $File.Extension

        if($fileExtension -notmatch '.ps1' -and $fileExtension -notmatch '.lnk'){

            if ($Extensions -like $fileExtension) {
                Move-Item -Path "$($Path)\$($fileName)" -Destination "$($Path)\Arquivos $($fileExtension)" -PassThru -ErrorAction SilentlyContinue <# -Force #>
            }
        }

    }

}


# Save the path of the current directory
$thisLocation = Get-Location

# Save all the files of the directory in an Array
$filesInDirectory = Get-ChildItem -Path $thisLocation.Path

# Get an array with all the file extensions in the folder
$fileExtensionInDirectory = Get-FileExtension -Files $filesInDirectory

# Creates the folders
CreateFolder -FilesExtension $fileExtensionInDirectory -Path $thisLocation.Path

# Move files to coresponding folders
MoveFiles -Files $filesInDirectory -Extensions $fileExtensionInDirectory  -Path $thisLocation.Path

# Debug
powershell