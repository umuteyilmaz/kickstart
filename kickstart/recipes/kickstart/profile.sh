kickstart.profile.add_to_profile() {
  local file=$1
  [ ! -f files/"$file" ] && kickstart.info "File files/$file not found" && exit 1

  local profile_d;
  profile_d=$(kickstart.profile.location.profile_d)
  mkdir -p "$profile_d"

  cp files/"$file" "$profile_d"/"$file"

  kickstart.profile.source_on_configuration_file "$file" "$profile_d" "$(kickstart.profile.location.zsh)"
  kickstart.os.is Mac && kickstart.profile.source_on_configuration_file "$file" "$profile_d" "$(kickstart.profile.location.bash)"
}

kickstart.profile.source_on_configuration_file() {
  local file=$1
  local profile_d=$2
  local configuration=$3
  kickstart.file.contains "$configuration" "$file" || ( echo "[[ -f $profile_d/$file ]] && source $profile_d/$file" >> "$configuration" )
}

kickstart.profile.location.profile_d() {
  [ -w /etc -o -w /etc/profile.d ] && echo /etc/profile.d || echo ~/.profile.d
}

kickstart.profile.location.zsh() {
  [ -w /etc ] && echo /etc/zshenv || echo ~/.zshenv
}

kickstart.profile.location.bash() {
  [ -w /etc ] && echo /etc/profile || echo ~/.bashrc
}
