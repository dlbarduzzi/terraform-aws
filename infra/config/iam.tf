resource "aws_iam_user" "bot" {
  name = "bot.pipeline"
}

resource "aws_iam_access_key" "bot" {
  user = aws_iam_user.bot.name
}

data "aws_iam_policy_document" "tf_backend" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.tf_s3_name}"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${var.tf_s3_name}/aws-config/*",
      "arn:aws:s3:::${var.tf_s3_name}/aws-deploy/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/${var.tf_db_name}"]
  }
}

resource "aws_iam_policy" "tf_backend" {
  name        = "${aws_iam_user.bot.name}.tfstate"
  description = "Allow user to access s3 and dynamodb terraform state resources"
  policy      = data.aws_iam_policy_document.tf_backend.json
}

resource "aws_iam_user_policy_attachment" "tf_backend" {
  user       = aws_iam_user.bot.name
  policy_arn = aws_iam_policy.tf_backend.arn
}
