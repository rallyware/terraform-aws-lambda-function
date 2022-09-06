data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "handler.js"
  output_path = "lambda_function.zip"
}

module "lambda" {
  source = "../../"

  filename               = join("", data.archive_file.lambda_zip.*.output_path)
  handler                = "handler.handler"
  runtime                = "nodejs14.x"
  iam_policy_description = "Description of the IAM policy for the Lambda IAM role"

  custom_iam_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess",
  ]

  cloudwatch_event_rules = [
    {
      name                = "minutely"
      schedule_expression = "cron(0/1 * * * ? *)"
    }
  ]

  name      = "aweasome"
  stage     = "production"
  namespace = "rallyware"
}
