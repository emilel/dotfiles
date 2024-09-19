# issues

### can only see dummy audio output

```
sudo alsa force-reload
```

```
echo "blacklist snd_soc_avs" | sudo tee /etc/modprobe.d/blacklist-snd-soc-avs.conf
sudo update-initramfs -u
```

### waybar doesn't show up

```
systemctl --user status xdg-desktop-portal
```

### git shit

```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```
