# Tidy SDDM
A tidy theme for [SDDM](https://github.com/sddm/sddm) Qt6

*Create your own custom color palette or use one of the 20+ palettes included in the theme.conf file*

## Previews
![Breeze Dark](previews/Breeze-Dark.png)
<img src="previews/Zebra.png" width="45%" alt="Zebra"></img>
<img src="previews/Burichan.png" width="45%" alt="Burichan"></img>
<img src="previews/Catppuccin-Mocha.png" width="45%" alt="Catppuccin Mocha"></img>
<img src="previews/Ambiance.png" width="45%" alt="Ambiance"></img>

## Dependencies
- sddm
- qt6 >= 6.7
- qt6-declarative (Qt Quick)
- qt6-svg

## Install
1. Either download and extract the tidy-sddm.tar.xz from the [releases](https://github.com/loadfred/tidy-sddm/releases/latest) or use `git clone`

```
git clone https://github.com/loadfred/tidy-sddm
```

2. Move this entire repository to `/usr/share/sddm/themes/`

```
sudo mv ./tidy-sddm /usr/share/sddm/themes/
```

3. Create and edit `/etc/sddm.conf` to say ...

```
[Theme]
Current=tidy-sddm
```

## .face.icon
If you want a user avatar, copy any image to your home folder and name it `.face.icon`

NOTE: If no image is shown, SDDM needs permission to open your home folder, this can be done with ...

`sudo chmod o+X /home/myuser`

## theme.conf
Everything configurable is listed and explained in the [`theme.conf`](theme.conf)

```
[General]
layoutMirroring=false
chooseUser=false
militaryTime=false
disableTopHalfColor=false
fontPointSize=11
fontFamily=Inter
background=
icons=kora
palette=Blender
```

### Background
For a background image, you may select it from the KDE system settings (sddm-kcm), otherwise enter the path ...

`background=trees.png` if image is in the tidy-sddm folder (preferred)

`background=/home/myuser/Pictures/greenforest.png` see the note below

NOTE: If no image is shown, SDDM needs permission to open your home folder, this can be done with ...

`sudo chmod o+X /home/myuser`

If no background is defined the base and window colors from your chosen palette will be used for the background

### Icons
You may choose either adwaita, breeze, or kora

`icons=breeze`

### Palettes
There are 20+ different color palettes in the config ready to use

`palette=Breeze Dark`

You may create your own color palette using Hex codes (#ffa03d) or color names (orange) using the following properties ...

```
[Palette Name]
base=
highlight=
highlightedText=
shadow=
text=
window=
windowText=
```

The majority of the palettes written in `theme.conf` are from [lxqt-themes](https://github.com/lxqt/lxqt-themes/tree/master/palettes)

#### Palette groups
You may create a group within a palette for an easy color change on a specific property or multiple properties

The group name is written before the property with a `/` seperating them: `Red Group/base=#f00`

The palette's group can be chosen with `palette=Palette Name/Red Group`

Here's an example ...
```
[Gruvbox Dark]
base=#282828
### Default highlight
highlight=#928374
### Various highlight colors, chosen with "palette=Gruvbox Dark/yellow"
red/highlight=#fb4934
yellow/highlight=#fabd2f
green/highlight=#b8bb26
aqua/highlight=#8ec07c
blue/highlight=#83a598
purple/highlight=#d3869b
highlightedText=#1d2021
shadow=black
text=#d5c4a1
window=#3c3836
windowText=#ebdbb2
```
The palette above can be chosen with either `palette=Gruvbox Dark`, `palette=Gruvbox Dark/yellow`, `palette=Gruvbox Dark/purple`, etc.
