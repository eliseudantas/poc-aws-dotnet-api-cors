# Get user input for stack name
$stack_name = Read-Host "Enter the name of the CloudFormation stack:"

# Get the API Gateway URL from the stack
$api_gateway_endpoint = aws cloudformation describe-stacks --stack-name $stack_name --query "Stacks[0].Outputs[?OutputKey=='APIGatewayEndpoint'].OutputValue" --output text

# Get the CloudFront Distribution ID from the stack
$cloudfront_distribution_id = aws cloudformation describe-stacks --stack-name $stack_name --query "Stacks[0].Outputs[?OutputKey=='CloudFrontDistributionId'].OutputValue" --output text

# Get the S3 Bucket Name from the stack
$s3_bucket_name = aws cloudformation describe-stacks --stack-name $stack_name --query "Stacks[0].Outputs[?OutputKey=='WebS3BucketName'].OutputValue" --output text

# Output the results
Write-Host "API Gateway URL: $api_gateway_endpoint"
Write-Host "CloudFront Distribution ID: $cloudfront_distribution_id"
Write-Host "S3 Bucket Name: $s3_bucket_name"

# Move to frontend and install
Set-Location src/Frontend

# Create or replace config.js file for building distribution with API Gateway Endpoint defined
Set-Content -Path "config.js" -Value "window.API_URL = '$api_gateway_endpoint';"

# Confirm that the endpoint has been added to the config.js file
Write-Host "The API Gateway endpoint has been added to the config.js file:"
Get-Content "config.js"

# Sync distribution with S3
aws s3 sync . "s3://$s3_bucket_name/"

# Create cloudfront invalidation and capture id for next step
$invalidation_output = aws cloudfront create-invalidation --distribution-id $cloudfront_distribution_id --paths "/*"
$invalidation_id = $invalidation_output | Select-String -Pattern '(?<=Id": ")[^"]+' | ForEach-Object { $_.Matches.Value }

# Wait for cloudfront invalidation to complete
aws cloudfront wait invalidation-completed --distribution-id $cloudfront_distribution_id --id $invalidation_id

# Get cloudfront domain name and validate
$cloudfront_domain_name = aws cloudfront list-distributions --query "DistributionList.Items[?Id=='$cloudfront_distribution_id'].DomainName" --output text

Write-Host "The invalidation is now complete - please visit your cloudfront URL to test: https://$cloudfront_domain_name"