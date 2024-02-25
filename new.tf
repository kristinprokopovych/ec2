provider "aws" {
  region="eu-north-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_iam_user" "myuser" {
  name="newuser"
  
}
resource "aws_iam_group_membership" "mymenbership" {
  name = "krismembrship"
  users =[aws_iam_user.myuser.name]
  group = aws_iam_group.mygroup.name
}

resource "aws_iam_group" "mygroup" {
  name="mygroup"
  
}

resource "aws_iam_policy" "mypolicy" {
  name = "mypolicy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        }
    ]
})
}
resource "aws_iam_group_policy_attachment" "myattach" {
    group = aws_iam_group.mygroup.name
    policy_arn=aws_iam_policy.mypolicy.arn
  
}
resource "aws_iam_access_key" "my_access_key" {
  user = aws_iam_user.myuser.name
  depends_on = [ aws_iam_user.myuser ]
}

resource "local_file" "variables_file" {
  content  = <<-EOF
    variable "access_key" {
    default = "${aws_iam_access_key.my_access_key.id}"
  
}
variable "secret_key" {
    default = "${aws_iam_access_key.my_access_key.secret}"
  
}
    EOF
 
  filename = "C:/Users/dev/Desktop/jenkins terraform/instance/accesskeys.tfvars"
}

/*resource "aws_secretsmanager_secret" "secret_key" {
  name = "secretkey"
}
resource "aws_secretsmanager_secret_version" "secretversion" {
  secret_id = aws_secretsmanager_secret.secret_key.id 
  secret_string = aws_iam_access_key.my_access_key.secret
}
output "access_key_id" {
  value = aws_iam_access_key.my_access_key.id
}

resource "local_file" "access_keys" {
  filename = "C:/Users/dev/Desktop/jenkins terraform/aws/accesskeys.txt"
  content = <<-EOT
Access Key ID: $(aws_iam_access_key.my_access_key.id)
Secret Access Key: $(aws_iam_access_key.my_access_key.secret)
EOT
}*/

