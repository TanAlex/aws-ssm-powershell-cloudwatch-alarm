# Tools to install a PS script tool on Windows server to send custom metrics

```bash
aws ssm create-document --content file://install-sendmetric-tool.ssm.document.json --name "SetupSendMetricsTool" --document-type "Command" --region us-west-02
```
Or just Run send-command command
```bash
INSTANCE_ID="i-07abc1ba2742d9c1a"
aws ssm send-command --document-name "AWS-RunRemoteScript" --instance-ids "$INSTANCE_ID" --parameters '{"sourceType":["GitHub"],"sourceInfo":["{\"owner\":\"TanAlex\", \"repository\":\"aws-ssm-powershell-cloudwatch-alarm\", \"path\": \"Add-ScheduleTask.ps1\"}"],"commandLine":["powershell Add-ScheduleTask.ps1"]}' --region us-west-2
```