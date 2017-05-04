# Quickstart

Let's publish your first API with Panda Sky. We assume you have Node installed and your AWS credentials are already set up. More detail about this example is contained in [this full walkthrough][hello-world].

[hello-world]: /demos/hello-world

## Installation

Install the Panda Sky module, including the `sky` executable.

```shell
npm install -g panda-sky
```

## Initialization

Create a new project directory and initialize it with `npm`.

```shell
mkdir hello-sky
cd hello-sky
npm init
```

Let's initialize it for use with Panda Sky.

```shell
sky init
```

This creates a configuration file, a default API description file, and default handlers. It also updates your `package.json` to include the necessary dependencies to run the code.

## Build And Publish

Package up your application for deployment.

```shell
sky build
```

The creates `deploy/package.zip` file that Panda Sky can pass to AWS.

Now, publish.

```shell
sky publish staging
```

That's all it takes!

It will take about 90 seconds for your API to be prepared.  Once complete,
you'll get a URL that specifies your API's endpoint.  We can curl it to
confirm everything is working properly.  What should come back is the contents
of `api.yaml`, as JSON.

```shell
curl -X GET https://437iur5oyg.execute-api.us-west-2.amazonaws.com/staging
```

# Summary

We've installed Panda Sky, initialized our application, and published a boilerplate API.

To learn more about how you can edit your API, and handlers and add a CloudFront distribution to support custom domains, please see the
[Hello, World][hello-world] tutorial.
