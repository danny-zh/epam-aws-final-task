include .env
.PHONY: upload-files update-stack make-deploy create-stack deploy destroy test-arn make-test-arn test


upload-files:
	ls *y*ml | xargs -I {} aws s3 cp {} ${S3URI}/{}

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

deploy:
	aws s3 mb s3://${BUCKET} &&\
	aws iam get-role --role-name CloudFormationAdminRole > /dev/null && echo "Role CloudFormationAdminRole exists" || (bash scripts/create_role.sh && echo "Role created") &&\
	make upload-files &&\
	(aws cloudformation describe-stacks --stack-name ${STACKNAME} > /dev/null && echo "Stack ${STACKNAME} exists" && make update-stack) || make create-stack 


destroy:
	aws cloudformation delete-stack \
		--stack-name ${STACKNAME} \
		--region ${REGION}

test:
	echo ${S3URI} ${S3URI} ${ROLEARN}


make-test-arn:
	aws cloudformation create-stack \
		--stack-name test-stack \
		--disable-rollback \
		--template-body file://test.yaml \
		--role-arn  ${ROLEARN} \
		--region ${REGION} \
		--parameters ParameterKey=AlbArn,ParameterValue="arn:aws:elasticloadbalancing:us-east-1:${ACCOUNTID}:loadbalancer/app/cmtr-adasd-alb/c472bf464a72b3c8" ParameterKey=TgArn,ParameterValue="arn:aws:elasticloadbalancing:us-east-1:${ACCOUNTID}:targetgroup/cmtr-9be1831a-tg/2b28ae926fea7a5c"

test-arn:
	(aws cloudformation describe-stacks --stack-name test-stack > /dev/null && echo "Stack test-stack exists") || make make-test-arn
	