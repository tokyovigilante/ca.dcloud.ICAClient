#!/bin/bash

#Set the default install directory in the Workspace install script
sed -ie 's/DefaultInstallDir=.*$/DefaultInstallDir=\/app\/ICAClient\/linuxx64/' /tmp/icaclient/linuxx64/hinst
#The installation options selected below answer yes to using the gstreamer pluging from ICAClient. The "app protection component" and USB support
#require the installer to be run as root, so they cannot be installed in this case.
echo -e "1\n\ny\nyes\ny\n3\n" | /tmp/icaclient/setupwfc

cd /app/ICAClient/linuxx64
MODULE_INI=config/module.iniflatpak
if [ -L "$MODULE_INI" ] ; then
    MODULE_INI=$(readlink -f "$MODULE_INI")
fi
cp $MODULE_INI .
chmod a+rw -v module.ini
rtme/RTMEconfig -install -ignoremm
if [ -s "./new_module.ini" ] ; then
    rm -rf "$MODULE_INI"
    cp ./new_module.ini "$MODULE_INI"
    chmod a+rw -v "$MODULE_INI"
fi
rm -rf ./module.ini
rm -rf ./new_module.ini

exit
