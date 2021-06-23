##########################################################################
# RESOURCES
##########################################################################

#Random ID
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}


#resource "aws_iam_role" "kms-s3-key-role" {
#  name = "iam-role-for-grant"
#
#  assume_role_policy = <<EOF
#{
#    "Id": "key-consolepolicy-3",
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Sid": "Enable IAM User Permissions",
#            "Effect": "Allow",
#            "Principal": {
#                "AWS": ""
#            },
#            "Action": "kms:*",
#            "Resource": "*"
#        },
#        {
#            "Sid": "Allow access for Key Administrators",
#            "Effect": "Allow",
#            "Principal": {
#                "AWS": "${data.aws_caller_identity.current.arn}"
#            },
#            "Action": [
#                "kms:Create*",
#                "kms:Describe*",
#                "kms:Enable*",
#                "kms:List*",
#                "kms:Put*",
#                "kms:Update*",
#                "kms:Revoke*",
#                "kms:Disable*",
#                "kms:Get*",
#                "kms:Delete*",
#                "kms:TagResource",
#                "kms:UntagResource",
#                "kms:ScheduleKeyDeletion",
#                "kms:CancelKeyDeletion"
#            ],
#            "Resource": "*"
#        },
#        {
#            "Sid": "Allow use of the key",
#            "Effect": "Allow",
#            "Principal": {
#                "AWS": "${data.aws_caller_identity.current.arn}"
#            },
#            "Action": [
#                "kms:Encrypt",
#                "kms:Decrypt",
#                "kms:ReEncrypt*",
#                "kms:GenerateDataKey*",
#                "kms:DescribeKey"
#            ],
#            "Resource": "*"
#        },
#        {
#            "Sid": "Allow attachment of persistent resources",
#            "Effect": "Allow",
#            "Principal": {
#                "AWS": "${data.aws_caller_identity.current.arn}"
#            },
#            "Action": [
#                "kms:CreateGrant",
#                "kms:ListGrants",
#                "kms:RevokeGrant"
#            ],
#            "Resource": "*",
#            "Condition": {
#                "Bool": {
#                    "kms:GrantIsForAWSResource": "true"
#                }
#            }
#        }
#    ]
#}
#EOF
#}

#resource "aws_kms_key" "s3-key" {
#  description   = "KMS key for s3 buckets"
#}

#resource "aws_kms_alias" "s3-key-alias" {
#  name          = "alias/osada/s3"
#  target_key_id = aws_kms_key.s3-key.key_id
#}

#resource "aws_kms_grant" "kms-s3-key-grant" {
#  name              = "kms-s3-key-grant"
#  key_id            = data.aws_kms_key.kms-s3-key.key_id
#  grantee_principal = aws_iam_role.kms-s3-key-role.arn
#  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
#}

resource "aws_s3_bucket" "private-bucket" {
  bucket        = "my-private-bucket-${random_integer.rand.result}"
  force_destroy = true
  acl           = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = data.aws_kms_key.kms-s3-key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = merge({ Name = "Private bucket" }, local.common_tags)
}
