# Arch config

## NetworkManager

Packages:

- `networkmanager`
- `network-manager-applet`

```
systemctl enable NetworkManager
```

Add to `.xinitrc`:

```
nm-applet &
```

## X server and awesome window manager

Packages:

- `xorg` (package group)
- `xinit`
- `xf86-video-intel`
- `mesa`
- `vulkan-intel`
- `arandr`

`.xinitrc`:

```
export GTK_THEME=Adwaita:dark

setxkbmap us -variant intl
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xbindkeys
xset dpms
xset s dpms 600 600 1200
xset r rate 200 30

xrandr --output DP1-2 --mode 1920x1200 --right-of eDP1
nm-applet &
exec awesome
```

Links:

- https://codelinks.pachanka.org/post/42559163809/awesome-window-manager-keyboard-shortcuts

## AUR

```
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si
```

## Laptop

### Battery level

Packages:

- `acpi`

### Touchpad

Packages:

- `xf86-input-libinput`

`/etc/X11/xorg.conf.d/30-touchpad.conf`

```
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "TapButton1" "1"
        Option "TapButton2" "3"
        Option "TapButton3" "2"
        Option "VertEdgeScroll" "on"
        Option "VertTwoFingerScroll" "on"
        Option "HorizEdgeScroll" "on"
        Option "HorizTwoFingerScroll" "on"
        Option "CircularScrolling" "on"
        Option "CircScrollTrigger" "2"
        Option "EmulateTwoFingerMinZ" "40"
        Option "EmulateTwoFingerMinW" "8"
        Option "CoastingSpeed" "0"
        Option "FingerLow" "30"
        Option "FingerHigh" "50"
        Option "MaxTapTime" "125"
	Option "Tapping" "on"
	Option "ClickMethod" "clickfinger"
EndSection
```

#### libinput-gestures

Unofficial tool from https://github.com/bulletmark/libinput-gestures

Install:

```
sudo pacman -S xdotool wmctrl
git clone https://github.com/bulletmark/libinput-gestures.git
cd libinput-gestures
sudo make install
```

In `~/.config/libinput-gestures.conf`:

```
gesture swipe right xdotool key alt+Right
gesture swipe left xdotool key alt+Left
```

Autostart, start, reload:

```
libinput-gestures-setup autostart
libinput-gestures-setup start
libinput-gestures-setup restart
```

### Backlight

Packages:

- `light` (AUR)

Append to `~/.xbindkeysrc`

```
"light -U 10"
  XF86MonBrightnessDown

"light -A 10"
  XF86MonBrightnessUp
```

## Fonts and customizations

Fantasque font installation: download from https://github.com/belluzj/fantasque-sans/releases and:

```
unzip FantasqueSansMono-Normal.zip
sudo mv OTF TTF Webfonts /usr/share/fonts/
fc-cache
```

Copy [Xresources](Xresources) to `~/.Xresources`

## Emacs

Copy [emacs.el](emacs.el) to `~/.emacs`

## Various packages

```
unzip chromium htop git go pandoc python
```

AUR:

```
vivaldi vivaldi-codecs-ffmpeg-extra-bin
```
