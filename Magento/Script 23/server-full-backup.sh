#!/bin/bash

# Halt the script on any errors.
set -e

## 
read -p "Server Ip Address: " serveraddrs

read -p "Server Port No: " portno

read -p "Server Password: " passkey

## Connection Details
ssh_secure_path="/home/script/"
ssh_secure_name=$passkey
remote_server=$serveraddrs
remote_user="root"
port_no=$portno

# Get data in dd-mm-yyyy format
NOW="$(date +"%d-%b-%Y")"

# This would be the path to your external HD or wherever you're backing up
source_path="/"
target_path="/home/Full-server-backup/${remote_server}-$NOW/"

# Create the target path if it doesn't exist. This command is smart enough to
mkdir -p "${target_path}"

# A list of absolute paths to backup. In the case of WSL, ${HOME} is inside of
include_paths=(
"etc"
"home"
"root"
"usr"
"var"
)

# A list of folder names and files to exclude. There's no point backing up
exclude_paths=(
"mysql"
"/bin"
"/boot"
"/dev"
"/lib"
"/lib64"
"/lost+found"
"/media"
"/mnt"
"/opt"
"/proc"
"/run"
"/sbin"
"/selinux"
"/srv"
"/sys"
"/tmp"
"/etc/rc*"
"/etc/yum*"
"/etc/vim*"
"/etc/alternatives"
"/etc/csf"
"/etc/init*"
"/etc/pam*"
"/etc/pass*"
"/etc/selinux"
"/etc/pki"
"/usr/bin"
"/usr/etc"
"/usr/games"
"/usr/include"
"/usr/lib"
"/usr/local/bin"
"/usr/local/csf"
"/usr/local/doc"
"/usr/lib64"
"/usr/libexec"
"/usr/sbin"
"/usr/src"
"/usr/share"
"/var/account"
"/var/cache"
"/var/db"
"/var/empty"
"/var/games"
"/var/lib"
"/var/local"
"/var/lock"
"/var/log"
"/var/nis"
"/var/opt"
"/var/preserve"
"/var/run"
"/var/tmp"
"/var/yp"
)

# rsync allows you to exclude certain paths. We're just looping over all of the
for item in "${exclude_paths[@]}"
do
  exclude_flags="${exclude_flags} --exclude=${item}"
done

# rsync allows you to pass in a list of paths to copy. It expects a space separated
for item in "${include_paths[@]}"
do
  include_args="${include_args} ${item}"
done

# Finally, we just run rsync with a few flags:
rsync -avze "sshpass -p '${ssh_secure_name}' ssh -p ${port_no} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" ${exclude_flags} ${remote_user}@${remote_server}:${source_path} ${target_path}
######## END ########

