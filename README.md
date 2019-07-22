# Tools to install a PS script tool on Windows server to send custom metrics


## Tips
To conver a script to a JSON list
```
cat Add-ScheduleTask.ps1| jq -R . | jq -s .
```

## Process

Create SSM Document to install the script and the cronjob(Scheduled Task) which calls it every 5 minutes
```bash
aws ssm create-document --content file://install-sendmetric-tool.ssm.document.json --name "Onica-SetupSendMetricsTool" --document-type "Command" --region us-west-2
```

(optional) If you changed the document.json and want to update it in SSM
```bash
aws ssm update-document --content file://install-sendmetric-tool.ssm.document.json --name "Onica-SetupSendMetricsTool" --document-version "\$LATEST"  --region us-west-2

# Then set the default version to your latest version which returns from update-document result
aws ssm update-document-default-version --name "Onica-SetupSendMetricsTool" --document-version "2"

# Or you can simply just delete it
aws ssm delete-document --name "Onica-SetupSendMetricsTool"

# After deletion, you can rerun the create command to recreate the document
```


Then run the Document against instance
```
#This send version 1, if you don't want to specify version, it will use "default" version
#aws ssm send-command --document-name "Onica-SetupSendMetricsTool" --document-version "1" --targets "Key=instanceids,Values=i-07abc1ba2742d9c1a" --timeout-seconds 600 --max-concurrency "50" --max-errors "0" --region us-west-2

aws ssm send-command --document-name "Onica-SetupSendMetricsTool" --targets "Key=instanceids,Values=i-07abc1ba2742d9c1a" --timeout-seconds 600 --max-concurrency "50" --max-errors "0" --region us-west-2
```

Or just Run send-command command
```bash
INSTANCE_ID="i-07abc1ba2742d9c1a"
aws ssm send-command --document-name "AWS-RunRemoteScript" --instance-ids "$INSTANCE_ID" --parameters '{"sourceType":["GitHub"],"sourceInfo":["{\"owner\":\"TanAlex\", \"repository\":\"aws-ssm-powershell-cloudwatch-alarm\", \"path\": \"Add-ScheduleTask.ps1\"}"],"commandLine":["powershell Add-ScheduleTask.ps1"]}' --region us-west-2
```