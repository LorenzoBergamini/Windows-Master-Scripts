<#
QuickSetup.ps1 - 3-step wizard for a fresh Windows install
Author: LorenzoBergamini
License: MIT

Compile to EXE (requires PS2EXE):
  ps2exe .\QuickSetup.ps1 .\QuickSetup.exe -noConsole -title "QuickSetup"

Step 1 - Programmi   - l'utente seleziona i software (winget)
Step 2 - DNS         - spiega Cloudflare DNS e lo abilita con un flag
Step 3 - Attivazione - spiega il comando di attivazione e offre un flag

Alla fine il tool esegue le azioni scelte.
#>

param()

######################### Elevation ###########################################
function Test-Elevation {
    $principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if (-not (Test-Elevation)) {
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `\"$PSCommandPath`\"" -Verb RunAs
    exit
}

######################### Package list ########################################
$packages = @(
    @{ Name='7-Zip';              Id='7zip.7zip';                       Checked=$true  },
    @{ Name='Discord';            Id='Discord.Discord';                Checked=$true  },
    @{ Name='Google Drive';       Id='Google.Drive';                   Checked=$true  },
    @{ Name='HandBrake';          Id='HandBrake.HandBrake';            Checked=$false },
    @{ Name='iCloud';             Id='Apple.iCloud';                   Checked=$false },
    @{ Name='iTunes';             Id='Apple.iTunes';                   Checked=$false },
    @{ Name='JDK (Oracle 17)';    Id='Oracle.JDK.17';                  Checked=$false },
    @{ Name='JDownloader 2';      Id='AppWork.JDownloader';            Checked=$true  },
    @{ Name='Malwarebytes';       Id='Malwarebytes.Malwarebytes';      Checked=$true  },
    @{ Name='VS Code';            Id='Microsoft.VisualStudioCode';     Checked=$false },
    @{ Name='Firefox';            Id='Mozilla.Firefox';                Checked=$true  },
    @{ Name='GeForce Experience'; Id='Nvidia.GeForceExperience';       Checked=$false },
    @{ Name='OBS Studio';         Id='OBSProject.OBSStudio';           Checked=$false },
    @{ Name='Oracle VirtualBox';  Id='Oracle.VirtualBox';              Checked=$false },
    @{ Name='Proton VPN';         Id='ProtonTechnologies.ProtonVPN';   Checked=$true  },
    @{ Name='Python 3';           Id='Python.Python.3.11';             Checked=$false },
    @{ Name='qBittorrent';        Id='qBittorrent.qBittorrent';        Checked=$true  },
    @{ Name='Revo Uninstaller';   Id='RevoUninstaller.RevoUninstaller';Checked=$true  },
    @{ Name='Steam';              Id='Valve.Steam';                    Checked=$true  },
    @{ Name='Stremio';            Id='Stremio.Stremio';                Checked=$false },
    @{ Name='Syncplay (Beta)';    Id='Syncplay.Syncplay.Beta';         Checked=$false },
    @{ Name='Tailscale';          Id='tailscale.tailscale';            Checked=$false },
    @{ Name='Telegram';           Id='Telegram.TelegramDesktop';       Checked=$false },
    @{ Name='VLC';                Id='VideoLAN.VLC';                   Checked=$true  },
    @{ Name='WhoCrashed';         Id='Resplendence.WhoCrashed';        Checked=$true  }
)

######################### GUI #################################################
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
$form              = New-Object System.Windows.Forms.Form
$form.Text         = 'Quick Setup Wizard'
$form.Size         = [System.Drawing.Size]::new(520,620)
$form.StartPosition= 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox  = $false

# navigation buttons
$backBtn           = New-Object System.Windows.Forms.Button
$nextBtn           = New-Object System.Windows.Forms.Button
$backBtn.Text      = 'Back'
$nextBtn.Text      = 'Next'
$backBtn.Enabled   = $false
$backBtn.Size      = $nextBtn.Size = [System.Drawing.Size]::new(75,30)
$backBtn.Location  = [System.Drawing.Point]::new(260,540)
$nextBtn.Location  = [System.Drawing.Point]::new(360,540)
$form.Controls.AddRange(@($backBtn,$nextBtn))

# panels
$panels = @()
for ($i=0;$i -lt 3;$i++) {
    $p = New-Object System.Windows.Forms.Panel
    $p.Size = [System.Drawing.Size]::new(500,520)
    $p.Location = [System.Drawing.Point]::new(10,10)
    $p.Visible = $false
    $form.Controls.Add($p)
    $panels += $p
}

########## step 1 - program list ##############################################
$clb = New-Object System.Windows.Forms.CheckedListBox
$clb.CheckOnClick = $true
$clb.Size   = [System.Drawing.Size]::new(480,480)
$clb.Location = [System.Drawing.Point]::new(0,0)
$panels[0].Controls.Add($clb)
foreach ($pkg in $packages) {
    $i = $clb.Items.Add($pkg.Name)
    if ($pkg.Checked) { $clb.SetItemChecked($i,$true) }
}

########## step 2 - DNS #######################################################
$dnsLabel      = New-Object System.Windows.Forms.Label
$dnsLabel.Size = [System.Drawing.Size]::new(480,120)
$dnsLabel.Location = [System.Drawing.Point]::new(0,0)
$dnsLabel.Font = New-Object System.Drawing.Font('Segoe UI',10)
$dnsLabel.Text = 'Il DNS (Domain Name System) traduce i nomi dei siti (es. "example.com") in indirizzi IP. Con questa opzione imposteremo i server DNS di Cloudflare (1.1.1.1 / 1.0.0.1) per maggiore privacy e velocità.'
$dnsCheck      = New-Object System.Windows.Forms.CheckBox
$dnsCheck.Text = 'Imposta DNS Cloudflare'
$dnsCheck.Location = [System.Drawing.Point]::new(0,140)
$dnsCheck.Checked = $true
$panels[1].Controls.AddRange(@($dnsLabel,$dnsCheck))

########## step 3 - activation ################################################
$actLabel      = New-Object System.Windows.Forms.Label
$actLabel.Size = [System.Drawing.Size]::new(480,60)
$actLabel.Location = [System.Drawing.Point]::new(0,0)
$actLabel.Font = New-Object System.Drawing.Font('Segoe UI',10)
$actLabel.Text = 'Esegui il comando di attivazione (utile per Windows / Office).'
$actCheck      = New-Object System.Windows.Forms.CheckBox
$actCheck.Text = 'Esegui attivazione'
$actCheck.Location = [System.Drawing.Point]::new(0,70)
$actCheck.Checked = $true
$panels[2].Controls.AddRange(@($actLabel,$actCheck))

######################### Wizard navigation ###################################
$script:page = 0
$panels[$script:page].Visible = $true

function Update-Nav {
    $backBtn.Enabled = $script:page -gt 0
    $nextBtn.Text    = if ($script:page -lt ($panels.Count-1)) { 'Next' } else { 'Start' }
}

$backBtn.Add_Click({
    if ($script:page -gt 0) {
        $panels[$script:page].Visible = $false
        $script:page--
        $panels[$script:page].Visible = $true
        Update-Nav
    }
})

$nextBtn.Add_Click({
    if ($script:page -lt ($panels.Count-1)) {
        $panels[$script:page].Visible = $false
        $script:page++
        $panels[$script:page].Visible = $true
        Update-Nav
    } else {
        $backBtn.Enabled = $nextBtn.Enabled = $false
        Start-Setup
    }
})

Update-Nav

######################### Core logic ##########################################
function Start-Setup {

    ## progress bar -----------------------------------------------------------
    $prog               = New-Object System.Windows.Forms.ProgressBar
    $prog.Size          = [System.Drawing.Size]::new(480,20)
    $prog.Location      = [System.Drawing.Point]::new(10,510)
    $prog.Minimum       = 0
    $prog.Maximum       = $packages.Count
    $form.Controls.Add($prog)

    ## 1) install packages via winget ----------------------------------------
    $wingetCmd = Get-Command winget -ErrorAction SilentlyContinue
    if ($null -eq $wingetCmd) {
        [System.Windows.Forms.MessageBox]::Show(
            'Winget non è disponibile. Installazione software saltata.',
            'Errore', 'OK', 'Error')
    }
    else {
        $ids = @()
        for ($i = 0; $i -lt $clb.Items.Count; $i++) {
            if ($clb.GetItemChecked($i)) { $ids += $packages[$i].Id }
        }

        foreach ($id in $ids) {
            $prog.PerformStep()
            Start-Process winget -ArgumentList `
                "install --id $id -e --accept-package-agreements --accept-source-agreements --silent" `
                -NoNewWindow -Wait
        }
    }

    ## 2) set DNS if requested ----------------------------------------------
    if ($dnsCheck.Checked) {
        Get-DnsClient |
            Where-Object { $_.InterfaceAlias -notmatch 'Loopback' } |
            ForEach-Object {
                Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex `
                                            -ServerAddresses '1.1.1.1','1.0.0.1'
            }
    }

    ## 3) run activation if requested ---------------------------------------
    if ($actCheck.Checked) {
        Invoke-Expression (Invoke-RestMethod 'https://get.activated.win')
    }

    ## finish ---------------------------------------------------------------
    [System.Windows.Forms.MessageBox]::Show(
        'Operazioni completate.',
        'Fine', 'OK', 'Information')

    $form.Close()
}

######################### Show dialog #########################################
[void]$form.ShowDialog()
