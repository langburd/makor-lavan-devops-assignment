# DevOps Assignment

The requirements of the project are described in [REQUIREMENTS.md](REQUIREMENTS.md)

- The application is running in AWS EKS and Azure AKS clusters.  
- The clusters are installed using IaC approach and managed by Terragrunt in `environments` directory.  
- Terraform modules used by Terragrunt are located in `modules` directory.  
- The application itself is located in `app` directory and deployed using the Helm chart located in `helm` directory.  
- Since CI/CD processes are outside the scope of the current project, creating the image and pushing it to the container registry is done manually.
  As well as all infrastructure changes in Terraform and Terragrunt.

## Pre-commit Hooks

This repo uses [pre-commit hooks](https://pre-commit.com/) for linting, formatting and docs creation before the commit.

### `Setup`

- Install `pre-commit` using instructions [here](https://pre-commit.com/#installation)
- Install required tools

```shell
brew install tflint
brew install terraform-docs
```

- Install the hooks

```shell
pre-commit install
```

### `Usage`

The hooks will run automatically before every commit.  
Updates the docs in each module's `README.md` and fixes formatting and linting with commands such as `terraform fmt`.  
If you want to run the checks manually without committing, use the command

```shell
pre-commit run -a
```

## Build the image and push it to the container registry

```shell
REGISTRY=ghcr.io/langburd/makor-lavan-devops-assignment
VERSION=$(cat helm/Chart.yaml| yq -r '.appVersion') && \
docker build --platform linux/amd64 -t $REGISTRY:$VERSION . && \
docker push $REGISTRY:$VERSION
```

## Authenticate to AWS and Azure

```shell
touch $(pwd)/kubeconfig.yaml
export AWS_PROFILE=mend && export KUBECONFIG=$(pwd)/kubeconfig.yaml
aws eks update-kubeconfig --name avilangburd
az login
az aks get-credentials --resource-group "avilangburd" --name "avilangburd-aks" --admin
```

## Deploy all infrastructure and application resources

```shell
terragrunt run-all apply --terragrunt-working-dir environments
```

## Deploy single resource

```shell
terragrunt apply --terragrunt-working-dir environments/<env>/<resource>
```

## Deploy application only

```shell
terragrunt apply --terragrunt-working-dir environments/aws/app
terragrunt apply --terragrunt-working-dir environments/azure/app
```
