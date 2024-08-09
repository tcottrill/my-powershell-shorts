### 7-29-2016 Tim Cottrill
## Updated Form "Ding" suppression 2024
## This code allows you to get a list fo user groups from AD in a copy-pasteable format. Very handy and frustrating that ADUC doesn't allow this. 

## Note: LoadWithPartialName is Deprecated
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

## Main Form
$Form = New-Object System.Windows.Forms.Form
$Form.Size = New-Object System.Drawing.Size(500,600)
$Form.Text = "Get User Groups"
## Make it Non-Resizeable
$Form.FormBorderStyle=[System.Windows.Forms.FormBorderStyle]::FixedDialog
##Set the Form Icon
$Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($PSHOME + "\Powershell.exe")
$Form.Icon = $Icon

$Form.KeyPreview = $true 

## Handle the Enter Key "Ding" for the $InputBox and allow "Esc" to exit the form. 

$Form.Add_KeyDown{
    param 
    ( 
        [Parameter(Mandatory)][Object]$sender,
        [Parameter(Mandatory)][System.Windows.Forms.KeyEventArgs]$e
    )
    if($_.KeyCode -eq "Escape")
    {
        $Form.close()
    }

    if ($_.KeyCode -eq "Enter")
    {
      ## Supress the "Ding Noise when hitting enter
    $_.Handled = $True;
    $_.SuppressKeyPress = $True;
    ## Return the function
    $strReturn=userInfo
    }
}


########## Start Functions ##############
## Textbox Input
function userInfo
{
    $wks=$InputBox.text;
    try
    {
       $groupResult=Get-ADPrincipalGroupMembership $wks | select name | out-string;
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityResolutionException]
    {
        $groupResult = "User not found!"
    }

## foreach($groupResult in $groupResult) { -join "'n" ]
##$groupResult = $groupResult.Trim()
##-join "' n"

$outputBox.text=$groupResult
##outputBox
} #end

########## End Functions ##############

########## Start Text Fields ##########

$InputBox = New-Object System.Windows.Forms.Textbox
$InputBox.Location = New-Object System.Drawing.Size(20,40)
$InputBox.Font = "Tahoma,11"
$InputBox.Size = New-Object System.Drawing.Size(150,20)


$Form.Controls.Add($InputBox)

$outputBox = New-Object System.Windows.Forms.Textbox
$outputBox.Location = New-Object System.Drawing.Size(10,90)
$outputBox.Font = "Tahoma,11" 
$outputBox.Size = New-Object System.Drawing.Size(480,450)
$outputBox.MultiLine = $True
##added to fix spacing
$outputBox.Wordwrap = $False 
$outputBox.Scrollbars = "Vertical"
$Form.Controls.Add($outputBox)

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(17,15)
$objLabel.Size = New-Object System.Drawing.Size(280,20)
$objLabel.Text = "Please enter the samaccount name:"
$Form.Controls.Add($objLabel)

########## End Text Fields ##########

########## Start Buttons ##########

$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(350,30)
$Button.Size = New-Object System.Drawing.Size(80,50)
$Button.Text = "Groups"
$Button.Add_Click({userinfo})
$Form.Controls.Add($Button)


########## End Buttons ##########

$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()



