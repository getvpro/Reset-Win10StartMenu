## Reset-Win10 start menu

Microsoft hasn't provided an easy way to reset the windows 10 left-side/right-side (aka TILES) start menu
This script resets both to their defaults, I was using it at a client to deal with oprhaned msresource:// items that would sometimes pop-up in the following scenario
1. Roll-out a Citrix MCS catalog update
2. Users login, and have their start menu settings captured by FSLogix windows profile containers
3. Roll-out another Citrix MCS catalog update, but with minor changes to the App-X based apps by virtue running the Citrix optimizer tool on the golden image
4. Users login, but note oprhaned msresource:// towards the bottom of the windows 10 start menu
5. We used Microsoft AD GPP's to publish this script so users could self-reset their start menu as required


## Code examples
```
Reset-Win10StartMenu
```
