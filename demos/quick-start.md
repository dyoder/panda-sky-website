# Quickstart

Let's get you setup with your first serverless API deployment, courtesy of Panda
Sky.  This quickly covers what Panda Sky usage looks like, but more detail about
this example is contained in [this full walkthrough][].

[this full walkthrough]: /demos/hello-world

## Prerequisites
Panda Sky has a couple requirements in place before it can work its magic.

#### Node
Your system must have Node v4.5.0 installed.
1. If you have `nvm` installed, run:
```shell
nvm install 4.5
```
2. If you **don't** have `nvm`, please see [Node's site][] for installation
instructions.

#### AWS Credentials
Panda Sky needs your AWS credentials to allocate resources on your behalf.  If
you've installed the AWS CLI tool, they should be on your machine already.
Panda Sky looks for them in their default location within the home
directory, `~/.aws/`.

If you do not have an AWS account, [this AWS tutorial][] walks you through the
process of setting one up.  You can either manually place your credentials into
the `~/.aws/` directory or follow the instructions to install the CLI to let it
do that for you automatically.

> **YOUR AWS CREDENTIALS SHOULD NEVER BE PLACED WITHIN YOUR PROJECT'S REPO NOR
DOES PANDA SKY ASK FOR THEM IN THE MAIN CONFIG FILE.**

[Node's site]: https://nodejs.org/en/
[this AWS tutorial]: http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html


## Installation
Let's get to work.  Install Panda Sky on your machine.

```shell
npm install -g panda-sky
```

You now have the executable `sky` in your terminal.

## Initialize Your Application
Start my creating a new project directory and initializing it with `npm`.

```shell
mkdir hello
cd hello
npm init
```

That gives your project a `package.json`, which is (among other things) a
manifest for Node modules that your app needs when it is deployed.  We're ready
to initialize with Panda Sky.

```shell
sky init
```

This drops in stubs of files you use to write and configure your serverless API.
As a quick overview:

- `sky.yaml`: This the main configuration for the app.
- `api.yaml`: This defines your API using [Panda Sky's expressive format][].
- `src/sky.js`: The root of your application.  All handlers are declared here,
but may be defined by using `require()` to pull code from other files.
- `src/s3.js`: This is an usability wrapper for AWS's S3 service, exposing GET
and PUT as functions within the handler. Formal integration is roadmapped.

[Panda Sky's expressive format]: /reference/api-definitions

The code contained in `sky.js` requires the inclusion of a couple modules. Save
them to your project's dependency manifest.
```shell
npm install fairmont --save
npm install js-yaml --save
```

## Publish Your First API

At this point, we're ready to publish.  Package up your application for
deployment.
```shell
sky build
```

The archive `deploy/package.zip` is created.  Panda Sky passes this to AWS when
it sets up your Lambda handlers.

Now, publish.
```shell
sky publish staging
```

That's all it takes!

It will take about 90 seconds for your API to be prepared.  Once complete,
you'll get a URL that specifies your API's endpoint.  We can curl it to
confirm everything is working properly.  What should come back is the contents
of `api.yaml`, in JSON.
```shell
$ curl -X GET https://437iur5oyg.execute-api.us-west-2.amazonaws.com/staging

{"resources":{"discovery":{"path":"/","description":"Provides a directory of available resources","methods":{"get":{"method":"GET","signature":{"response":"description","status":200}}}}},"schema":{"example":{"$schema":"http://json-schema.org/draft-04/schema","title":"example","type":"object","properties":{"name":{"type":"string"},"age":{"type":"integer","minimum":1}}}}}
```

# Summary

So you've seen the basics. We've installed Panda Sky, initialized our
application, and published a very basic API.

From this base, you can make edits to your API and update them quickly. For
more thorough examples, including custom endpoint definitions, please see the
[Panda Sky Tutorials][].

[Panda Sky Tutorials]:/demos
