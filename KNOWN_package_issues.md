# Known package installation issues and solutions (written on 23-Jun-2020)

This file uses MacOS Catalina (10.15.5) with R 4.0.1 as demo system  
Please kindly search for equivalent command for Windows  
For MacOS users, you can only use R environment installed from its [official](https://cloud.r-project.org/) website due to a PATH issue hard coded in `phangorn` dependency package calling the `igraph` package

## package "XML"

install/update libxml2 in your terminal (or cmd-prompt in Windows)  
if you don't have homebrew, you can [install](https://brew.sh/) it  
equivalent package manager in Linux systems are `sudo apt` instead of `brew`

1. `brew install libxml2` OR `brew reinstall libxml2`
0. add the library path in `PATH` variable by exporting it into the bash/zsh source file; the `.bashrc` part in the below step can be replaced by `.bash_profile` / `.zshrc` / `.zsh_profile` / `.zprofile` depending on which file is used to start your terminal
0. run `echo -e "export PATH='/usr/local/opt/libxml2/bin:$PATH'" >> .bashrc` to add the lib path
0. run `source .bashrc` (or the equivalent file you have just used)
0. use a new tab / restart the terminal window
0. run `R` in the new terminal to start R console
0. run `install.packages("XML")` in the R console and you should be good to go

## package "igraph" (possible)

from online forums, this issue seems to be persisting as a bug.  However this can be fixed by using older binary versions of `igraph`

1. in MacOS R console, run `install.packages("igraph", type = "mac.binary")`;  for Linux, the `mac.binary` part can be changed to `binary`

