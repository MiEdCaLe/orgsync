#!/bin/bash

##### ORG SYNC

### VARIABLES

VERSION=0.0.1
OS=
PARENT_PATH=
ORG_PATH=

# Load each user's org directory path from .env file.
source ./.env

# Obtain operating system from the existence of a "c" mnt.
# If there is a "c" mount, then bash is running inside of wsl. 

[[ -d "/mnt/c" ]] && OS=WINDOWS  || OS=LINUX

# Set org directory depending on the existence of os type.

case $OS in

    #transform ORG_DIRECTORY to reflect WSL mnt
    WINDOWS)

	# export for WSL compatibility
	export GIT_DISCOVERY_ACROS_FILESYSTEM=1

	EXTRACTED_PATH=$(echo "$WINDOWS_PATH" | sed 's/\(^[a-zA-Z]\):\/\(.*\)/\1\/\2/')
	PARENT_PATH="/mnt/$EXTRACTED_PATH"

	#Check that parent path is valid, if so, append the org directory name to it.
	if [[ -d "$PARENT_PATH" ]]; then
            ORG_PATH=$PARENT_PATH$ORG_DIRECTORY_NAME;
	else exit 1;
	fi
    ;;
    

    LINUX)

	PARENT_PATH="$LINUX_PATH"

	if [[ -d "$PARENT_PATH" ]]; then
            ORG_PATH=$PARENT_PATH$ORG_DIRECTORY_NAME;
	else exit 1;
	fi
    ;;

esac

echo Destination Org Path: $ORG_PATH

#################### Functions ########################

usage(){

    echo 
    echo 'Usage: orgsync <options> <command>'
    echo
    echo 'where <options> include:'
    echo 
    echo '-h | --help : Displays help'
    echo '-v | --version : Display version of orgsync'
    echo 
    echo 'and where <command> includes:'
    echo 
    echo 'sync : Syncs org directory with remote org repository'
    echo 

}

# Syncs org directory with remote.
sync(){

    # Check if ORG_PATH exists
    if [[ -d "$ORG_PATH" ]]; then
	cd "$ORG_PATH";
    else # If it doesnt exist, go back to parent path and clone repo.
	cd "$PARENT_PATH"
	git clone "$GIT_REMOTE_URL"
	cd "$ORG_PATH"
    fi

    # ensure git config for org directory
    echo The Org directory path is :$ORG_PATH
    echo The configured git user is: $(git config user.name)
    echo The configured git email is: $(git config user.email)
    echo Is this information correct?
    echo '(y/n)'

    local RESPONSE
    read RESPONSE

    [[ $RESPONSE = '' ]] && echo "ERROR: Answer y/n" && exit 1

    if [[ $RESPONSE = "y" ]]; then

	# pull
	git pull origin master

	# add
	git add . 

	# commit
	git commit -n -m "[$(date +"%Y-%m-%d %H:%M")]"

	# push
	git push origin master

	echo "Successfully synced with remote" && return 0;
	
    else echo "Aborting..." && exit 1;
    fi

}

#####################################################

# Options Parser
if [[ $# = 0 ]]; then
    usage
fi

while (( $# )); do
    case $1 in
	-h | --help)
	    usage
	    exit 0
	;;

	-v | --version)
	    echo orgsync $VERSION 
	    exit 0
	;;

	sync)
	    sync
	    [[ $? ]] && exit 0 || exit 1
	;;

	*)
	    echo Option not supported!
	    usage
	    exit 1
	;;
	
    esac
done
