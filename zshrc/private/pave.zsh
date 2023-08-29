function export_project_x_envs {
  export PROJECTX=$HOME/project-x
  export PROJECTX_DATA=$HOME/project-x/data
  export PROJECTX_MODELS=$HOME/project-x/models
  export PROJECTX_TESTS=$HOME/project-x/tests
  export PYTHONSTARTUP=$HOME/project-x/py_shell_startup.py
  export PYTHONPATH=:$HOME/project-x
  export SLACK_PRIVATE_EDP=https://hooks.slack.com/services/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
}

export KAFKA_SASL_PASSWORD=aK5GSeFb2kBsTa8EoX648ornqdjW2dER5hp
export KAFKA_SASL_USERNAME=fuse-production
export KAFKA_BOOTSTRAP_SERVERS=b-1-public.fuseproduction.3o43ge.c3.kafka.eu-west-2.amazonaws.com:9196,b-3-public.fuseproduction.3o43ge.c3.kafka.eu-west-2.amazonaws.com:9196,b-2-public.fuseproduction.3o43ge.c3.kafka.eu-west-2.amazonaws.com:9196

function cd_handler {
  if [[ "$(pwd)" == "$HOME/project-x" ]]; then
    export_project_x_envs

    source .venvdir/bin/activate
  fi
}

cd_handler

add-zsh-hook chpwd cd_handler
