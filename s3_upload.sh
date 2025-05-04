file=${1:?"Specify a file"}
aws s3 cp $file s3://cf-templates--1hzlje7ed0y9-us-east-1/gitea/$file
