data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance_profile_role" {
  name               = "nish-${local.name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

// Currently the instance will need access to get the files on it
data "aws_iam_policy_document" "instance_profile_role" {

  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketPolicy",
      "s3:GetBucketVersioning"
    ]

    resources = [
      aws_s3_bucket.wawa_test_bucket.arn,
      aws_s3_bucket.cw_bucket.arn,
    ]
  }

  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      "${aws_s3_bucket.wawa_test_bucket.arn}/*",
      "${aws_s3_bucket.cw_bucket.arn}/*"     
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "logs:PutLogEvents",
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "instance_profile_role" {
  role   = aws_iam_role.instance_profile_role.name
  name   = "nish-${local.name}"
  policy = data.aws_iam_policy_document.instance_profile_role.json
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "nish-${local.name}"
  role = aws_iam_role.instance_profile_role.name
}