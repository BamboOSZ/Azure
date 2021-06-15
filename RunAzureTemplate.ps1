az login
--
az account set --subscription "Conduce PAYG"

az deployment group create --resource-group V5-EY-Resource-Group --template-file .\template.json --parameters .\parameters.json

