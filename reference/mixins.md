> Mixins are roadmapped for Beta-02.  Consider this section a work in progress.
> The Beta-01 release contains a limited, built-in integration with S3 and is
> discussed in the [tutorials][].

[tutorials]:/demos

Mixins are a resource that you can add
to your application so that your API
can access them.
Since your AWS credentials are
available to Panda Sky handlers (Lambda functions)
any AWS resource can potentially be “mixed in”
this way.

Currently, the only supported mixin is S3.
But our roadmap includes plans for mixing in
Cognito, RDS, SQS, SNS, and many others.

# Adding A Mixin

To add a mixin to your application,
just run `mixin add`.

    sky mixin add s3

Each mixin has an “interviewer”,
which is just a set of questions
associated with that mixin.

For example, for the S3 mixin,
Panda Sky needs to know the name of the bucket.
The API domain name is the default.

# Removing A Mixin

You can remove a mixin the same way you add them.

    sky mixin rm s3

Keep in mind, unlike deleting an API environment,
removing a mixin does not delete the corresponding AWS resource.
All it does is disassociate it from your API.
