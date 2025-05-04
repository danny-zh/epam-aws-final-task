.PHONY: upload-files update-stack make-deploy

upload-files:
	ls *yaml | grep -v infra.yaml | xargs -I {} bash s3_upload.sh {}
update-stack:
	aws cloudformation update-stack \
		--stack-name TestInfra \
		--template-url https://cf-templates--1hzlje7ed0y9-us-east-1.s3.us-east-1.amazonaws.com/gitea/main.yaml \
		--role-arn arn:aws:iam::730335280948:role/CloudFormationAdminRole

deploy: upload-files update-stack
