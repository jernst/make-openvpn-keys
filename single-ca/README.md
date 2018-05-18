A single certificate authority, which issues a client cert and a server cert.

Execute:

``
make
``

Once it is done, you will have:

* `ca/ca.key` -- private key of the certificate authority
* `ca/ca.crt` -- self-signed certificate of the certificate authority
* `ca/ca.srl` -- (you can ignore)

* `client/client.key` -- key for the OpenVPN client
* `client/client.csr` -- certificate request of the client (you can ignore)
* `client/client.crt` -- certificate for the OpenVPN client, issued by the certificate authority

* `server/server.key` -- key for the OpenVPN server
* `server/server.csr` -- certificate request of the server (you can ignore)
* `server/server.crt` -- certificate for the OpenVPN server, issued by the certificate authority

Here is the relevant snippet of your OpenVPN client configuration:

``
ca ca/ca.crt
cert client/client.crt
key client/client.key
``

And of the OpenVPN server configuration:

``
ca ca/ca.crt
cert server/server.crt
key server/server.key
``
