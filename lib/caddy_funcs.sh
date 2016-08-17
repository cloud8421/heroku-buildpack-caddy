function caddy_tarball() {
  echo "caddy_linux_amd64_custom.tar.gz"
}

function download_caddy() {
  caddy_package_url="https://caddyserver.com/download/build?os=linux&arch=amd64&features=${caddy_features}"

  # If a previous download does not exist, then always re-download
  if [ ! -f ${build_path}/$(caddy_tarball) ]; then
    clean_caddy_downloads

    # Set this so elixir will be force-rebuilt
    caddy_changed=true

    output_section "Fetching Caddy"
    curl -L "${caddy_package_url}" -o ${build_path}/$(caddy_tarball) || exit 1
  else
    output_section "Using cached Caddy"
  fi
}

function clean_caddy_downloads() {
  rm -rf ${build_path}/${caddy_tarball}
}

function install_caddy() {
  caddy_bin="caddy"
  dest_path="${build_path}/caddy"
  bin_path="${build_path}/bin"

  output_section "Installing Caddy $(caddy_changed)"

  mkdir ${bin_path}
  tar zxf ${build_path}/$(caddy_tarball) -C ${dest_path} --strip-components=1
  chmod +x ${dest_path}/${caddy_bin}
  mv ${dest_path}/${caddy_bin} ${bin_path}
  rm -rf ${dest_path}
}

function caddy_changed() {
  if [ $caddy_changed = true ]; then
    echo "(changed)"
  fi
}
