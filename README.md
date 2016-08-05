# JFROXY

Proxy jfrog api, not with given password, but with fetched apiKey.
You can keep security with access control and regularly revoking api-key.

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
