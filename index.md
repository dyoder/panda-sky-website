- [][GitHub]
- [Quick Start][]
- [Tutorial][]
- [API Definitions][]
- [Examples][]

[GitHub]:#
[Quick Start]:#
[Tutorial]:#
[API Definitions]:#
[Examples]:#

**Panda&nbsp;Sky** allows you to publish APIs
just like you can publish static Web sites
to AWS&nbsp;S3 and CloudFront.
Your API will run with the same
reliability, security, and elasticity
as Amazon&nbsp;Web&nbsp;Services.

### Define Your API

```yaml
resources:

  greeting:

    path: "/greeting/{name}"
    description: Returns a greeting for {name}.

  methods:

    get:
      method: GET
      signature:
        status: 200
```

### Define A Handler

```javascript
module.exports = (data, context, callback) => callback `Hello ${data.name}!`
```

### And Publish!

```shell
$ sky publish production
```
