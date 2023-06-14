#############################################
##############   #############
#############################################

resource "aws_sns_topic" "cloudwatcg_instance_stop" {
  name              = "cloudwatcg-instance-stop"
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_subscription" "pdates_sqs_target" {
  topic_arn = aws_sns_topic.cloudwatcg_instance_stop.arn
  protocol  = "lambda"
  endpoint  = "arn:aws:lambda:eu-west-1:666511280736:function:stop-autoscaling-group"
}

resource "aws_sns_topic_policy" "uswr_update_topic_policy" {
  arn    = aws_sns_topic.cloudwatcg_instance_stop.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    effect = "Allow"
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
    resources = [
      aws_sns_topic.cloudwatcg_instance_stop.arn
    ]
  }
}