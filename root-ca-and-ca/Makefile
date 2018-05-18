# How many bits do you want for keys
keysize=4096

# Openssl is really too talkative
sendTo=> /dev/null 2>&1

# By default, create root certificate authority, working certificate authority, and client and server certificates

default : root-ca working-ca client server

root-ca : init root-ca/root-ca.crt

root-ca/root-ca.crt : root-ca/root-ca.key
	@echo ++ Root certificate authority it signing its own certificate, commonName is root-ca
	echo root-ca | openssl req -x509 -new -nodes -key root-ca/root-ca.key -out root-ca/root-ca.crt -config ca.cnf $(sendTo)

root-ca/root-ca.key : 
	@echo ++ Generating keys for the root certificate authority
	openssl genrsa -out root-ca/root-ca.key $(keysize) $(sendTo)

working-ca : init working-ca/working-ca.crt

working-ca/working-ca.crt : working-ca/working-ca.csr working-ca/working-ca.key
	@echo ++ Root certificate authority is issuing certificate for the working certificate authority
	openssl x509 -req -in working-ca/working-ca.csr -CA root-ca/root-ca.crt -CAkey root-ca/root-ca.key -out working-ca/working-ca.crt -CAcreateserial $(sendTo)

working-ca/working-ca.csr : working-ca/working-ca.key
	@echo ++ Creating certificate signing request for the working certificate authority
	echo working-ca | openssl req -new -key working-ca/working-ca.key -out working-ca/working-ca.csr -config ca.cnf $(sendTo)

working-ca/working-ca.key :
	@echo ++ Generating keys for the working certificate authority
	openssl genrsa -out working-ca/working-ca.key $(keysize) $(sendTo) $(sendTo)

client : init client/client.crt

client/client.crt : client/client.csr working-ca/working-ca.key
	@echo ++ Working certificate authority is issuing certificate for the client
	openssl x509 -req -in client/client.csr -CA working-ca/working-ca.crt -CAkey working-ca/working-ca.key -out client/client.crt -CAcreateserial $(sendTo)

client/client.csr : client/client.key
	@echo ++ Creating certificate signing request for the client
	echo client | openssl req -new -key client/client.key -out client/client.csr -config ca.cnf $(sendTo)

client/client.key :
	@echo ++ Generating keys for the client
	openssl genrsa -out client/client.key $(keysize) $(sendTo) $(sendTo)

server : init server/server.crt

server/server.crt : server/server.csr working-ca/working-ca.key
	@echo ++ Working certificate authority is issuing certificate for the server
	openssl x509 -req -in server/server.csr -CA working-ca/working-ca.crt -CAkey working-ca/working-ca.key -out server/server.crt -CAcreateserial $(sendTo)

server/server.csr : server/server.key
	@echo ++ Creating certificate signing request for the server
	echo server | openssl req -new -key server/server.key -out server/server.csr -config ca.cnf $(sendTo)

server/server.key :
	@echo ++ Generating keys for the server
	openssl genrsa -out server/server.key $(keysize) $(sendTo) $(sendTo)

init :
	@echo ++Create needed directories
	@[[ -d root-ca ]]    || mkdir root-ca
	@[[ -d working-ca ]] || mkdir working-ca
	@[[ -d client ]]     || mkdir client
	@[[ -d server ]]     || mkdir server

clean :
	rm -rf root-ca/root-ca.{key,crt,srl} working-ca/working-ca.{key,csr,crt,srl} client/client.{key,csr,crt} server/server.{key,csr,crt} 

.PHONY: default init root-ca working-ca client server clean
