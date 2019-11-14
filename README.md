# linux-setup
all the things I look up every time I build a new vm.

### virtual box guest settings:

```
General -> Advanced
    Shared Clipboard = Bidirectional
    Drag'nDrop = Disabled
System -> Motherboard
    Base memory=16,3834 MB
    Boot Order: Optical, Hard Disk
System -> Processor
    Processors = 4
    Enable PAE/NX = false
    Enable Nested VT-x/ADM-V = false
    # just what I'm trying (may not be best)
Display -> Screen
    Video Memory = 128 MB (set to max)
    Graphics Controller: VBoxVGA (defaults to VBoxSVGA)
Storage -> Controller: SATA 
    Type = VDI,  Virtual Size = 256GB (dynamic; current size=2MB)
Network -> Adapter 1 = Bridged
```
# Linux install media
### manjaro
My first try with this light-weight distro, [manjaro](https://manjaro.org/get-manjaro/)
is based on arch-linux, and it uses Xfce by default.  torrent download: manjaro-xfce-18.1.2-191028-linux53.iso

*Guest Additions*: https://wiki.archlinux.org/index.php/VirtualBox#Install_the_Guest_Additions
`$ sudo pacman -Syu virtualbox-guest-utils xf86-video-vmware`

Arch linux uses the *pacman* package manager, options `-S` synchronize, `-y` = `--refresh`, and `-u` = `--sysupgrade`.  (for details, try `$ pacman --help -S`).

### utilities

```
$ sudo pacman -Syu tmux # see .tmux.conf
$ sudo pacman -Syu tree # ascii-tree ls
```


### miniconda
also started minidconda:
(i) https://linoxide.com/linux-how-to/install-python-anaconda-5-arch-linux-4-11-7-1/

```
$ sudo pacman -Syu bzip2 wget
$ wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
$ sudo pacman -Syu gtkhash
$ gtkhash -f sha256 Miniconda3-latest-Linux-x86_64.sh 
# paste the following (from download site, above) into 'check' value:
#     bfe34e1fa28d6d75a7ad05fd02fa5472275673d5f5621b77380898dee1be15d2

$ sudo su
# sh sha256 Miniconda3-latest-Linux-x86_64.sh  # (ii)
# exit
$
$ eval "$(/usr/local/miniconda/bin/conda shell.bash hook)"  # (iii) one time, tweaks ~/.bashrc
$ conda create -n "python3.7" python=3.7 ipython
```

(ii) I ran the install as root, using the following from link (i) above:  
Install location: `[/root/miniconda3] >>> /usr/local/miniconda/`  
For everything else use the defaults, the `eval` (iii) plumbs things into `~/.bashrc`.


