#!/bin/bash

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
#testlink_env_vars=(
#    TESTLINK_USERNAME
#    TESTLINK_PASSWORD
#   TESTLINK_EMAIL
#    TESTLINK_DB_HOST
#    TESTLINK_DB_NAME
#    TESTLINK_DB_USER
#    TESTLINK_DB_PASSWORD
#)
#for env_var in "${testlink_env_vars[@]}"; do
#    file_env_var="${env_var}_FILE"
#    if [[ -n "${!file_env_var:-}" ]]; then
#        if [[ -r "${!file_env_var:-}" ]]; then
#            export "${env_var}=$(< "${!file_env_var}")"
#            unset "${file_env_var}"
#        else
#            warn "Skipping export of '${env_var}'. '${!file_env_var:-}' is not readable."
#        fi
#    fi
#done
#unset testlink_env_vars

# TestLink credentials
export TESTLINK_USERNAME="${TESTLINK_USERNAME}" 
export TESTLINK_PASSWORD="${TESTLINK_PASSWORD}" 
export TESTLINK_EMAIL="${TESTLINK_EMAIL}"

# Database configuration
export TESTLINK_DB_HOST="${TESTLINK_DB_HOST}" 
export TESTLINK_DB_NAME="${TESTLINK_DB_NAME}" 
export TESTLINK_DB_USER="${TESTLINK_DB_USER}" 
export TESTLINK_DB_PASSWORD="${TESTLINK_DB_PASSWORD}" 
