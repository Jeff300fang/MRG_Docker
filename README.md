# MRG_Docker
This repository provides the scripts to build and run the MRG Docker container.

## Running the docker container:
1. Open whatever terminal you want to use (`Ubuntu` if you are on Windows, `terminal` if you are on MacOS)
2. Go to the MRG_Docker folder (`cd MRG_Docker`)
3. Run `./session.sh` (if it says permission denied run `chmod +x start.sh` and try again)
4. The MRG_Docker container is now running and you can either go to `localhost:6080` in a browser to access the GUI or enter commands into the terminal that you used.
5. Any time you want a terminal you can either open one using the GUI you loaded in your web browser or by running `./session.sh` again in your terminal of choice.
6. When you are done with a terminal opened using `session.sh` make sure to use the `exit` command to close the session before closing the terminal window. When you have closed all the open sessions the docker container will automatically stop running.

## Updating an existing installation
1. Run `update.sh` and enter your git credentials when prompted. For the most part this should handle everything automatically.

## Installing the docker container:
You are welcome to install and run everything however you want but the method of installation here will recieve the most direct support.
* [Windows](https://github.com/chachmu/MRG_Docker#windows)
* [MacOS](https://github.com/chachmu/MRG_Docker#macos)

### Windows
1. Install WSL2 (Based on the instructions [here](https://learn.microsoft.com/en-us/windows/wsl/install))
    1. Open `Powershell` and run `wsl --install`
    2. run `wsl --set-default-version 2`
    3. run `wsl --install -d Ubuntu`
2. Install Docker Desktop (you can instead install docker directly in WSL2 by following these [instructions](https://dev.to/bowmanjd/install-docker-on-windows-wsl-without-docker-desktop-34m9) if you would prefer but its much more involved)
    1. Follow the instructions here: https://docs.docker.com/desktop/install/windows-install/
    2. Open Docker Desktop and follow any setup instructions, then quit and reopen Docker Desktop
3. Set up Ubuntu and clone the repo
    1. Open `Ubuntu` from the start menu
    2. Run `sudo apt update`
    3. Run `sudo apt install docker-compose`
    4. Run `git clone https://github.com/chachmu/MRG_Docker.git`
    6. Create an `mrg_ws` folder on your computer wherever you intend to store your MRG projects.
    7. Edit line 13 of the file in the MRG_Docker folder called `docker-compose.yml` to replace the <PATH_GOES_HERE> portion with the path to the `mrg_ws` folder. (If you put your folder in your home directory then the path would be `/home/$USER/mrg_ws`)
4. Pull the docker container by running `docker pull mwoodward6/mrg:humble`
    * If you get errors then open Docker Desktop and check that the docker engine icon in the bottom left is green. If it is then check in the settings under Resources: WSL Integration` that the checkbox is enabled and that the Ubuntu distro you are using is enabled. If none of this has fixed the issue sometimes restarting Docker Desktop can also help.
5. You are now ready to [run the docker container](https://github.com/chachmu/MRG_Docker#running-the-docker-container)

If for some reason you prefer the X11 method of displaying GUI based applications you can continue to use it by running `. session.sh` after modifying and starting the XLaunch shortcut by replacing the text in the `target` property with `"C:\Program Files\VcXsrv\vcxsrv.exe" :0 -ac -terminate -lesspointer -multiwindow -clipboard -nowgl -dpi auto` (Note that this is different than the original set of properties used with the docker container).


### MacOS
1. Install Docker Desktop
    1. Follow the instructions here: https://docs.docker.com/desktop/install/mac-install/
    2. Open Docker Desktop and follow any setup instructions, then quit and reopen Docker Desktop
2. Clone the repos
    1. Open `terminal`
    2. Go to the folder you want to put the MRG_Docker repo in
    4. Run `git clone https://github.com/chachmu/MRG_Docker.git`
    7. Edit line 13 of the file in the MRG_Docker folder called `docker-compose.yml` to replace the <PATH_GOES_HERE> portion with the path to the `mrg_ws` folder. (If you put your folder in your home directory then the path would be `/USERS/$User/mrg_ws`)
3. Pull the docker container by running `docker pull mwoodward6/mrg:humble`
    * If you get errors then open Docker Desktop and check that the docker engine icon in the bottom left is green.
5. You are now ready to [run the docker container](https://github.com/chachmu/MRG_Docker#running-the-docker-container)
