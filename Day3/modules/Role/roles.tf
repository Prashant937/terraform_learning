resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      },
    ]
  })
}

resource "aws_iam_instance_profile" "prashant_instance" {
  name = "prashant_instance"
  role = aws_iam_role.test_role.name
}


resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.name

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        "Action" : [
          "s3:*"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::my_first_bucket",
          "arn:aws:s3:::my_first_bucket/*"
        ]
      }
    ]
  })
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.prashant_instance.name
}
