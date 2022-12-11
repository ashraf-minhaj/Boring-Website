cd ./Terraform
# ls -a
echo "arg: $1"

if [[ "$1" == "dev" || "$1" == "stage" || "$1" == "prod" ]]; 
    then
        echo "Destroy for environement: $1"
        terraform destroy -var-file=terraform.$1.tfvars -auto-approve
    else
        echo "Wrong Argument"
        echo "Pass 'dev', 'stage' or 'prod' only."
fi 