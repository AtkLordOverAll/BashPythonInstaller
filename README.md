# Bash Python Installer
One command to install Python!

## Recommended usage
Download and extract (or just clone). Then you can either run the program silently and even disown the process so you can logout while the install happens (it can take a **long** time on some devices like Raspberry Pis):

```bash
nohup ./BashPythonInstaller/install_python.sh [link_to_Python_tar] > install.log 2>&1 &
```

**OR**

Watch the magic happen (there isn't a whole lot of output):

```bash
./BashPythonInstaller/install_python.sh [link_to_Python_tar]
```

**Please don't try and use URL shorteners!** I do try and stop you with my script but don't try and work around that or it will stop the program from being able to clean up and will cause the script to terminate prematurely

Yes this program will download a file from the internet and execute code from within it, exercise caution! Theoretically if you could pass my expression to check for a valid URL and supposing you had a certain archive layout and file within it you could execute malicious code. It's __not__ my responsibility if you bugger yourself as a result of this.

Two new files will remain on a successful completion of the installer: `install.log` and `python.log`. The former contains the log from my script, the latter contains the output of the configuration, make, and install of Python.

## How it works
The initial process is based off of [my gist](https://gist.github.com/AtkLordOverAll/8477c0de5dc354a6b9549efadda7e8e6), which in turn was originally forked. However in the spirit of XKCD, [I automated it](https://xkcd.com/1319/).

### What the script does
1) Checks your argument to see if it looks like a valid Python URL
2) Checks your installed packages against the ones required in `reqs.txt`, and stores the ones that are missing in `tmp.txt`
3) Does an `apt-get update`, `apt-get install` of the missing packages, and then marks the packages used as automatically installed (so that `apt-get autoremove` will pick up on them later)
4) Downloads and extracts Python from your URL, then runs the configuration utility within
5) Makes and installs Python
6) Removes the files used (`tmp.txt`, and the extracted Python folder)
7) Runs `apt-get autoremove && apt-get clean`
