# Tutorials: Hello World

Let's get you setup with your first serverless API deployment, courtesy of Panda
Sky.  

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
Let's examine each of them.  Or, click
[here](#save-any-node-modules-to-your-project) to skip to the next section.

### sky.yaml
```yaml
name: sky
description: Example Project API
projectID: fair-had-try-lax
aws:
  domain: example.com
  region: us-west-2
  environments:
    staging:
      hostnames:
        - staging-api
      # cache:
      #   expires: 0
      #   priceClass: 100

    production:
      hostnames:
        - api
      cache:
        expires: 1800
        priceClass: 100
```
This the main configuration for the app.  Your full app description gets stored
in an S3 bucket during a deployment, but S3 has a global namespace.  The
`projectID` assigned here is arbitrary and random, but it ensures you get a
unique bucket name.  `environments` organizes configuration between different
deployments, allowing you to avoid frequent edits to this file.  Environment
names are arbitrary; just reference it on the commandline when you wish to
deploy.

### api.yaml
```yaml
# Describe your API resources and the endpoints used to access them.
resources:

  discovery:

    path: /
    description: Provides a directory of available resources

    methods:

      get:
        method: GET
        signature:
          response: description
          status: 200

# Define JSON schemas the API uses to validate requests.
schema:

  example:
    $schema: |-
      http://json-schema.org/draft-04/schema
    title: example
    type: object
    properties:
      name:
        type: string
      age:
        type: integer
        minimum: 1

```
This defines your API using [Panda Sky's expressive format][].  This file is
parsed to determine what resources, methods, and models need to be
instantiated in AWS Gateway.  See the above link for more details, but the goal
of this file is to offer a clear declaration of your API while providing
flexibility.

[Panda Sky's expressive format]: /reference/api-definitions

### sky.js
```javascript
var async = require("fairmont").async;
var YAML = require("js-yaml");

// See wiki for more details. Configuration with context injection is roadmapped
// for Beta-02
var name = "sky";
var env = "staging";
var projectID = "fair-had-try-lax";
var app = name + "-" + env;

// helper to simplify the S3 interface. Formal integration is roadmapped.
var s3 = require("./s3")(app + "-" + projectID);

// Handlers
var API = {};

API[app + "-get-description"] = async( function*(data, context, callback) {
  // Instantiate new s3 helper to target deployment "src" bucket.
  var get = require("./s3")(env + "-" + projectID).get;
  var description = YAML.safeLoad( yield( get("api.yaml")));
  return callback( null, description);
});

exports.handler = function (event, context, callback) {
  try {
    return API[context.functionName](event, context, callback);
  } catch (e) {
    return callback(e);
  }
};
```
This is the root of your application.  All Lambda handlers are declared here,
but since we're working with Node, you can separate your code into many files
and invoke them with `require()`.

Handler function names take the form:
```shell
<App Name>-<HTTP Method>-<Resource>
```
All functions are attached to the object `API`.  `exports.handler` is exposed
to all Lambdas.  When invoked, the Lambda will execute its corresponding
function.

Node allows third party modules to be invoked.  AWS's Lambda environment comes
with `aws-sdk` baked in, but all other
modules need to be in your application's `package.json` manifest.  For example,
this app needs `fairmont` and `js-yaml` installed
(see [below](#save-any-node-modules-to-your-project)).

Notice lines 6-9 include application name data.  It's important that these
match the environment you wish to deploy.  Currently, this a manual setting,
but handler context injection is roadmapped for beta-02.

### s3.js
This is an usability wrapper for AWS's S3 service, and you probably won't need
to edit it.  It exposes S3 object GET and PUT as functions within the handler
after you instantiate it with a bucket's name.  Its use in this example also
demonstrates how local files can be pulled into `sky.js` through the
`require()` feature. Formal integration is roadmapped.

## Save Any Node Modules to Your Project

Make sure to include any third party modules in your project's `package.json`
manifest.  Panda Sky relies on `npm` to gather these up when it builds a
deployment package for AWS Lambda.

In our example, `sky.js` requires the inclusion of a couple modules. Save
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

The archive `deploy/package.zip` is created.  It contains all your Node code and
any Node modules from your `package.json` manifest (`node_modules/`).  If you
choose to author your handlers in CoffeeScript, Panda Sky converts it to
JavaScript before placing it in this archive for you.  

The archive contains everything needed for a viable Lambda.  Panda Sky uploads
the archive to an S3 bucket and points the Lambdas it sets up to the archive.

Now, publish. Simply name the environment to access its configuration.
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

## Teardown
Destroying an API is just as easy.

```
sky delete staging
```
All resources associated with your API are also destroyed.

## Caching and Defining a Custom API URL
So, you can publish an API, but you'd like to access it at a URL you define,
not some ugly one randomly generated by AWS.  To do that, you need to
enable caching. Back in `sky.yaml` uncomment the cache stanza in the
staging environment.
```yaml
aws:
  domain: example.com
  region: us-west-2
  environments:
    staging:
      hostnames:
        - staging-api
      cache:
        expires: 0
        priceClass: 100
```
This will ask Panda Sky to setup a CloudFront distribution for you.  That comes
with the ability to set a custom URL for your API, along with edge caching for
GET requests to your API.

#### domain
Specifies root of the custom URL.  This needs to be a domain you
control and have setup in AWS.  Panda Sky also requires you setup an SSL/TSL
certificate in AWS ACM.  Both are simple, but require email verification.  See
our explainer on [AWS domain setup](/reference/aws-setup) for more details.
#### hostnames
Specifies the subdomains that need to point to your API. This is
an array, so you may specify more than one.
#### expires
Specifies how long an API response will be cached.  Panda Strike
recommends setting this to `0` for testing and development environments, and
then setting a non-zero value for production environments.
#### priceClass
CloudFront maintains edge servers globally, but operating in some regions is more costly than others. CloudFront offers this "Price Class" convention as a way to opt out of using the edge servers in these locations. Here are the valid values:

- `100`: Offers the least amount of coverage, solely for the US and Europe.
- `200`: Offers a few additional regions
- `All`: Fully leverages the edge server network

These values are defined and implemented by AWS. You may see the classes
[fully described][] in the official docs.

[fully described]: https://aws.amazon.com/cloudfront/pricing/#price-classes


Once you've updated the configuration, issue another `publish` command.
```shell
sky publish staging
```
The first time Panda Sky sets up a CloudFront distribution for you as part of
deployment it will take 15-30 minutes.  That's all work AWS is doing to
initialize edge server storage, so you'll just have to be patient.  Subsequent
uploads will only take about a minute, so long as you don't delete the API.

After it's done, you should be able to curl your chosen domain:
```shell
    curl https://staging-api.example.com
```

and get back the API reference as JSON.

# Making Edits

## Defining An Endpoint

Let's add a greeting endpoint to `api.yaml`.
Place this under the `resources` property,
either before or after the `description` resource.

```yaml
  greeting:

    path: "/greeting/{name}"
    description: Returns a greeting for {name}.

  methods:

    get:
      method: GET
      signature:
        status: 200
```

We've defined a `greeting` resource
and a method within that resource named `get`.

# Defining A Handler

In `sky.js`, add the following function to the `API` object.

```javascript
API[app + "-get-greeting"] = async( function*(data, context, callback) {
  var msg = "Hello" + data.name + "!";
  return callback( null, msg);
});
```

Let's publish our update. Don't forget to build what you just changed.
```shell
sky build
sky publish staging
```

Because the CloudFront distribution is already setup, this should only
take about 60 seconds.  When it's done, test it out.
```shell
$ curl https://staging-api.example.com/greeting/World
Hello World!
```

# Summary

So we've installed Panda Sky, initialized our application,
defined a resource, method, and handler,
and published our API.  We know how to setup custom URLs for our API,
and we can issue updates easily and see them live.
