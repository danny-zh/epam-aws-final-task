#!/bin/bash

ROLE_NAME="CloudFormationAdminRole"

# Trust policy to allow CloudFormation to assume the role
TRUST_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudformation.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
)

# Create the role
aws iam create-role \
  --role-name $ROLE_NAME \
  --assume-role-policy-document "$TRUST_POLICY" \
  --description "Role for CloudFormation with AdministratorAccess"

# Attach AdministratorAccess managed policy
aws iam attach-role-policy \
  --role-name $ROLE_NAME \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

echo "✅ Role '$ROLE_NAME' created and AdministratorAccess policy attached."

