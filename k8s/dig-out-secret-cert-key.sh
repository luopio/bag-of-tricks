Get the key to a file first

KUBECONFIG=~/.kube/de-yeply-virgo kubectl -n public get secret wildcard-yeply-de -o yaml > yeply.de.yaml

Copy the strings from the file

echo "string" | base64 -d > key.txt

That might complain about some bad input, but should work

