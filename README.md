# linux-setup
Check list for setting up a new Linux guest.

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
### ubuntu
After creating guest additions normal users can see a mounted shared drive.

    $ sudo usermod -a -G vboxsf $USER
    
Now log out to allow new process to reload `/etc/group`
Or try the following (retrived 11/30/2020 from https://superuser.com/a/609141/685477 )

    $ exec su -l $USER

### manjaro
My first (and maybe last\*) try with this light-weight distro, [manjaro](https://manjaro.org/get-manjaro/)
is based on arch-linux, and it uses Xfce by default.  torrent download: manjaro-xfce-18.1.2-191028-linux53.iso

**\* maybe last:** I ignored a manjaro guest for several months, when I came back to it the updates were out of synch (as in pacman has stopped workign) and it didn't seem worth the effort to untangle.

*Guest Additions*: https://wiki.archlinux.org/index.php/VirtualBox#Install_the_Guest_Additions
`$ sudo pacman -Syu virtualbox-guest-utils xf86-video-vmware`

Arch linux uses the *pacman* package manager, options `-S` synchronize, `-y` = `--refresh`, and `-u` = `--sysupgrade`.  (for details, try `$ pacman --help -S`).

### utilities

```
$ sudo pacman -Syu tmux # see .tmux.conf
$ sudo pacman -Syu tree # ascii-tree ls
```
### dircolor
Sometimes `$ ls` shows directories in a dark blue on black that I find illegible.
The following sets colors to yellow; there are notes in the `/etc/DIR_COLORS.256color` file
explaining the format and a bash one-liner to iterate through available colours.


```
$ cp  /etc/DIR_COLORS.256color  .dir_colors
$ diff  /etc/DIR_COLORS.256color  .dir_colors
58c58,59
< DIR 38;5;27   # directory
---
> # DIR 38;5;27 # directory - original, 38;5;$x is 256-bit color and for x=27 is blueish.
> DIR 38;5;11   # directory - 11 is yellow
```

If you set up custom colors they need to be loaded into env-var LS_COLORS, which can be done in `.bashrc`:

```
$ tail -1 ~/.bashrc
eval $(dircolors ~/.dir_colors) # https://unix.stackexchange.com/a/97556/386060 
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
$ conda activate python3.7 # abridged prompt, just showing '$'.
$ ipython
Python 3.7.5 (default, Oct 25 2019, 15:51:11) 
Type 'copyright', 'credits' or 'license' for more information
IPython 7.9.0 -- An enhanced Interactive Python. Type '?' for help.

In [1]: import sys; sys.version                                                 
Out[1]: '3.7.5 (default, Oct 25 2019, 15:51:11) \n[GCC 7.3.0]'

In [2]: quit()                                                                  
(python3.7) [jgreve@john-pc ~]$ conda deactivate # unabridged prompt
(base) [jgreve@john-pc ~]$ 
```

(ii) I ran the install as root, using the following from link (i) above:  
Install location: `[/root/miniconda3] >>> /usr/local/miniconda/`  
For everything else use the defaults, the `eval` (iii) plumbs things into `~/.bashrc`.

### adding jupyter

```
(python3.7) [jgreve@john-pc ~]$ conda info

     active environment : python3.7
    active env location : /home/jgreve/.conda/envs/python3.7
            shell level : 2
       user config file : /home/jgreve/.condarc
 populated config files : 
          conda version : 4.7.12
    conda-build version : not installed
         python version : 3.7.4.final.0
       virtual packages : 
       base environment : /usr/local/miniconda  (read only)
           channel URLs : https://repo.anaconda.com/pkgs/main/linux-64
                          https://repo.anaconda.com/pkgs/main/noarch
                          https://repo.anaconda.com/pkgs/r/linux-64
                          https://repo.anaconda.com/pkgs/r/noarch
          package cache : /usr/local/miniconda/pkgs
                          /home/jgreve/.conda/pkgs
(i)    envs directories : /home/jgreve/.conda/envs
                          /usr/local/miniconda/envs
               platform : linux-64
             user-agent : conda/4.7.12 requests/2.22.0 CPython/3.7.4 Linux/5.3.11-1-MANJARO manjaro/18.1.3 glibc/2.30
                UID:GID : 1000:1001
             netrc file : None
           offline mode : False
(base) [jgreve@john-pc ~]$ conda activate python3.7 # from (i)
(python3.7) [jgreve@john-pc ~]$ jupyter notebook
bash: jupyter: command not found
(python3.7) [jgreve@john-pc ~]$ conda install jupyter
```
Optional: to enable remote access (normally just `localhost`) 
```
(python3.7) [jgreve@john-pc ~]$ jupyter --help
usage: jupyter [-h] [--version] [--config-dir] [--data-dir] [--runtime-dir] [--paths] [--json] [subcommand]
Jupyter: Interactive Computing
optional arguments:
  -h, --help     show this help message and exit
  ...etc...
  --json         output paths as machine-readable json

Available subcommands: bundlerextension console kernel kernelspec migrate nbconvert nbextension
**notebook** qtconsole run serverextension troubleshoot trust
(python3.7) [jgreve@john-pc ~]$ jupyter notebook --help
The Jupyter HTML Notebook.  This launches a Tornado based HTML Notebook Server that serves up an
HTML5/Javascript Notebook client.

Subcommands are launched as `jupyter-notebook cmd [args]`. For information on
using subcommand 'cmd', do: `jupyter-notebook cmd -h`.

list     List currently running notebook servers.
stop     Stop currently running notebook server for a given port
password Set a password for the notebook server.
..etc...
```

Setting a pw w/the password option will also enable remote access (thank you, https://hyunyoung2.github.io/2017/11/14/How_to_Access_Jupyter_Notebook_Remotely/ )

```
(python3.7) [jgreve@john-pc ~]$ jupyter notebook password
Enter password: 
Verify password: 
[NotebookPasswordApp] Wrote hashed password to /home/jgreve/.jupyter/jupyter_notebook_config.json
###  $ jupyter notebook –no-browser –ip=”your server IP Address” –port=8888
(python3.7) [jgreve@john-pc ~]$ jupyter notebook --no-browser --ip=0.0.0.0 --port=8888
[I 11:37:46.977 NotebookApp] Serving notebooks from local directory: /home/jgreve
[I 11:37:46.977 NotebookApp] The Jupyter Notebook is running at:
[I 11:37:46.977 NotebookApp] http://john-pc:8888/
[I 11:37:46.977 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
```

### jupyter firewall setup from https://stackoverflow.com/a/24729895/5590742
Used the following on CentOS7:
See [**go_jupyter.sh**](go_jupyter.sh) to kick off a headless jupyter, the idea is you'd connect to it from a host-based browerse.
```
     +-----------------------------------------------
     | # firewall-cmd --get-active-zones
     | # firewall-cmd --zone=public --add-port=8888/tcp --permanent
     | # firewall-cmd --reload
     +-----------------------------------------------
     | $ ./go_jupyter.sh
     +-----------------------------------------------
```

## todo
https://pages.github.com/


# ipython config files (ipython 6.3+)  
(i) [Config Files](https://ipython.readthedocs.io/en/stable/config/intro.html#setting-config)  
(ii) [Terminal Interative Shell](https://ipython.readthedocs.io/en/stable/config/options/terminal.html#configtrait-TerminalInteractiveShell.editing_mode)  
excerpt from (i):  
To create the blank config files, run:  
`  $ ipython profile create [profilename]`

If you leave out the profile name, the files will be created for the default profile (see Profiles).
These will typically be located in `~/.ipython/profile_default/`, and will be named `ipython_config.py`, `ipython_notebook_config.py`, etc. 


[Markdown command workaround](https://stackoverflow.com/a/20885980/5590742), becuase 
nobody designed comments into markdown. The following are comments (which you won't see
in the rendered output).

[//]: # (begin HTML copy from terminal; I'm disappointed colors don't come through markdown)

```
--- begin  diff ---
(python3.7) [jgreve@john-pc profile_default]$ git diff ipython_config.py.sav ipython_config.py 
diff --git a/ipython_config.py.sav b/ipython_config.py
index 988ee5d..3acb619 100644
--- a/ipython_config.py.sav
+++ b/ipython_config.py
@@ -289,10 +289,11 @@
 #c.TerminalInteractiveShell.display_completions = 'multicolumn'
 
 ## Shortcut style to use at the prompt. 'vi' or 'emacs'.
-#c.TerminalInteractiveShell.editing_mode = 'emacs'
+c.TerminalInteractiveShell.editing_mode = 'vi'
 
 ## Set the editor used by IPython (default to $EDITOR/vi/notepad).
 #c.TerminalInteractiveShell.editor = '/usr/bin/nano'
+c.TerminalInteractiveShell.editor = '/usr/bin/vim'
 
 ## Allows to enable/disable the prompt toolkit history search
 #c.TerminalInteractiveShell.enable_history_search = True
(python3.7) [jgreve@john-pc profile_default]$ 
--- end diff ---
```
