## AWS CLI commands for Secrets Manager

aws secretsmanager list-secrets

aws secretsmanager create-secret --name dev-db-secret --description "This is the password for the development DB" --secret-string "MySecretSecureStringXYZ"

aws secretsmanager get-secret-value --secret-id dev-db-secret

aws secretsmanager describe-secret --secret-id dev-db-secret

aws secretsmanager update-secret --secret-id dev-db-secret --secret-string "NewSecretStringXYZ"

aws secretsmanager delete-secret --secret-id dev-db-secret