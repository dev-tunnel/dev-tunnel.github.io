# Related Origin Requests demo

See [Related Origin Requests](https://passkeys.dev/docs/advanced/related-origins/)

# Fork, edit and Update

1. Fork this repository
2. Edit your `index.html` and change your RP ID to match yours (e.g. `myusername.github.io`)

# Run the CGI server

    python3 server.py

Note that CGI is dangerous. It is used here to add a content-type header to the `well-known/webauthn` response.
There should be a better way to do this.

# Run some tunnels

For instance:

Via [ngrok](https://ngrok.com/):

    ngrok http 8000

Via [Microsoft devtunnel](https://learn.microsoft.com/nl-nl/azure/developer/dev-tunnels):

    brew install --cask devtunnel
    devtunnel host -p 8000

Via [cloudflare](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/do-more-with-tunnels/trycloudflare/):

    cloudflared tunnel --url http://localhost:8000

# Add origins

Add your origins to .well-known/webauthn.json

Check if your origins are available on all domains:

    curl https://dev-tunnel.github.io/.well-known/webauthn | jq .origins[] | xargs -I {} curl -i {}/.well-known/webauthn
