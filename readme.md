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

If using a different \*.pem, remember to update the file_key in `moduleone.tf`

---

## Running Commands

```bash
git clone https://github.com/alechp/terraform-hello-world
cd terraform-hello-world/ModuleOne

terraform init

terraform plan

terraform apply

terraform destroy
```
