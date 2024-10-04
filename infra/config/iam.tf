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
  description = "Allow user to access s3 and dynamodb terraform state resources."
  policy      = data.aws_iam_policy_document.tf_backend.json
}

resource "aws_iam_user_policy_attachment" "tf_backend" {
  user       = aws_iam_user.bot.name
  policy_arn = aws_iam_policy.tf_backend.arn
}

data "aws_iam_policy_document" "ecr" {
  statement {
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [
      aws_ecr_repository.app.arn,
    ]
  }
}

resource "aws_iam_policy" "ecr" {
  name        = "${aws_iam_user.bot.name}.ecr"
  description = "Allow user to access ecr resources."
  policy      = data.aws_iam_policy_document.ecr.json
}

resource "aws_iam_user_policy_attachment" "ecr" {
  user       = aws_iam_user.bot.name
  policy_arn = aws_iam_policy.ecr.arn
}

data "aws_iam_policy_document" "ec2" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:AssociateRouteTable",
      "ec2:AttachInternetGateway",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateInternetGateway",
      "ec2:CreateRoute",
      "ec2:CreateRouteTable",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSubnet",
      "ec2:CreateTags",
      "ec2:CreateVpc",
      "ec2:CreateVpcEndpoint",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteRoute",
      "ec2:DeleteRouteTable",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSubnet",
      "ec2:DeleteVpc",
      "ec2:DeleteVpcEndpoints",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribePrefixLists",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribeVpcs",
      "ec2:DetachInternetGateway",
      "ec2:DetachNetworkInterface",
      "ec2:DisassociateRouteTable",
      "ec2:ModifySubnetAttribute",
      "ec2:ModifyVpcAttribute",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2" {
  name        = "${aws_iam_user.bot.name}.ec2"
  description = "Allow user to manage ec2 resources."
  policy      = data.aws_iam_policy_document.ec2.json
}

resource "aws_iam_user_policy_attachment" "ec2" {
  user       = aws_iam_user.bot.name
  policy_arn = aws_iam_policy.ec2.arn
}

data "aws_iam_policy_document" "service_linked_rds" {
  statement {
    effect    = "Allow"
    actions   = ["iam:CreateServiceLinkedRole"]
    resources = ["arn:aws:iam::*:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS"]
    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values   = ["rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "service_linked_rds" {
  name        = "${aws_iam_user.bot.name}.svclinkedrds"
  description = "Allow rds to call aws services on behalf of db instances."
  policy      = data.aws_iam_policy_document.service_linked_rds.json
}

resource "aws_iam_user_policy_attachment" "service_linked_rds" {
  user       = aws_iam_user.bot.name
  policy_arn = aws_iam_policy.service_linked_rds.arn
}

data "aws_iam_policy_document" "rds" {
  statement {
    effect = "Allow"
    actions = [
      "rds:AddTagsToResource",
      "rds:CreateDBInstance",
      "rds:CreateDBSubnetGroup",
      "rds:DeleteDBInstance",
      "rds:DeleteDBSubnetGroup",
      "rds:DescribeDBInstances",
      "rds:DescribeDBSubnetGroups",
      "rds:ListTagsForResource",
      "rds:ModifyDBInstance",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "rds" {
  name        = "${aws_iam_user.bot.name}.rds"
  description = "Allow user to manage rds resources."
  policy      = data.aws_iam_policy_document.rds.json
}

resource "aws_iam_user_policy_attachment" "rds" {
  user       = aws_iam_user.bot.name
  policy_arn = aws_iam_policy.rds.arn
}

data "aws_iam_policy_document" "ecs" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:CreateCluster",
      "ecs:CreateService",
      "ecs:DeleteCluster",
      "ecs:DeleteService",
      "ecs:DescribeClusters",
      "ecs:DeregisterTaskDefinition",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:RegisterTaskDefinition",
      "ecs:TagResource",
      "ecs:UpdateCluster",
      "ecs:UpdateService",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs" {
  name        = "${aws_iam_user.bot.name}.ecs"
  description = "Allow user to manage ecs resources."
  policy      = data.aws_iam_policy_document.ecs.json
}

resource "aws_iam_user_policy_attachment" "ecs" {
  user       = aws_iam_user.bot.name
  policy_arn = aws_iam_policy.ecs.arn
}

data "aws_iam_policy_document" "iam" {
  statement {
    effect = "Allow"
    actions = [
      "iam:AttachRolePolicy",
      "iam:CreatePolicy",
      "iam:CreateRole",
      "iam:DeletePolicy",
      "iam:DeleteRole",
      "iam:DetachRolePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListPolicyVersions",
      "iam:ListRolePolicies",
      "iam:PassRole",
      "iam:TagPolicy",
      "iam:TagRole",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "iam" {
  name        = "${aws_iam_user.bot.name}.iam"
  description = "Allow user to manage iam resources."
  policy      = data.aws_iam_policy_document.iam.json
}

resource "aws_iam_user_policy_attachment" "iam" {
  user       = aws_iam_user.bot.name
  policy_arn = aws_iam_policy.iam.arn
}

data "aws_iam_policy_document" "logs" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:DescribeLogGroups",
      "logs:ListTagsLogGroup",
      "logs:TagResource",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "logs" {
  name        = "${aws_iam_user.bot.name}.logs"
  description = "Allow user to manage cloudwatch resources."
  policy      = data.aws_iam_policy_document.logs.json
}

resource "aws_iam_user_policy_attachment" "logs" {
  user       = aws_iam_user.bot.name
  policy_arn = aws_iam_policy.logs.arn
}
