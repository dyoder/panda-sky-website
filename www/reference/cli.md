# Usage: `sky`

This document contains use information for Panda Sky's command line interface.
After installation, the executable `sky` is made
available to you.  `sky` has the following subcommands:

- [`init`](#init)—Initializes your API
- [`build`](#build)—Packages up your API for publishing.
- [`publish`](#publish)—Publishes your API
- [`delete`](#delete)—Removes a published API

## build
#### Usage
```shell
sky build
```
#### Description
This packages up your project for publishing.  Panda Sky targets the directories
1. `src/`
2. `node_modules/`

and places them into a single ZIP archive at `deploy/package.zip`.

#### Notes:
> Panda Sky supports CoffeeScript and will compile any within `src/` to JavaScript
before packaging.

> Because only node libraries within `node_modules` can be
required in your deployed code, Panda Sky runs `npm install` to update
`node_modules` before packaging.  For this reason, Panda Sky aborts
if you attempt to build without a `package.json` manifest file.

## delete
```shell
sky delete [ENVIRONMENT NAME]
```
#### Description
This destroys the specified environment.  Be advised that destroying a
CloudFront distribution takes 15-30 minutes to complete.  Gateway and Lambda
destruction takes ~1 minute to complete.

#### Notes
> A Panda Sky environment is specified within the `sky.yaml` file, giving it
an internal namespace and optional custom hostname(s) at which your API should
be made available.

> Panda Sky deployments all include a CloudFormation stack and an S3 bucket to
manage your deployment and deployment metadata, respectively. Both are destroyed
by this command.


## init
```shell
sky init
```
#### Description

This sets up your project for publishing.  You get the following files:
- `sky.yaml`: This the main configuration for the app.
- `api.yaml`: This defines your API using [Panda Sky's expressive format][].
- `src/sky.js`: The root of your application.  All handlers are declared here,
but may be defined by using `require()` to pull code from other files.
- `src/s3.js`: This is an usability wrapper for AWS's S3 service, exposing GET
and PUT as functions within the handler. Formal integration is roadmapped.

These files are stubs of the basic framework needed to deploy your project.

#### Notes
> This command relies on you to setup your own `package.json` with
```shell
npm init
```

> You must also issue the commands
```shell
npm install fairmont --save
npm install js-yaml --save
```

> if you wish to use the libraries required in the `sky.js` Lambda stub.

[Panda Sky's expressive format]: /reference/api-definitions


## publish
```shell
sky publish [ENVIRONMENT NAME]
```
#### Description
This deploys your project to the specified environment.  If the environment
already exists, this applies an update.  Be advised that creating or changing
CloudFront distributions takes 15-30 minutes to complete.  Gateway and Lambda
creation/update takes 1-2 minutes to complete.

#### Notes
> A Panda Sky environment is specified within the `sky.yaml` file, giving it
an internal namespace and optional custom hostname(s) at which your API should
be made available.

> Panda Sky deployments all include an S3 bucket and a CloudFormation stack.
CloudFormation manages your app and its arbitrary components (API, storage, DNS
routing, etc).  The S3 bucket is used to store your deployment metadata. MD5
hashes are stored of your `api.yaml` and `package.zip` files so Panda Sky
knows when to issue CloudFormation update requests.

> Insensitivity to `sky.yaml` changes is a
[known issue](https://github.com/pandastrike/panda-sky/issues/37)
and will be resolved in beta-02.
