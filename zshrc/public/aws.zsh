alias ssm_shell='aws ssm start-session --document-name AWS-StartInteractiveCommand --parameters command="bash -l" --target'

alias aws_ls_ec2='aws ec2 describe-instances --filters Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].{Instance:InstanceId,Type:InstanceType,State:State.Name,Name:Tags[?Key==\`Name\`]|[0].Value}" --output table'

# aws_tunnel <instance-id> <remote-host> [remote-port] [local-port] [region]
# Forwards a local port through an SSM-managed EC2 instance to a remote host
# (e.g. an RDS endpoint that isn't publicly reachable).
# region must match where the target EC2 instance lives (defaults to us-west-1).
aws_tunnel() {
  local target="$1"
  local host="$2"
  local rport="$3"
  local lport="$4"
  local region="${5:-us-east-1}"
  if [[ -z "$target" || -z "$host" ]]; then
    echo "usage: aws_tunnel <instance-id> <remote-host> [remote-port] [local-port] [region]" >&2
    return 1
  fi
  aws ssm start-session \
    --region "$region" \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters host="$host",portNumber="$rport",localPortNumber="$lport" \
    --target "$target"
}
