alias ssm_shell='aws ssm start-session --document-name AWS-StartInteractiveCommand --parameters command="bash -l" --target'

alias aws_ls_ec2='aws ec2 describe-instances --filters Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].{Instance:InstanceId,Type:InstanceType,State:State.Name,Name:Tags[?Key==\`Name\`]|[0].Value}" --output table'

# aws_ensure_running <instance-id> [region]
# Starts a stopped EC2 instance and blocks until SSM can reach it, so a
# start-session right after does not fail with TargetNotConnected.
aws_ensure_running() {
  local target="$1"
  local region="${2:-us-east-1}"
  local state
  state=$(aws ec2 describe-instances --region "$region" --instance-ids "$target" \
    --query 'Reservations[0].Instances[0].State.Name' --output text) || return 1

  case "$state" in
    running) return 0 ;;
    stopping)
      echo "$target is stopping; waiting for it to stop..." >&2
      aws ec2 wait instance-stopped --region "$region" --instance-ids "$target" || return 1
      ;&
    stopped)
      echo "Starting $target..." >&2
      aws ec2 start-instances --region "$region" --instance-ids "$target" >/dev/null || return 1
      ;&
    pending)
      aws ec2 wait instance-running --region "$region" --instance-ids "$target" || return 1
      ;;
    *)
      echo "$target is $state; cannot start it" >&2
      return 1
      ;;
  esac

  # The SSM agent registers some seconds after the instance reports running.
  echo "Waiting for SSM agent on $target..." >&2
  local i ping
  for i in {1..30}; do
    ping=$(aws ssm describe-instance-information --region "$region" \
      --filters "Key=InstanceIds,Values=$target" \
      --query 'InstanceInformationList[0].PingStatus' --output text 2>/dev/null)
    [[ "$ping" == Online ]] && return 0
    sleep 5
  done
  echo "SSM agent on $target did not come online" >&2
  return 1
}

# aws_tunnel <instance-id> <remote-host> [remote-port] [local-port] [region]
# Forwards a local port through an SSM-managed EC2 instance to a remote host
# (e.g. an RDS endpoint that isn't publicly reachable).
# Starts the instance first if it is stopped.
# remote-port defaults to 5432, local-port to remote-port, region to us-east-1.
# region must match where the target EC2 instance lives.
aws_tunnel() {
  local target="$1"
  local host="$2"
  local rport="${3:-5432}"
  local lport="${4:-$rport}"
  local region="${5:-us-east-1}"
  if [[ -z "$target" || -z "$host" ]]; then
    echo "usage: aws_tunnel <instance-id> <remote-host> [remote-port] [local-port] [region]" >&2
    return 1
  fi
  aws_ensure_running "$target" "$region" || return 1
  aws ssm start-session \
    --region "$region" \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters host="$host",portNumber="$rport",localPortNumber="$lport" \
    --target "$target"
}
