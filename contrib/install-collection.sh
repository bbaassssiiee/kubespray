#!/bin/bash -eux

NAMESPACE=kubernetes_sigs
COLLECTION=kubespray
# dir of script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
# parent dir of that dir
PARENT_DIRECTORY="${DIR%/*}"

MY_VER=$(grep '^version:' "$PARENT_DIRECTORY/galaxy.yml" | cut -d: -f2 | sed 's/ //')

cd "$PARENT_DIRECTORY"
ansible-galaxy collection build --force --output-path .
# Create requirements.yml file anew for the cat.
cat >> kube-collection.yml << EOT
collections:
  - name: $NAMESPACE-$COLLECTION-$MY_VER.tar.gz
    type: file
    version: $MY_VER
EOT
ansible-galaxy collection install --force -r kube-collection.yml
rm kube-collection.yml
