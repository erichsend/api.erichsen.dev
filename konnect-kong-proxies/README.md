# Konnect Setup

- Generate certs from Konnect
- write certs to tls.crt and tls.key
- point to `konnect-kong` namespace and run
```
  kubectl create secret tls kong-cluster-cert -n konnect-kong --cert=/tls.crt --key=/tls.key
```

# Redis Setup

Redis will automatically add a secret to the namespace with the name of the argo app.
