# poc-aws-dotnet-api-cors

This is a sample project for testing CORS in a .NET Core Web API deployed as a Lambda function using the AWS Serverless Application Model (SAM).

## Deploy the sample application

To use the SAM CLI, you need the following tools.

* SAM CLI - [Install the SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
* .NET Core - [Install .NET Core](https://www.microsoft.com/net/download)
* Docker - [Install Docker community edition](https://hub.docker.com/search/?type=edition&offering=community)

To build and deploy your application for the first time, run the following in your shell:

```bash
sam build
sam deploy --guided
```

## Use the SAM CLI to build and test locally

Build your application with the `sam build` command.

```bash
poc-aws-dotnet-api-cors$ sam build
```

The SAM CLI installs dependencies defined in `src/ServerlessAPI/ServerlessAPI.csproj`, creates a deployment package, and saves it in the `.aws-sam/build` folder.

Test a single function by invoking it directly with a test event. An event is a JSON document that represents the input that the function receives from the event source. Test events are included in the `events` folder in this project.

Run functions locally and invoke them with the `sam local invoke` command.

```bash
poc-aws-dotnet-api-cors$ sam local invoke NetCodeWebAPIServerless --event events/event.json
```

The AWS SAM CLI can also emulate your application's API. Use the `sam local start-api` command to run the API locally on port 3000.

```bash
poc-aws-dotnet-api-cors$ sam local start-api
poc-aws-dotnet-api-cors$ curl http://localhost:3000/
```

## Deploy the Front End

The deploy_frontend.ps1 pwsh script can be run to automatically deploy your front end website to your AWS account. 
```bash
./deploy_frontend.ps1
```

## Cleanup

To delete the sample application that you created, use the AWS CLI. Assuming you used your project name for the stack name, you can run the following:

```bash
sam delete --stack-name poc-aws-dotnet-api-cors
```

## Resources

See the [AWS SAM developer guide](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html) for an introduction to SAM specification, the SAM CLI, and serverless application concepts.

Next, you can use AWS Serverless Application Repository to deploy ready to use Apps that go beyond hello world samples and learn how authors developed their applications: [AWS Serverless Application Repository main page](https://aws.amazon.com/serverless/serverlessrepo/)
