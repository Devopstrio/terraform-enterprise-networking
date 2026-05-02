.PHONY: help init plan apply destroy validate lint test-unit

help:
	@echo "Terraform Enterprise Networking - Management Commands"
	@echo "----------------------------------------------------"
	@echo "init              : Initialize terraform modules"
	@echo "plan              : Generate and show an execution plan"
	@echo "apply             : Build or change infrastructure"
	@echo "destroy           : Destroy infrastructure"
	@echo "validate          : Validate terraform configuration"
	@echo "lint              : Run tflint"
	@echo "test-unit         : Run unit tests for terraform modules"

init:
	terraform init

plan:
	terraform plan -out=tfplan

apply:
	terraform apply tfplan

destroy:
	terraform destroy -auto-approve

validate:
	terraform validate

lint:
	tflint

test-unit:
	go test -v tests/unit
