include .env
.PHONY: upload-files update-stack make-deploy


upload-files:
	ls *yaml | grep -v infra.yaml | xargs -I {} bash s3_upload.sh {}

update-stack:
	aws cloudformation update-stack \
		--stack-name ${STACKNAME} \
		--template-url ${S3BUCKET}/main.yaml \
		--role-arn  ${ROLEARN} \
		--region ${REGION} \
		--parameters ParameterKey=GiteaAdmin,ParameterValue=${GITEAADMIN} ParameterKey=GiteaPass,ParameterValue=${GITEAPASS} ParameterKey=S3Bucket,ParameterValue=${S3BUCKET}

deploy: upload-files update-stack

destroy:
	aws cloudformation delete-stack \
		--stack-name ${STACKNAME} \
		--region ${REGION}