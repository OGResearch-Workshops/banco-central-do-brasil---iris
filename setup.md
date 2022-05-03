# Setup instructions

## Overview of requirements/dependencies

* Matlab R2019b or later

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
git clone --branch bleeding https://github.com/IRIS-Solutions-Team/IRIS-Toolbox/tree/bleeding iris-toolbox
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




