// This is used only to store the files and get the files on the instance
resource "aws_s3_bucket" "wawa_test_bucket" {
  bucket = "nish-${local.name}-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_object" "examplebucket_object" {
  key                    = "index.html"
  bucket                 = aws_s3_bucket.wawa_test_bucket.id
  source                 = "index.html"
  server_side_encryption = "aws:kms"
}


resource "aws_s3_bucket" "cw_bucket" {
  bucket = "nish-${local.name}-cwlogs-bucket"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_policy" "cw_bucket" {
  bucket = aws_s3_bucket.cw_bucket.id
  policy = "${data.aws_iam_policy_document.s3_bucket_lb_write.json}"
}


data "aws_iam_policy_document" "s3_bucket_lb_write" {
  policy_id = "s3_bucket_lb_logs"

  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.cw_bucket.arn}/*",
    ]

    principals {
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
      type        = "AWS"
    }
  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    effect = "Allow"
    resources = ["${aws_s3_bucket.cw_bucket.arn}/*"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }


  statement {
    actions = [
      "s3:GetBucketAcl"
    ]
    effect = "Allow"
    resources = ["${aws_s3_bucket.cw_bucket.arn}"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}