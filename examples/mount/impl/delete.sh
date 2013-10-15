#!/bin/bash -x
exec 3>&1 # "save" stdout to fd 3
exec &>> /home/ec2-user/delete.log

function error_exit() {
    echo "{\"Reason\": \"$1\"}" >&3 3>&- # echo reason to stdout (instead of log) and then close fd 3
    exit $2
}

if [ -z "${Event_ResourceProperties_MountPoint}" ]
then
    error_exit "MountPoint is required." 64
fi

umount "${Event_ResourceProperties_MountPoint}"

umount_ret=$?
if [ $umount_ret -ne 0 ]
then
    error_exit "Unmount failed." $umount_ret
else
    echo "{}" >&3 3>&- # echo reason to stdout (instead of log) and then close fd 3
    exit 0
fi