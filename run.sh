#!/bin/bash

#If Workspace doesn't close cleanly it can hang the next time you try to run it, clearing out the temp directory prevents hanging in this scenario.
if [[ -d $HOME/.ICAClient/.tmp ]]; then
    rm -r $HOME/.ICAClient/.tmp
fi

#Start the Citrix logging service
/app/ICAClient/linuxx64/util/ctxcwalogd
#Start the Workspace self-service dashboard
/app/ICAClient/linuxx64/selfservice

#This services seems to (sometimes) get started when launching Workspace. It's stubborn and requires SIGKILL to stop.
if [[ ! -z $(ps -e | grep UtilDaemon) ]]; then
    pkill --signal 9 UtilDaemon
fi

#Kill the rest of the services that were started, so the Flatpak container itself stops running once you close Workspace.
for process in AuthManagerDaem ServiceRecord ctxlogd icasessionmgr; do
    pkill $process
done

exit
