module "s3_bucket" {
  source   = "terraform-aws-modules/s3-bucket/aws"
  version  = "3.6.0"
  for_each = local.backends

  force_destroy           = true
  bucket                  = format("tsh-%s-state", lower(replace(each.key, "/\\s+/", "-")))
  acl                     = "private"
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }
  server_side_encryption_configuration = {}
  replication_configuration            = {}

  policy = jsonencode(templatefile("${path.module}/templates/s3_bucket_policy.tftpl", {
    root_name = each.key
    # account_id = "ci/cd account id"
  }))

  # tags = var.backends[each.key].tags
}

module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"
  version  = "3.1.2"
  for_each = local.backends

  name     = format("tsh-%s-locks", lower(replace(each.key, "/\\s+/", "-")))
  hash_key = "LockID"

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]

  # tags = each.value["tags"]
}

resource "aws_iam_role" "this" {
  for_each = local.backends
  name     = format("TSH_%s_StateAccessRole", replace(each.key, "/\\s+/", "-"))

  # assume_role_policy = jsonencode(templatefile("${path.module}/templates/state_access_iam_role_policy.tftpl", {
  #   account_ids = "${each.value["account_ids"]}" # nie działa
  # }))

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "*"
          },
          "Action" : "sts:AssumeRole",
          "Condition" : {
            "StringLike" : {
              "aws:PrincipalARN" : [
                "arn:aws:iam::*:role/aws-reserved/sso.amazonaws.com/*/AWSReservedSSO_AdministratorAccess_*",
                "arn:aws:iam::*:role/BitbucketOIDC_AdministratorAccess"
              ]
            },
            "StringEquals" : {
              "aws:PrincipalAccount" : "${each.value["account_ids"]}"
            }
          }
        }
      ]
    }
  )

  # tags = each.value["tags"]
}

resource "aws_iam_policy" "bucket_access" {
  for_each    = local.backends
  name        = format("%s_BucketAccessPolicy", replace(each.key, "/\\s+/", "-"))
  path        = "/"
  description = ""

  policy = jsonencode(templatefile("${path.module}/templates/s3_bucket_access_policy.tftpl", {
    s3_bucket_arn = module.s3_bucket[each.key].s3_bucket_arn
  }))
}

resource "aws_iam_policy" "dynamodb_access" {
  for_each    = local.backends
  name        = format("%s_DynamoDBAccessPolicy", replace(each.key, "/\\s+/", "-"))
  path        = "/"
  description = ""

  # policy = jsonencode(templatefile("${path.module}/templates/dynamodb_access_policy.tftpl", {
  #   dynamodb_table_arn = module.dynamodb_table[each.key].dynamodb_table_arn
  # }))

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "ListAndDescribe",
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:List*",
            "dynamodb:DescribeReservedCapacity*",
            "dynamodb:DescribeLimits",
            "dynamodb:DescribeTimeToLive"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "SpecificTable",
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:BatchGet*",
            "dynamodb:DescribeStream",
            "dynamodb:DescribeTable",
            "dynamodb:Get*",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:BatchWrite*",
            "dynamodb:CreateTable",
            "dynamodb:Delete*",
            "dynamodb:Update*",
            "dynamodb:PutItem"
          ],
          "Resource" : "${module.dynamodb_table[each.key].dynamodb_table_arn}"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "bucket_access" {
  for_each   = local.backends
  role       = aws_iam_role.this[each.key].name
  policy_arn = aws_iam_policy.bucket_access[each.key].arn
}

resource "aws_iam_role_policy_attachment" "dynamodb_access" {
  for_each   = local.backends
  role       = aws_iam_role.this[each.key].name
  policy_arn = aws_iam_policy.dynamodb_access[each.key].arn
}