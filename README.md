# jfroxy

Proxy jfrog api, not with given password, but with fetched apiKey.
You can keep security with access control and regularly revoking api-key.

## Features

jfroxy is a proxy for jfrog api,

- hide jfrog password
- convert any access to token-authed access (**not** password-authed access)
- token is revokable
- no access control

## Example

JFrog requires authenticated request for APIs,
however, there are some cases that you don't want to write auth informations.

For example, in a case of testing on CI, you have some problems like this:

- You want to use **shared, non-human** account, becase human will leave job someday.
- Of cource, you don't write password in build script.
- You want to change auth informations after someone left job, because if ex-worker write down it, they can access jfrog with it.
- But, you **never** want to edit anything after auth infomation changed, because **WE ARE LAZY**.

In this case, you can satisfy your needs with jfroxy.

- Run jfroxy with shared, non-human account/password.
- Configure web server/load balancer in front of jfroxy that only passes requests from your office.
- Configure cron to revoke token every morning.
- Fetch auth infomation from jproxy **every time** before a build.

## ENV

- JFROG_URL: https://foo.jfrog.io/foo
- JFROG_USERNAME: username
- JFROG_PASSWORD: **Encrpyted** password

## Run

    JFROG_URL=... JFROG_USERNAME=... JFROG_PASSWORD=... rackup

or

    docker run -e JFROG_URL=... -p 80:80 -d masarakkijfroxy

## APIs

### GET /api/*

proxy to https://foo.jfrog.io/foo/api/* with apiKey Authentication

if you don't have apiKey, automatically create one.

### GET /key

get ApiKey

### DELETE /key

revoke ApiKey

You **should** revoke api key regularly by cron.
