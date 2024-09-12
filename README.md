# Related Origin Requests demo

See [Related Origin Requests](https://passkeys.dev/docs/advanced/related-origins/)

# Clone this repository

Clone this repository to run it locally or on a remote system.

# Run the server

There are two ways to run a server hosting this demo:

## 1. Run a Python CGI server

    python3 server.py

This will start a CGI server listening on port 8000.
Edit the file to change the port number if needed.

Note that running a CGI server on your machine can be dangerous.
It is used here to add a content-type header to the `well-known/webauthn` response.
Consider running the server in a Docker container or on a cloud server instead.

## 2. Run Apache in a Docker container

A safer option is to run the server in a Docker container.
The Dockerfile can be used to build a Docker image from an Ubuntu base image.
To Build the image:

	docker build -t apache_image:1.0 .

Then run the image in a container mapping to port 8000 (or whatever your preference is).

	docker run --name myapache -d -p 8000:80 apache_image:1.0

Verify you can access the related origins file using something like curl:

	curl http://localhost:8000/.well-known/webauthn -i

This should render as:

```
HTTP/1.1 200 OK
Date: Thu, 12 Sep 2024 12:18:53 GMT
Server: Apache/2.4.58 (Ubuntu)
Last-Modified: Thu, 12 Sep 2024 10:18:23 GMT
ETag: "122-621e96d39188b"
Accept-Ranges: bytes
Content-Length: 290
Content-Type: application/json

{
  "origins": [
    "https://dev-tunnel.github.io",
    "https://demo.dev-tunnel.nl/",
    "https://demo.dev-tunnel.online",
    "https://yourcftunnelendpoint.trycloudflare.com/",
    "https://yourmstunnelendpoint.devtunnels.ms",
    "https://yourngroktunnelendpoint.ngrok-free.app"
  ]
}
```

In particular, it is important that the Content-Length response header is set to `application/json`.


# Run some tunnels

For instance:

Via [ngrok](https://ngrok.com/):

    brew install ngrok
    ngrok http 8000

Via [Microsoft devtunnel](https://learn.microsoft.com/nl-nl/azure/developer/dev-tunnels):

    brew install --cask devtunnel
    devtunnel host -p 8000

Via [cloudflare](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/do-more-with-tunnels/trycloudflare/):

    brew install cloudflared
    cloudflared tunnel --url http://localhost:8000

Note that when visiting tunnel endpoints, some providers provide a warning or require you to sign in first. 
This is to protect against untolerable abuse of tunnels, such as to host a phishing site.

When making requests to non-HTML resources (such as JSON files), these intermediate pages are skipped,
so they should not interfere with your browser's requests to .well-known endpoints.

# Edit and Update

Edit your index.html file and change the rpID constant to point to your "main" rpID.

Note that you cannot use your github pages site (i.e. `myusername.github.io`) as the 'main" rpID, 
as there is no way force a content type response header on the .well-known endpoints.
This is the sole reason a server is used.

# Add origins

Add your origins to .well-known/webauthn.json

Check if your origins are available on all domains:

    curl https://dev-tunnel.github.io/.well-known/webauthn | jq .origins[] | xargs -I {} curl -i {}/.well-known/webauthn

Note that http://localhost:8000 is not considered as a related origin even if you include it in the JSON file.

# Test

Browse to any of the tunnel endpoints, register a credential, and verify you can use that credential on all the other origins.

Note that you need a recent browser that supports RORs. 
See [this](https://passkeys.dev/device-support/) page to check if your browser is supported.

On macOS you will need Safari 18, as distributed with macOS Sequoia.
If you are running macOS Sonoma or Ventura, 
you can install Safari 18 using a separate download from [here](https://developer.apple.com/download/all/).

# Troubleshooting

The following error messages indicate a problem with Related Origins Requests:

Using Chrome:

        Authentication failed: The relying party ID is not a registrable domain suffix of, nor equal to the current domain. 
        Subsequently, fetching the .well-known/webauthn resource of the claimed RP ID was successful, but no listed origin matched the caller.

Check your origins to see if your current origin is listed.

        Authentication failed: The relying party ID is not a registrable domain suffix of, nor equal to the current domain. 
        Subsequently, an attempt to fetch the .well-known/webauthn resource of the claimed RP ID failed.

Check if the `/.well-known/webauthn` endpoint on your "main" origin is returning a correct JSON file.

    Authentication failed: The relying party ID is not a registrable domain suffix of, nor equal to the current domain. 
    Subsequently, the .well-known/webauthn resource of the claimed RP ID had the wrong content-type. (It should be application/json.)

Check if your main domain sets the `Content-type` response header correctly.
