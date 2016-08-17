# Outputs log line
#
# Usage:
#
#     output_line "Cloning repository"
#
function output_line() {
  local spacing="      "
  echo "${spacing} $1"
}

# Outputs section heading
#
# Usage:
#
#     output_section "Application tasks"
#
function output_section() {
  local indentation="----->"
  echo "${indentation} $1"
}

function load_config() {
  output_section "Checking Caddy"

  local custom_config_file="${build_path}/caddy_buildpack.config"

  # Source for default versions file from buildpack first
  source "${build_pack_path}/caddy_buildpack.config"

  if [ -f $custom_config_file ];
  then
    source $custom_config_file
  else
    output_line "WARNING: caddy_buildpack.config wasn't found in the app"
    output_line "Using default config from Caddy buildpack"
  fi

  output_line "Will use the following versions:"
  output_line "* Stack ${STACK}"
  output_line "* Features ${caddy_features}"
}

function clean_cache() {
  if [ $always_rebuild = true ]; then
    output_section "Cleaning all cache to force rebuilds"
    rm -rf $cache_path/*
  fi
}
