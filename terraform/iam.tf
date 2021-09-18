resource "aws_iam_user" "tf_user" {
    name      = "richardnpaul-tf"
    tags      = {
        "Name" = "Terraform"
    }
}