# Bash Python Installer
One command to install Python!

## Recommended usage
Download and extract (or just clone) and run:
```bash
./BashPythonInstaller/install_python.sh [link_to_Python_tar] > install.log &
```

Two new files will remain on a successful completion of the installer: `install.log` and `python.log`. The former contains the log from my script, the latter contains the output of the configuration, make, and install of Python.

## How it works
The initial process is based off of [my gist](https://gist.github.com/AtkLordOverAll/8477c0de5dc354a6b9549efadda7e8e6), which in turn you can see is forked. However in the spirit of XKCD, [I automated it](https://xkcd.com/1319/).

### What the script does
1) Checks your argument to see if it looks like a valid Python URL
2) Checks your installed packages against the ones required in `reqs.txt`, and stores the ones that are missing in `tmp.txt`
3) Does an `apt-get update`, `apt-get install` of the missing packages, and then marks the packages used as automatically installed (so that `apt-get autoremove` will pick up on them later)
4) Downloads Python from your URL, extracts it, then runs the configuration utility within
5) Makes and installs Python
6) Removes the files used (`tmp.txt`, the Python archive, and the extracted folder)
7) Runs `apt-get autoremove && apt-get clean`
