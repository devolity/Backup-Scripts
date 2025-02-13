#!/usr/bin/bash
#
#   _____   .__     .______.            
#  /  _  \  |__|  __| _/\_ |__    ______
# /  /_\  \ |  | / __ |  | __ \  /  ___/
#/    |    \|  |/ /_/ |  | \_\ \ \___ \ 
#\____|__  /|__|\____ |  |___  //____  >
#        \/          \/      \/      \/ 
#

[[ -n "${DEBUG}" ]] && set -x

###
# Configuration
###
DATA_DIR=/home/.Raw2022s
CONFIG=$DATA_DIR/.filebkup.conf

###
# Functions
###

# Color helpers
color_red=$(tput setaf 1)
color_yellow=$(tput setaf 3)
color_green=$(tput setaf 2)
color_reset=$(tput sgr0)

# Logging prefix helper
prefix(){
  # Check if placeholders variables are given
  if [[ -n "${current_action}" && -n "${current_task}" && -n "${total_tasks}" ]]; then
    # Return prefix
    echo "[${current_action}] [${current_task}/${total_tasks}] "
  fi
}

# Logging helpers
debug() {
  echo "$(prefix)[DEBUG] $@ " 1>&2
}

success() {
  echo "$(prefix)${color_green}[SUCCESS]${color_reset} $@" 1>&2
}

info() {
  echo "$(prefix)${color_yellow}[INFO]${color_reset} $@" 1>&2
}

error() {
  echo "$(prefix)${color_red}[ERROR]${color_reset} $@" 1>&2
}

# Strip all redundant slashes in file paths
strip_duplicate_slashes_in_path(){
  # Backup current shopt options
  shoptBackup=$(shopt -p)
  # Set extented globbing
  shopt -s extglob
  # Substitute input (turn multiple slashes into single one) and return
  echo "${@//+(\/)//}"
  # Restore shopt
  eval "$oldShoptOptions" &> /dev/null
}

# Replace all slashes with dashes
replace_slash_with_dash(){
    input="${@////-}"     # replace all slashes with dashes
    input="${input/#-/}"  # remove possible starting dash
    output="${input/%-/}" # as well as possible trailing dash
    echo "${output}"
}

# Logic ###

# Check for config file then read and source
if [[ -f "${CONFIG}" ]]; then
  . "${CONFIG}"
else
  error "Couldn't find configuration file \"${CONFIG}\""
  exit 1
fi

# Iterate through tar_excludes to create a "--exclude=XXX" combination string
tar_exclude_parameters=()
if [[ "${#tar_excludes[@]}" -ne 0 ]]; then
  # Run each pre command
  for parameter in "${tar_excludes[@]}"; do
    tar_exclude_parameters+=( "--exclude=${parameter}" )
  done
fi

# Set prefix variables for pre-commands
current_action="pre-command"
current_task=1
total_tasks="${#pre_commands[@]}"

# Iterate through pre_commnads
if [[ "${#pre_commands[@]}" -ne 0 ]]; then
  info "Found pre commands..."
  # Run each pre command
  for pre_command in "${pre_commands[@]}"; do
    info "Running \"${pre_command}\":"
    eval "${pre_command}"
    # Check if pre command ran successfully
    if [[ $? -eq 0 ]]; then
      success "Pre command \"${pre_command}\" successfully completed!"
    else
      error "Pre command \"${pre_command}\" failed..."
    fi
  done
fi

# Set prefix variables for backup
current_action="backup"
current_task=1
total_tasks="${#folders_to_backup[@]}"

# Iterate through "$folders_to_backup"
for folder_to_backup in "${folders_to_backup[@]}"; do
  # Check if folder exists
  debug "Check if source folder \"${folder_to_backup}\" exists..."
  if [[ -d "${folder_to_backup}" ]]; then
    # Exist => continue
    info "Source folder \"${folder_to_backup}\" exists!"
    # Make sure backup destination exists
    backup_basename=$(replace_slash_with_dash "${folder_to_backup}")
    absolute_backup_destination=$(strip_duplicate_slashes_in_path "${backup_destination}/${backup_basename}")
    if [[ ! -d "${absolute_backup_destination}" ]]; then
      info "Backup destination folder \"${absolute_backup_destination}\" doesn't exist. Creating..."
      mkdir -p "${absolute_backup_destination}"
    fi

    #--- Backup File Name
    backup_name=`echo ${backup_basename} | sed 's/.*-//'`

    #--- Check if backup already exists (to make sure)
    if [[ -f "${absolute_backup_destination}/${backup_name}-${timestamp}.tar.gz" ]]; then
      error "Backup \"${absolute_backup_destination}/${backup_name}-${timestamp}.tar.gz\" already exists. Skipping..."
    else
    #--- Start backup
      info "Starting backup \"${absolute_backup_destination}/${backup_name}-${timestamp}.tar.gz\""
      tar czf "${absolute_backup_destination}/${backup_name}-${timestamp}.tar.gz" -P "${folder_to_backup}" "${tar_exclude_parameters[@]}"
      if [[ $? -eq 0 ]]; then
        success "Backup \"${absolute_backup_destination}/${backup_name}-${timestamp}.tar.gz\" successfully completed!"
      else
        error "Backup \"${absolute_backup_destination}/${backup_name}-${timestamp}.tar.gz\" failed..."
      fi
    fi

    # Remove old backups
    if [[ ! -z "${backup_retention}" ]]; then
	find "${absolute_backup_destination}/" -mtime "${backup_retention}" -type f -exec rm -rf {} \;
        #find "${absolute_backup_destination}/" -type f -mtime "${backup_retention}" -name '*.gz' -execdir rm -- '{}' \;
    fi
  else
    # Doesn't exist => skip
    error "Folder \"${folder_to_backup}\" doesn't exist. Skipping..."
  fi
  # Increment $current_task variable
  current_task=$((current_task+1))
done

# Set prefix variables for pre-commands
current_action="post-command"
current_task=1
total_tasks="${#post_commands[@]}"

# Iterate through post_commnads
if [[ "${#post_commands[@]}" -ne 0 ]]; then
  info "Found post commands..."
  # Run each post command
  for post_command in "${post_commands[@]}"; do
    info "Running \"${post_command}\":"
    eval "${post_command}"
    # Check if post command ran successfully
    if [[ $? -eq 0 ]]; then
      success "Post command \"${post_command}\" successfully completed!"
    else
      error "Post command \"${post_command}\" failed..."
    fi
  done
fi

# Return exit code
exit 0
#### Generate Report Backup
