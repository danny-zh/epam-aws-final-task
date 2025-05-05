include .env
.PHONY: upload-files update-stack make-deploy create-stack deploy destroy


upload-files:
	ls *y*ml | grep -v infra.yaml | xargs -I {} bash s3_upload.sh {}

update-stack:
	aws cloudformation update-stack \
		--stack-name ${STACKNAME} \
		--disable-rollback \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-url ${S3BUCKET}/${MAINFILE} \
		--role-arn  ${ROLEARN} \
		--region ${REGION} \
		--parameters ParameterKey=GiteaAdmin,ParameterValue=${GITEAADMIN} ParameterKey=GiteaPass,ParameterValue=${GITEAPASS} ParameterKey=S3Bucket,ParameterValue=${S3BUCKET}

create-stack:
	aws cloudformation create-stack \
		--stack-name ${STACKNAME} \
		--disable-rollback \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-url ${S3BUCKET}/${MAINFILE} \
		--role-arn  ${ROLEARN} \
		--region ${REGION} \
		--parameters ParameterKey=GiteaAdmin,ParameterValue=${GITEAADMIN} ParameterKey=GiteaPass,ParameterValue=${GITEAPASS} ParameterKey=S3Bucket,ParameterValue=${S3BUCKET}

deploy: upload-files

destroy:
	aws cloudformation delete-stack \
		--stack-name ${STACKNAME} \
		--region ${REGION}
