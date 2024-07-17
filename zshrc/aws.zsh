alias aws_ssh='aws ssm start-session --document-name AWS-StartInteractiveCommand --parameters command="bash -l" --target'
# connect to an instance protected from scale in in the specified auto scaling group
alias aws_ssh_pi="aws_ssh $(aws autoscaling describe-auto-scaling-instances | jq -r '.AutoScalingInstances[] | select(.ProtectedFromScaleIn == true and .AutoScalingGroupName == "awseb-e-363wrq8hu8-stack-AWSEBAutoScalingGroup-1gC39UdauRcl") | .InstanceId')"

# set ProtectedFromScaleIn to true
# aws autoscaling set-instance-protection --instance-ids <instance-id> --auto-scaling-group-name <auto-scaling-group-name> --protected-from-scale-in
