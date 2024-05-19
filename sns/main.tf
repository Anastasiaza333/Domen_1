module "labels" {
  source = "cloudposse/label/null"
    name = var.name
}


resource "aws_sns_topic" "this" {
  name            = "anastasiia-sns-topic"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}

resource "aws_sns_topic_subscription" "email_topic" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = "anastasiaza05@gmail.com"
}

resource "aws_sns_topic_subscription" "slack_topic" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "lambda"
  endpoint  = var.lambda_arn
}

resource "aws_cloudwatch_log_metric_filter" "get_all_authors" {
  name           = "get-all-authors-metric-filter"
  pattern        = "ERROR"
  log_group_name = "/aws/lambda/get-all-authors"

  metric_transformation {
    name      = "EventCount"
    namespace = "get-all-authors-metric-namespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "get_all_authors_alarm" {
  alarm_name                = "get-all-authors-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = aws_cloudwatch_log_metric_filter.get_all_authors.metric_transformation[0].name
  namespace                 = "get-all-authors-metric-namespace"
  period                    = 120
  statistic                 = "Sum"
  threshold                 = 1
  insufficient_data_actions = []

  alarm_actions = [aws_sns_topic.this.arn]
}


resource "aws_cloudwatch_log_metric_filter" "get_all_courses" {
  name           = "get-all-courses-metric-filter"
  pattern        = "ERROR"
  log_group_name = "/aws/lambda/get-all-courses"

  metric_transformation {
    name      = "EventCount"
    namespace = "get-all-courses-metric-namespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "get_all_courses_alarm" {
  alarm_name                = "get-all-courses-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = aws_cloudwatch_log_metric_filter.get_all_courses.metric_transformation[0].name
  namespace                 = "get-all-courses-metric-namespace"
  period                    = 120
  statistic                 = "Sum"
  threshold                 = 1
  insufficient_data_actions = []

  alarm_actions = [aws_sns_topic.this.arn]
}

resource "aws_cloudwatch_log_metric_filter" "get_course" {
  name           = "get-course-metric-filter"
  pattern        = "ERROR"
  log_group_name = "/aws/lambda/get-course"

  metric_transformation {
    name      = "EventCount"
    namespace = "get-course-metric-namespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "get_course_alarm" {
  alarm_name                = "get-course-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = aws_cloudwatch_log_metric_filter.get_course.metric_transformation[0].name
  namespace                 = "get-course-metric-namespace"
  period                    = 120
  statistic                 = "Sum"
  threshold                 = 1
  insufficient_data_actions = []

  alarm_actions = [aws_sns_topic.this.arn]
}

resource "aws_cloudwatch_log_metric_filter" "delete_course" {
  name           = "delete-course-metric-filter"
  pattern        = "ERROR"
  log_group_name = "/aws/lambda/delete-course"

  metric_transformation {
    name      = "EventCount"
    namespace = "delete-course-metric-namespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "delete_course_alarm" {
  alarm_name                = "delete-course-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = aws_cloudwatch_log_metric_filter.delete_course.metric_transformation[0].name
  namespace                 = "get-course-metric-namespace"
  period                    = 120
  statistic                 = "Sum"
  threshold                 = 1
  insufficient_data_actions = []

  alarm_actions = [aws_sns_topic.this.arn]
}

resource "aws_cloudwatch_log_metric_filter" "save_course" {
  name           = "save-course-metric-filter"
  pattern        = "ERROR"
  log_group_name = "/aws/lambda/save-course"

  metric_transformation {
    name      = "EventCount"
    namespace = "save-course-metric-namespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "save_course_alarm" {
  alarm_name                = "save-course-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = aws_cloudwatch_log_metric_filter.save_course.metric_transformation[0].name
  namespace                 = "save-course-metric-namespace"
  period                    = 120
  statistic                 = "Sum"
  threshold                 = 1
  insufficient_data_actions = []

  alarm_actions = [aws_sns_topic.this.arn]
}

resource "aws_cloudwatch_log_metric_filter" "update_course" {
  name           = "update-course-metric-filter"
  pattern        = "ERROR"
  log_group_name = "/aws/lambda/update-course"

  metric_transformation {
    name      = "EventCount"
    namespace = "update-course-metric-namespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "update_course_alarm" {
  alarm_name                = "update-course-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = aws_cloudwatch_log_metric_filter.update_course.metric_transformation[0].name
  namespace                 = "update-course-metric-namespace"
  period                    = 120
  statistic                 = "Sum"
  threshold                 = 1
  insufficient_data_actions = []

  alarm_actions = [aws_sns_topic.this.arn]
}

resource "aws_sns_topic" "billing" {
  name            = "billing-alarm-notification-usd-${var.stage}"
  delivery_policy = jsonencode({
    "http" : {
      "defaultHealthyRetryPolicy" : {
        "minDelayTarget" : 20,
        "maxDelayTarget" : 20,
        "numRetries" : 3,
        "numMaxDelayRetries" : 0,
        "numNoDelayRetries" : 0,
        "numMinDelayRetries" : 0,
        "backoffFunction" : "linear"
      },
      "disableSubscriptionOverrides" : false,
      "defaultThrottlePolicy" : {
        "maxReceivesPerSecond" : 1
      }
    }
  })
}

resource "aws_sns_topic_subscription" "topic_billing_email_subscription" {
  topic_arn = aws_sns_topic.billing.arn
  protocol  = "email"
  endpoint  = "anastasiaza05@gmail.com"
}

module "billing_alert" {
  source = "billtrust/billing-alarm/aws"

  aws_env = var.stage
  monthly_billing_threshold = 1
  currency = "USD"

}