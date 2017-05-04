- `sky.yaml`: This the main configuration for the app.
- `api.yaml`: This defines your API using [Panda Sky's expressive format][].
- `src/sky.js`: The root of your application.  All handlers are declared here,
but may be defined by using `require()` to pull code from other files.
- `src/s3.js`: This is an usability wrapper for AWS's S3 service, exposing GET
and PUT as functions within the handler. Formal integration is on the road

[Panda Sky's expressive format]:/reference/api-definitions
