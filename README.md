# jfroxy

Proxy jfrog api, not with given password, but with fetched apiKey.
You can keep security with access control and regularly revoking api-key.

## Features

jfroxy is a proxy for JFrog's APIs, allowing you to hide your jfrog account password by accessing APIs with a token, **not** the password.  Each token is revokable, and there are no access controls.

Basically:

- Hide your JFrog password
- Access APIs with a revokable token
- Do not control access

## Example

JFrog requires that API requests be authenticated.  However, there are some cases where you would not want such auth info to be recorded.

For example, when testing with a CI, you might have such problems as:

- Using **shared, non-human** credentials (because humans might leave the company)
- Removing passwords from build scripts (of course)
- Changing auth info after employee has left company (they could have brought it away with them)
- Decoupling auth info from everything else, because **WE ARE LAZY** and **never** want to change anything when possible

These needs can be satisfied with jfroxy by:

- Running jfroxy with shared, non-human credentials
- Configuring web server/load balancer in front of jfroxy to only pass requests from your office gateway
- Setting up a cron job to revoke token every morning
- Fetching auth info from jproxy prior to **each and every** build

## ENV

- JFROG_URL: https://foo.jfrog.io/foo
- JFROG_USERNAME: username
- JFROG_PASSWORD: **Encrpyted** password

## Run

    JFROG_URL=... JFROG_USERNAME=... JFROG_PASSWORD=... rackup

or

    docker run -e JFROG_URL=... -p 80:80 -d masarakki/jfroxy

## APIs

### GET /api/*

proxy to https://foo.jfrog.io/foo/api/* with apiKey Authentication

if you don't have apiKey, automatically create one.

### GET /key

get ApiKey

### DELETE /key

revoke ApiKey

You **should** revoke api key regularly by cron.

### GET /username

get Username

### GET /encrypted_password

get EncryptedPassword
