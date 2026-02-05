alias aws_ssh='aws ssm start-session --document-name AWS-StartInteractiveCommand --parameters command="bash -l" --target'

alias aws_ls_ec2='aws ec2 describe-instances --filters Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].{Instance:InstanceId,Type:InstanceType,State:State.Name,Name:Tags[?Key==\`Name\`]|[0].Value}" --output table'

# list instances protected from scale in
# aws autoscaling describe-auto-scaling-instances --query "AutoScalingInstances[?ProtectedFromScaleIn==\`true\`].[InstanceId,AutoScalingGroupName]" --output table

# set instance scale-in protection
# EC2 > Auto Scaling groups > Instance management > Actions > Set scale-in protection
