resource "aws_iam_policy" "task_execution_role_policy" {
  name        = "${local.prefix}-task-execution-role-policy"
  path        = "/"
  description = "Allow ecs to retrieve images and write logs."
  policy      = file("./templates/ecs/task-execution-role-policy.json")
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${local.prefix}-task-execution-role"
  assume_role_policy = file("./templates/ecs/task-assume-role-policy.json")
}

resource "aws_iam_role_policy_attachment" "task_execution_role" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.task_execution_role_policy.arn
}

resource "aws_ecs_cluster" "main" {
  name = "${local.prefix}-cluster"
}
