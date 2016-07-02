# Tutorial


Mango allows you to publish APIs
much the way you can publish static Web sites
to S3 and CloudFront.

In this tutorial,
we'll create and publish a simple greeting API.
This requires that we:

- install Mango
- initialize our application for use with Mango
- define an endpoint in YAML
- define a handler in JavaScript
- publish our API

You should have your AWS credentials available
in your environment.

## Installation

    npm install -g mango

## Initialize Your Application

    mango init

This will ask you for the name of your API
and domain and the AWS region (ex: `us-west-2`)
to which you want to publish.

Mango will also define four default environments for you:

- production
- staging
- test
- development

Finally, it will generate a stub `api.yaml`
file for you, which defines your API
and a default Lambda function that will
return that definition.

## Publish Your First API

At this point, you can publish your API
to make sure everything is working properly.

    mango publish production

This will publish your API!
It may take a few minutes to run the first time around.
If your chosen domain is `api.acme.com`
you should be able to `curl` it.

    curl https://api.acme.com

and get back a API reference document as HTML.

## Defining An Endpoint

Let's add a greeting endpoint to `description.yml`.
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

## Defining A Handler

Add a JavaScript file under `lib/handlers`
named `greeting-get.js`.
(Handlers are always referenced as
_<resource>-<method>_.)
Export our greeting function in that file.

```javascript
module.exports = (data, context, callback) => `Hello ${data.name}!`
```

Update `lib/handlers/index.js` to reference our new handler.

```javascript
endpoints = {
  "description-get": require("./description-get")
  "greeting-get": require("./greeting-get")
}
```

Let's publish our update.

    mango publish production

And test it out.

    curl https://api.acme.org/greeting/World
    Hello World!

## Summary

So we've installed Mango, initialized our application,
defined a resource, method, and handler,
and published our API.
