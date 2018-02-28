# Terraform Hello World

Required files structure:

```
ModuleOne/
* moduleone.tf
* terraform.tfvars
* terraform_hello_world.pem
```

.gitignore:

```
*.pem
*.tfvars #<---terraform env variables
```

If using a different `*.pem`, remember to update the file_key in `moduleone.tf`

---

## Running Commands

### Preparation

Before running commands, make sure you have

1. Create `terraform.tfvars` with variable structure:

```
aws_access_key = ""

aws_secret_key = ""

private_key_path = "terraform_hello_world.pem"
```

2. Login to AWS & generate Key Pair in EC2 region where you will be creating new instnace.

   > Currently, aws region set to us-west-1. So you would create a key here:
   > [Key Pairs @ us-west-1](https://us-west-1.console.aws.amazon.com/ec2/v2/home?region=us-west-1#KeyPairs:sort=keyName)

3. Add downloaded `*.pem` to ModuleOne
4. Update `moduleone.tf` key_name to point to your \*.pem

```
variable "key_name" {
  default = "terraform_hello_world"
}
```

### Execution

```bash
git clone https://github.com/alechp/terraform-hello-world
cd terraform-hello-world/ModuleOne

terraform init

terraform plan

terraform apply

terraform destroy
```
