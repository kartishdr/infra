# 1. Create an SNS Topic for Notifications
resource "aws_sns_topic" "example" {
  name = "cloudwatch-alerts-topic"
}

# 2. Create a CloudWatch Log Group
resource "aws_cloudwatch_log_group" "example" {
  name = "/aws/lambda/my-log-group"
  retention_in_days = 7  # Set retention in days for log storage (optional)
}

# 3. Create a CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "example" {
  alarm_name                = "High-CPU-Alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "Triggered when CPU utilization exceeds 80%"
  insufficient_data_actions = []
  ok_actions                = [aws_sns_topic.example.arn]
  alarm_actions             = [aws_sns_topic.example.arn]

 #  No dimensions block here — this monitors the metric aggregated across all EC2 instances
}

# 4. Create an SNS Subscription (optional)
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.example.arn
  protocol  = "email"
  endpoint  = "anushareddyaws1@gmail.com"  # Replace with your email
}
