#
# Create OpenVPN keys without EasyRSA (which may be easy, but is also very confusing)
#
# Enter OpenVPN, which is merely odd. Why do some subcommands read the -config file,
# and others don't?
#

# How many bits do you want for keys
keysize=4096

# Openssl is really too talkative
sendTo=> /dev/null 2>&1

# By default, create certificate authority, client and server certificates
default : ca client server

ca : init ca/ca.crt

ca/ca.crt : ca/ca.key
	@echo ++ Certificate authority it signing its own certificate, commonName is ca
	echo ca | openssl req -x509 -new -nodes -key ca/ca.key -out ca/ca.crt -config ca/ca.cnf $(sendTo)

ca/ca.key : 
	@echo ++ Generating keys for the certificate authority
	openssl genrsa -out ca/ca.key $(keysize) $(sendTo)

client : init client/client.crt

client/client.crt : client/client.csr ca/ca.key
	@echo ++ Certificate authority is issuing certificate for the client
	openssl x509 -req -in client/client.csr -CA ca/ca.crt -CAkey ca/ca.key -out client/client.crt -CAcreateserial $(sendTo)

client/client.csr : client/client.key
	@echo ++ Creating certificate signing request for the client
	echo client | openssl req -new -key client/client.key -out client/client.csr -config ca/ca.cnf $(sendTo)

client/client.key :
	@echo ++ Generating keys for the client
	openssl genrsa -out client/client.key $(keysize) $(sendTo) $(sendTo)

server : init server/server.crt

server/server.crt : server/server.csr ca/ca.key
	@echo ++ Certificate authority is issuing certificate for the server
	openssl x509 -req -in server/server.csr -CA ca/ca.crt -CAkey ca/ca.key -out server/server.crt -CAcreateserial $(sendTo)

server/server.csr : server/server.key
	@echo ++ Creating certificate signing request for the server
	echo server | openssl req -new -key server/server.key -out server/server.csr -config ca/ca.cnf $(sendTo)

server/server.key :
	@echo ++ Generating keys for the server
	openssl genrsa -out server/server.key $(keysize) $(sendTo) $(sendTo)

init :
	@echo ++Create needed directories
	@[[ -d ca ]]      || mkdir ca
	@[[ -d client ]]  || mkdir client
	@[[ -d server ]]  || mkdir server

clean :
	rm -rf ca/ca.{key,crt,srl} client/client.{key,csr,crt} server/server.{key,csr,crt} 

.PHONY: default init ca client server clean
