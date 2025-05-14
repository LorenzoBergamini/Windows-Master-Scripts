# Windows Master Scripts

🧰 Un piccolo assistente GUI per configurare velocemente un'installazione pulita di Windows.

Questo tool consente agli utenti di selezionare i programmi essenziali da installare (via Winget), configurare DNS Cloudflare e avviare un comando di attivazione per Windows/Office — tutto tramite un'interfaccia semplice a 3 step.

---

## 🔧 Funzionalità

✅ Selezione programmi con checkbox  
✅ Impostazione DNS Cloudflare (1.1.1.1 / 1.0.0.1)  
✅ Comando PowerShell di attivazione  
✅ Interfaccia GUI in PowerShell (WinForms)  
✅ Nessuna dipendenza esterna: basta Windows 10/11

---

## 📦 Programmi inclusi

Alcuni dei software selezionabili:

- 7-Zip
- Firefox
- Google Drive
- Discord
- Malwarebytes
- VLC
- Steam
- VS Code
- Revo Uninstaller  
...e altri ancora.

L'elenco completo si trova nello script `WindowsMasterScripts.ps1`.

---

## ▶️ Come si usa

1. Scarica o compila l'eseguibile `WindowsMasterScripts.exe`  
2. Avvialo come amministratore  
3. Segui i 3 passaggi della GUI  
4. Il programma installerà i software scelti e applicherà le opzioni selezionate

---

## 🛠 Compilazione manuale (opzionale)

Per compilare il file `.ps1` in `.exe` con [ps2exe](https://www.powershellgallery.com/packages/ps2exe):

```powershell
powershell -ExecutionPolicy Bypass -Command "& {
  Import-Module ps2exe
  Invoke-PS2EXE -InputFile 'WindowsMasterScripts.ps1' -OutputFile 'WindowsMasterScripts.exe' -icon 'icon.ico' -noConsole -title 'Windows Master Scripts'
}"
