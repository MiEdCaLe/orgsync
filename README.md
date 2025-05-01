# orgsync

orgsync is Bash CLI tool that makes it easier to manage and keep your org directory in sync across different computers, regardless of OS type.

Initially, orgsync started as a personal learning project designed to a) help me learn bash, and b) make it easier to keep my org directory in sync between my personal & my work computers, which had different operating systems, (MacOS & Windows)

I decided to open-source it as I can certainly see it being useful to other people.

## Usage

After installing (see [Installation & Setup](#installation--setup)), you can use orgsync in a bash terminal.

`./orgsync.sh sync` Will begin the syncing process, it will pull changes, then create a commit with a formatted date & timestamp as a message, finally pushing the commit to your remote repository.

## Installation & Setup
### .env 

Clone the repo, then, you can copy the `orgsync.sh` file to your `usr/local/bin` folder to make it executable from anywhere.

Create a .env file and populate each of the values
> NOTE!
> Both `WINDOWS_PATH` and `LINUX_PATH` refer to the path where you want your org repository to be cloned at.

```
ORG_DIRECTORY_NAME=<name-of-your-org-directory>
WINDOWS_PATH="<path>"
LINUX_PATH="<path>"

GIT_USER="<git-user-name>"
GIT_EMAIL="<git-user-email>"

GIT_REMOTE_URL="<git-remote-repository-url>"
GIT_BRANCH=<git-branch-name>
```
