if [ -z "$BASH_VERSION" ] && command -v bash >/dev/null 2>&1; then
  exec bash -l
fi
