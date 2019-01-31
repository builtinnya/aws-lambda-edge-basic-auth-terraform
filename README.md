# aws-lambda-edge-basic-auth-terraform

This is a [Terraform](https://www.terraform.io/) module that creates [AWS Lambda@Edge](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-at-the-edge.html) resources to protect [CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html) distributions with [BASIC Authentication](https://en.wikipedia.org/wiki/Basic_access_authentication).

The purpose of this module is to make it no-brainer to set up AWS resources required to perform BASIC Authentication with AWS Lambda@Edge. If you don't want to take care of tedious jobs such as IAM role setup, this is a right module to go with.

The actual code to perform BASIC Authentication is derived from [lmakarov/lambda-basic-auth.js](https://gist.github.com/lmakarov/e5984ec16a76548ff2b278c06027f1a4#file-lambda-basic-auth-js).

## License

Copyright © 2019 Naoto Yokoyama

Distributed under the MIT license. See the [LICENSE](./LICENSE) file for full details.
