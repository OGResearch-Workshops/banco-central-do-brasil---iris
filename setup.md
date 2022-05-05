# Setup instructions

## Overview of requirements/dependencies

* Matlab R2019b or later (assumed to be installed already on your computer,
  or assumed to be accessible over the network)

* Git, a version control system

* Local clone of the Iris Toolbox repository: the latest `bleeding` branch

* Local clone of the workshop repository: the latest `master` branch


## Install Git

Install [Git](https://git-scm.com) (a version control system) locally on
your computer. This may require assistance by your IT department.


## Create a folder for the workshop

Choose and create a directory (folder) within which you will maintain two subfolders: one for the Iris
Toolbox and the other for the workshop files; for instance `C:\Users\Marcos\wokshop-2022` on Windows, or
`~/workshop-2022` on Linux/macOS.

Make sure the path is not overly complicated (this is in your own
interest:) and does not contain blank spaces (use underscores or dashes
instead).

We will call this folder the **workshop root folder**.


## Local clone of IrisT

In the workshop root folder, run the following command (in PowerShell,
a command window, or a Terminal) to clone the `bleeding` edge branch of the
Iris Toolbox to an `iris-toolbox` subfolder:

```
git clone --branch bleeding https://github.com/IRIS-Solutions-Team/IRIS-Toolbox iris-toolbox
```


## Local clone of the workshop repository

Again, in the workshop root folder, run the following command to clone the
workshop repository to an `workshop-files` folder

```
git clone https://github.com/OGResearch-Workshops/banco-central-do-brasil---iris.git workshop-files
```

## Test everything on Matlab

* Start up Matlab

* Switch to the `workshop-files` folder within the workshop root folder,
e.g. by running the following Matlab command

```
>> cd C:\Users\Marcos\wokshop-2022
```

* Start up the Iris Toolbox

```
addpath ../iris-toolbox; iris.startup
```

* Test the `system-priors` tutorial: Switch to the `system-priors`
  subsubfolder, and run the scripts in the order indicated by the names of
  the scripts (e.g. `run01_createModel`, etc.)


```
>> cd system-priors
>> run01_createModel
```


## Updating the codebase (IrisT, workshop files) during the workshop

When you need to update the local clone of either repository (the Iris
Toolbox, or the workshop files) from GitHub, you just issue one simple
command executed from within your command line or from within Matlab, and
that's it. No manual download, unzipping, deleting etc. needed.

You can alternatively use one of the many graphical user interfaces
available for Git repositories (including a basic one directly in Matlab).
We will go over this at the benning of the workshop.


#### Updating local repo from command line (PowerShell, Terminal, ...)

```
...> cd C:\Users\Marcos\wokshop-2022\iris-toolbox
...> git pull
```

and/or

```
...> cd C:\Users\Marcos\wokshop-2022\workshop-files
...> git pull
```


#### Updating local repo from Matlab

Note the exclamation mark in fron of the `git` command

```
>> cd C:\Users\Marcos\wokshop-2022\iris-toolbox
>> !git pull
```

and/or

```
>> cd C:\Users\Marcos\wokshop-2022\workshop-files
>> !git pull
```


