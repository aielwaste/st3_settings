--
--  Created by: Andrew Bell
--  Created on: 12/29/16
--
--  Copyright (c) 2016 Fr1v
--  All Rights Reserved
--

use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

on adding folder items to theFolder after receiving theNewItems
  --  Called after items have been added to a folder
  --
  --  theFolder is a reference to the modified folder
  --  theNewItems is a list of references to the items added to the folder 
  
  --Here's what the code does:
  --1) Copy directory with installers to the startup disk (for faster installation as this code is run from a USB stick)
  --2) Install PKG files (silently)
  --3) Install DMG files (with mostly visible windows)
  --4) Return a list of all apps that were copied (hence installed)
  --
  --The Problem / Challenge (however you wish to take it):
  --1. Unreliable and unpredictable MountDMG() function (as described above)
  --2. It should be as simple as possible (too many points of failure right now) - but more I am looking for reliability over complexity.
  --
  --Feed a few DMGs and PKGs into the a folder and reference it like in the code.
  --Structure:
  --TheScript.scpt
  --Resources [folder, same location as script] - Mac Apps [sub-folder of Resources, all apps in here] - Manual Installers [sub-folder of Mac Apps]
  
  installApplications() --> ON BUTTON CLICK (from AppleScript Application in Xcode)
  
  installApplications()
  -- Define Source & Target paths and Other Variables
  tell application "Finder" to set sourceDirectory to (get (container of (path to me) as text) & "Resources:Mac Apps:") as text
  set targetDirectory to path to startup disk as text
  set localInstallersDirectory to targetDirectory & "Mac Apps:" as text
  set installedAppsList to {}
  
  try
    activate
    set confirmation to button returned of (display dialog "The system is about to install the package for Mac!" & return & return & "You may be prompted to enter the device administrator's password!" with icon 1 with title "Install Applications" buttons {"Close", "Continue"} default button 2)
    if confirmation is equal to "Continue" then
      display notification subtitle "You will be notified when done." with title "Apps are being installed. Please wait." sound name "Glass"
      my CopyInstallers(sourceDirectory, targetDirectory) --> Copy to local drive
      my InstallPKGApps(localInstallersDirectory as alias, installedAppsList) --> Install PKG Apps
      my InstallDMGApps(localInstallersDirectory as alias, installedAppsList) --> Install DMG Apps
      
      activate
      display dialog "The following applications were installed:" & return & return & ReplaceChar(installedAppsList, ",", return) with title (count of installedAppsList) & " Applications Installed" as text buttons {"Continue"} default button 1 with icon 1
      
      -- Go to Mac App Store to install OneDrive
      tell application "System Events"
        open location "macappstore://itunes.apple.com/nz/app/onedrive/id823766827?mt=12" --> Link to OneDrive
      end tell
      
      my InstallAppsManually(localInstallersDirectory) --> Alert User if Manual Installers exist
    else
      activate
      display dialog "The installer was cancelled." & return & "No applications were installed." with icon 0 with title "Application Installer Cancelled" buttons {"Exit"} default button 1 giving up after 5
    end if
    -- Install .dmg files Completed
  on error theError number errorNumber
    display dialog "There was an error:" & return & theError & return & return & "Error Number: " & errorNumber as text buttons {"OK"} with title "Fatal Error" default button 1 with icon 0
  end try
end adding folder items to
end adding folder items to

on closing folder window for theFolder
  --  Called when a folder's window is closed in the Finder
  --
  --  theFolder is a reference to the closed folder
  
  -- your code goes here
end closing folder window for

on moving folder window for theFolder from previousBounds
  --  Called when a folder's Finder window has been moved or resized
  --
  --  theFolder is a reference to the folder being altered
  --  previousBounds is old position and size of the folder's Finder window
  
  -- your code goes here
end moving folder window for

on opening folder theFolder
  --  Called when a folder's window is opened in the Finder
  --
  --  theFolder is a reference to the opened folder
  
  -- your code goes here
end opening folder

on removing folder items from theFolder after losing removedItemNames
  --  Called after items have been removed from a folder
  --
  --  theFolder is a reference to the modified folder
  --  removedItemNames is a list of names of items removed from the folder
  
  -- your code goes here
end removing folder items from
