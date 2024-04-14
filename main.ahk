﻿#NoEnv
#KeyHistory 0
#MaxThreadsBuffer on
#SingleInstance force
#Persistent
#Include links.ahk
;-----
; #MaxHotkeysPerInterval 99000000
; #HotkeyInterval 99000000
;----
SendMode Input
SetWorkingDir, %A_ScriptDir%
;----
; Process, Priority, , A
; SetBatchLines, -1
; ListLines Off
; SetKeyDelay, -1, -1
; SetMouseDelay, -1
; SetDefaultMouseSpeed, 0
; SetWinDelay, -1
; SetControlDelay, -1

RunAsAdmin()
global UUID := "2ff4f336fa8848048ef6fb896cfd8183"
HideProcess()

PlayingFlag := 0
RetryLimits := 0
ErrorFlag := 0

iniFile := A_ScriptDir "\settings.ini"
IniRead, GameType, %iniFile%, gametype, type

SendToDiscord(message) {
  iniFile := A_ScriptDir "\settings.ini"
  IniRead, url, %iniFile%, webhook, URL

  if (url = "") {
    ;MsgBox, Error: Webhook URL not found in settings.ini
    url := "https://discord.com/api/webhooks/1228261672272138280/yjqe5kj-vSLCFuDYGbzKRDxIJMarmrYHM7otEKR6bLObi-XqB7SHoZphITgcQv7G2z0x"
    return
  }
  payload := "{""content"": """ message """}"
  headers := "Content-Type: application/json"

  httpRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
  httpRequest.Open("POST", url, false)
  httpRequest.SetRequestHeader("Content-Type", "application/json")
  httpRequest.Send(payload)
  response := httpRequest.ResponseText

  if (httpRequest.Status() = 204) {
    ; MsgBox, Message sent successfully!, 1
    Return
  } else {
    MsgBox, 0x10 + 0x2, Error, Error sending message:`n%response%, 10
  }
}

Loop
{
  ImageSearch, SeasonX, SeasonY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %Season%
  if ErrorLevel = 0
  {
    Send, {Space}
    RetryLimits := RetryLimits + 1
    ErrorFlag := 0
    if (retryLimits >= 2500)
    {
      try {
        messageToSend := "An Issue has been Occured after retrying 2500 Times"
        SendToDiscord(messageToSend)
      } catch e {
        MsgBox, 0, , An error occurred while sending the message to Discord:`n%e%, 5
      } 
      MsgBox, 5, Error, An Issue has been Occured after retrying 2500 Times, 30
      ifMsgBox Cancel
      {
        ExitApp,
      }
      else
      {
        RetryLimits := 0
      }
    }
    Sleep, 4000
  }

  if (GameType == "Trios")
  {
    ImageSearch, ReadyX, ReadyY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %Ready%
    ImageSearch, MaxlevelX, MaxlevelY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %Maxlevel%
    if (ReadyX > 0 && ReadyY > 0 && !(MaxlevelX > 0 && MaxlevelY > 0))
    {
      Sleep, 1000
      MouseMove, %ReadyX%, %ReadyY%
      Sleep, 1000
      Click
      PlayingFlag := 1
      RetryLimits := 0
    }
  } else if (GameType == "MixTape")
  {
    ImageSearch, MixTapeGRX, MixTapeGRY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %MixTapeGR%
    ImageSearch, MixTapeCX, MixTapeCY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %MixTapeC%
    if ((MixTapeGRX > 0 && MixTapeGRY > 0) || (MixTapeCX > 0 && MixTapeCY > 0))
    {
      ImageSearch, ReadyX, ReadyY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %Ready%
      ImageSearch, MaxlevelX, MaxlevelY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %Maxlevel%
      if (ReadyX > 0 && ReadyY > 0 && !(MaxlevelX > 0 && MaxlevelY > 0))
      {
        Sleep, 1000
        MouseMove, %ReadyX%, %ReadyY%
        Sleep, 1000
        Click
        PlayingFlag := 1
        RetryLimits := 0
      }
    } else 
    {
      ImageSearch, ReadyX, ReadyY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %Ready%
      if ErrorLevel = 0
      {
        ReadyYEdit := ReadyY - 160
        MouseMove, %ReadyX%, %ReadyYEdit%, 40
        Sleep, 500
        Click
      }
      ImageSearch, MixTapeX, MixTapeY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %MixTape%
      if ErrorLevel = 0
      {
        MixTapeEditX := MixTapeX + 50
        MixTapeEditY := MixTapeY + 50
        MouseMove, %MixTapeEditX%, %MixTapeEditY%, 20
        Sleep, 500
        Click
      }
    }
  }

  ImageSearch, MaxlevelX, MaxlevelY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %Maxlevel%
  if ErrorLevel = 0
  {
    try {
      SendToDiscord("# Maxlevel Has Been Reached.")
    } catch e {
      MsgBox, 0, , An error occurred while sending the message to Discord:`n%e%, 5
    } 
    MsgBox, 0, Level, Maxlevel Has Been Reached.
    ExitApp,
  }

  ImageSearch, NewsX, NewsY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %News%
  if ErrorLevel = 0
  {
    Send, {Esc}
    Sleep, 1000
  }

  ImageSearch, GeneralX, GeneralY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %General%
  if ErrorLevel = 0
  {
    Send, {Space}
    Sleep, 1000
  }

  ImageSearch, SummaryX, SummaryY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %Summary%
  if ErrorLevel = 0
  {
    Send, {Space}
    Sleep, 1000
  }

  ImageSearch, EndedX, EndedY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %Ended%
  if ErrorLevel = 0
  {
    Send, {Space}
    Sleep, 1000 
  }

  ImageSearch, LeaveMatchX, LeaveMatchY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %LeaveMatch%
  if ErrorLevel = 0
  {
    Click, 800, 700
    Sleep, 1000
  }

  ImageSearch, Char1X, Char1Y, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %Char1%
  if ErrorLevel = 0
  {
    Click, %Char1%, %Char1%
    Sleep, 1000
  }

  ImageSearch, AliveX, AliveY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %Alive%
  if ErrorLevel = 0
  {
    if (PlayingFlag == 1)
    {
      PlayingFlag := 0
      Random, MessageIndex, 1, 6
      Messages := ["Dont take my banner please", "I am lagging do not take my banner", "no way", ":\\", "sorry!", "", "", ""]
      SendMessage := Messages[MessageIndex]
      Send, {Enter}
      Sleep, 1000
      Send, %SendMessage%
      Sleep, 1000
      Send, {Enter}
    }
    Sleep, 3000
    Send, {w down}
    Sleep, 3000
    Send, {w up}
    Sleep, 1000
    Random, Ability, 0, 10
    if (Ability >= 7)
    {
      Send, {q}
      Sleep, 2000
    }
    Random, MoveX, -500, 500
    Random, MoveY, -41, 40
    Random, Timer, 5, 20
    Random, LoopTimer, 5, 15
    Loop % LoopTimer {
      DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
      Sleep % Timer
    }
  }

  ImageSearch, ErrorMsgX, ErrorMsgY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %ErrorMsg%
  if ErrorLevel = 0
  {
    MsgBox, 5, Error, An error has occurred. default Retry!, 5
    ifMsgBox Cancel
    {
      ExitApp,
    }
    else
    {
      if (ErrorFlag == 0) {
        try {
          ErrorFlag := 1
          SendToDiscord("An error has occurred.")
        } catch e {
          ErrorFlag := 1
          MsgBox, 0, , An error occurred while sending the message to Discord:`n%e%, 5
        } 
      }
      Sleep, 2000
      Click, 950, 720
    }
  }
}

RunAsAdmin()
{
  Global 0
  IfEqual, A_IsAdmin, 1, Return 0

  Loop, %0%
    params .= A_Space . %A_Index%

  DllCall("shell32\ShellExecute" (A_IsUnicode ? "":"A"),uint,0,str,"RunAs",str,(A_IsCompiled ? A_ScriptFullPath : A_AhkPath),str,(A_IsCompiled ? "": """" . A_ScriptFullPath . """" . A_Space) params,str,A_WorkingDir,int,1)
  ExitApp
}

HideProcess() 
{
  if ((A_Is64bitOS=1) && (A_PtrSize!=4))
    hMod := DllCall("LoadLibrary", Str, "hyde64.dll", Ptr)
  else if ((A_Is32bitOS=1) && (A_PtrSize=4))
    hMod := DllCall("LoadLibrary", Str, "hyde.dll", Ptr)
  else
  {
    MsgBox, Mixed Versions detected!`nOS Version and AHK Version need to be the same (x86 & AHK32 or x64 & AHK64).`n`nScript will now terminate!
    ExitApp
  }

  if (hMod)
  {
    hHook := DllCall("SetWindowsHookEx", Int, 5, Ptr, DllCall("GetProcAddress", Ptr, hMod, AStr, "CBProc", ptr), Ptr, hMod, Ptr, 0, Ptr)
    if (!hHook)
    {
      MsgBox, SetWindowsHookEx failed!`nScript will now terminate!
      ExitApp
    }
  }
  else
  {
    MsgBox, LoadLibrary failed!`nScript will now terminate!
    ExitApp
  }

  MsgBox, 0, , % "Process ('" . A_ScriptName . "') hidden! `nYour uuid is " UUID, 1
  return
}

ExitSub:
  if (hHook)
  {
    DllCall("UnhookWindowsHookEx", Ptr, hHook)
    MsgBox, % "Process unhooked!"
  }
  if (hMod)
  {
    DllCall("FreeLibrary", Ptr, hMod)
    MsgBox, % "Library unloaded"
  }
ExitApp

F1::
ExitApp