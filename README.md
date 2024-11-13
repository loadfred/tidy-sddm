# Tidy SDDM
A tidy theme for SDDM Qt6

Create your own custom palette

## Previews
![Breeze Dark](previews/Breeze-Dark.png)
![Zebra](previews/Zebra.png)
![Burichan](previews/Burichan.png)
![Catppuccin Mocha](previews/Catppuccin-Mocha.png)
![Ambiance](previews/Ambiance.png)


## Dependencies
- sddm
- qt6 >= 6.7
- qt6-declarative (Qt Quick)
- qt6-svg

## Install
Move this entire repository to `/usr/share/sddm/themes/`

```
git clone https://github.com/loadfred/tidy-sddm
sudo mv ./tidy-sddm /usr/share/sddm/themes/
```

Create and edit `/etc/sddm.conf` to say ...

```
[Theme]
Current=tidy-sddm
```

## .face.icon
If you want a user avatar, copy any image to your home folder and name it `.face.icon`

## theme.conf
Everything configurable is listed and explained in `theme.conf`

```
LayoutMirroring=false
ChooseUser=false
MilitaryTime=false
DisableTopHalfColor=false
FontPointSize=11
FontFamily=Inter
Background=
Icons=kora
Palette=Blender
```

### Background
For a background image, enter the full path

`Background=/home/myuser/Pictures/greenforest.png`

Otherwise the base and window colors from your chosen palette will be used for the background

### Icons
You may choose either adwaita, breeze, or kora

`Icons=breeze`

### Palettes
There are 20 different color palettes in the config ready to use

`Palette=Breeze Dark`

You may create your own color palette using Hex codes (#ffa03d)  or color names (orange) with ...

```
[Palette Name]
Base=
Highlight=
HighlightedText=
Shadow=
Text=
Window=
WindowText=
```

The majority of the palettes written in `theme.conf` are from [lxqt-themes](https://github.com/lxqt/lxqt-themes/tree/master/palettes)
