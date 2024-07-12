alias aws_ss='aws ssm start-session --document-name AWS-StartInteractiveCommand --parameters command="bash -l" --target'
alias aws_di="aws ec2 describe-instances --filters Name=instance-state-name,Values=running Name=tag:Name,Values=pave-api-production-env --query 'Reservations[].Instances[].InstanceId' --output json"
alias aws_ssh="aws_ss $(aws_di | jq -r '.[0]')"
