# My X11 config using DWM based on Arch

## Quick overview of the result

![Alt Text](https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExOXR0OXF2NjQ2ZDhwcGd5a3h1aWJhcms4dGVzZTYzendwNjBmbWcxNCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/VuYwB1G8XZTcyTvUpJ/giphy.gif)


## EXECUTE DEPENCIES.SH for set up.

Refer to folder for their relative information & configuration.\
pacpack.sh installs some utilities for the system going from thunderbird, vlc, feh, obs-studio, steam, lutris, wine, etc ...\
No AUR packages are installed by default. Considering previous drama, I prefered removing their installation.\
I believe, the system is complete enough to be used out of the box.

## Depencies.sh

Execute to deploy the overall config in the system, it will : 

- Install pacman packages
- Install yay 
- Create general folders and .folders
- Put my different configs throughout .config, .fonts, .icons, .themes folders
- Add some Scripts I did
- Put Scripts and .local/bin in the PATH
- replace cd by z
- add some aliases and wrapper

### Pacman packages 

Are installed through pacpack.sh.
They are listed in alphabetical order

### Config 

Is deployed using depconf.sh

### Scripts 

Are installed using depconf.sh

### Aliases, Wrapper 

Are created with newnick.sh


