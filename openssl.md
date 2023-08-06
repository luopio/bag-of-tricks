# Server and client setup locally
```
openssl s_server -accept 30588 -cert broker2.crt -key broker-decrypted.key -CAfile intermediate.crt
```

```
openssl s_client -connect localhost:30588 -cert ../ASU1.crt -key ../ASU1-decrypted.key -CAfile intermediate.crt
```

# Decrypting a file
```
openssl rsa -in ASU1.key -out ASU1-decrypted.key
```

# Inspecting a x509 cert
```
openssl x509 -noout -text -in broker2.crtpaths:
```
