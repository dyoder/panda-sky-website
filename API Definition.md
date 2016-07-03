# Mango API Definitions

The Mango API definition is a YAML description
of your API.
At the top level, a Mango API definition
has four properties:

- a name
- a description
- a resources dictionary
- a schema dictionary

## The Resources Dictionary

Each resource for an API
is described as entry in the resources dictionary.
The key is the resource name
(which is used to determine the handler name)
and the value describes the resource itself.

Each resource has three properties:

- a description
- a path
- a methods dictionary

The path may include parameters using curly braces,
such as `/greeting/{name}`.
These will be available as attributes in the `data`
object passed in to your handler.

## The Methods Dictionary

Each method for a given resource
is described as entry in the methods dictionary.
The key is the method name
(which is used to determine the handler name)
and the value describes the resource itself.

Each method has two properties:

- the HTTP method used to invoke it
- a signature

## Method Signatures

The signature includes three properties,
one for the request and one for the response
and one for the expected status.
All are optional.
The `status` property defaults to `200`.

When provided, the `request` and `response`
properties should reference a type defined
by the API's `schema` property.

## The Schema Dictionary

The schema dictionary describes the types
referenced by resource method descriptions.
The key is the name of the type.
The value is the schema description itself.

Each schema description contains
a `$schema` property that indicates which
version of JSON schema is being used
to define the type.
The rest of the description should be
a corresponding JSON schema description
of the type.

There are two JSON Schema attributes that must be defined.
A `title` attribute and a `mediaType` attribute.
The `title` determines how to reference the type.
The `mediaType` will be used in future versions of Mango
to determine what `accept` or `content-type` headers to use.
This can either be `application/json` or a custom media type,
such as:

    application/vnd.acme.org.greeting+json; version=1.0; charset=UTF-8

## Comparison To Other API Description Formats

Other API definition formats, such as Swagger or RAML,
get the semantics of HTTP resources wrong.
Query parameters help identify a _resource_
not a _method_ on a resource.
In addition, they are by necessity more complex
since they are attempting to allow describing
arbitrary APIs, whereas Mango is only concerned with
(a) APIs that can be published to the API Gateway, and
(b) follow our own [opinionated software][] best practices.

[opinionated software]:https://gettingreal.37signals.com/ch04_Make_Opinionated_Software.php
