function db_restore { pg_restore --verbose --clean --no-acl --no-owner -h localhost -d $1 $DEVS_HOME/dumps/$2 }

function db_dump {
  if [[ $1 && $2 ]]; then
    pg_dump -Fc --no-acl --no-owner -h localhost $1 > $DEVS_HOME/dumps/$(kebab $(date +%b_%d_%a_%H%M)-$(kebab $2)).dump
  elif [[ $1 ]]; then
    pg_dump -Fc --no-acl --no-owner -h localhost $1 > $DEVS_HOME/dumps/$(kebab $(date +%b_%d_%a_%H%M)).dump
  else
    echo "<database> must be specified"
  fi
}
