alias aws_ssh='aws ssm start-session --document-name AWS-StartInteractiveCommand --parameters command="bash -l" --target'
# connect to an instance protected from scale in in the specified auto scaling group

# set ProtectedFromScaleIn to true
# aws autoscaling set-instance-protection --instance-ids <instance-id> --auto-scaling-group-name <auto-scaling-group-name> --protected-from-scale-in
# aws_ssh target should be $(aws autoscaling describe-auto-scaling-instances | jq -r '.AutoScalingInstances[] | select(.ProtectedFromScaleIn == true and .AutoScalingGroupName == "awseb-e-363wrq8hu8-stack-AWSEBAutoScalingGroup-1gC39UdauRcl") | .InstanceId')

alias aws_ls_ec2='aws ec2 describe-instances --filters Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].{Instance:InstanceId,Type:InstanceType,State:State.Name,Name:Tags[?Key==\`Name\`]|[0].Value}" --output table'
