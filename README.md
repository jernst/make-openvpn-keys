This provides Makefiles that generate the keys needed for OpenVPN, without
EasyRSA (which may be easy, but is confusing as hell)

There are two versions:

* single-ca: a single certificate authority, which issues a client cert and a server cert
* root-ca-and-ca: there is a root certificate authority, which issues the server cert, and
  a cert for a working certificate authority, which in turn issues the client cert.
  (Unfortunately, I can't get this to work; pull requests appreciated :-))

