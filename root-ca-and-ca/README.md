A root certificate authority, which 1) directly issues the server certificate, and
2) a working certificate authority, which issues the client certificate.

NOTE: This is faithfully implemented according to https://community.openvpn.net/openvpn/wiki/Using_Certificate_Chains,
but I cannot get OpenVPN to accept this. Probably my fault. Corrections very welcome. Basically the
client says it's fine, but the server says "VERIFY ERROR: depth=1, error=invalid CA certificate: CN=working-ca"

Execute:

``
make
``

Once it is done, you will have:

* `root-ca/root-ca.key` -- private key of the root certificate authority
* `root-ca/root-ca.crt` -- self-signed certificate of the root certificate authority
* `root-ca/root-ca.srl` -- (you can ignore)

* `working-ca/working-ca.key` -- private key of the working certificate authority
* `working-ca/working-ca.csr` -- certificate request for the working certificate authority (you can ignore)
* `working-ca/working-ca.crt` -- certificate of the working certificate authority, issued by the root certificate authority
* `working-ca/working-ca.srl` -- (you can ignore)

* `client/client.key` -- key for the OpenVPN client
* `client/client.csr` -- certificate request of the client (you can ignore)
* `client/client.crt` -- certificate for the OpenVPN client, issued by the working certificate authority
* `client/client-chain.crt` -- combo file that contains both client/client.crt and working-ca/working-ca.crt

* `server/server.key` -- key for the OpenVPN server
* `server/server.csr` -- certificate request of the server (you can ignore)
* `server/server.crt` -- certificate for the OpenVPN server, issued by the root certificate authority

Here is the relevant snippet of your OpenVPN client configuration:

```
ca root-ca/root-ca.crt
cert client/client-chain.crt
key client/client.key
```

And of the OpenVPN server configuration:

```
ca root-ca/root-ca.crt
cert server/server.crt
key server/server.key
```
