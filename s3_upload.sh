source .env
file=${1:?"Specify a file"}
aws s3 cp $file ${S3URI}/$file
