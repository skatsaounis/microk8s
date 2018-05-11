#!/bin/sh
set -eu

mkdir -p meta/hooks

cat << 'EOF' > meta/hooks/install
#!/bin/bash
set -eu

cp -r ${SNAP}/default-args ${SNAP_DATA}/args

#TODO(kjackal): Make sure this works everywhere we want
if [ -f /etc/apparmor.d/docker ]; then
  echo "Updating docker-default profile"
  sed 's/^}$/\ \ signal\ (receive)\ peer=snap.microk8s.daemon-docker,\n}/' -i /etc/apparmor.d/docker
  echo "Reloading AppArmor profiles"
  service apparmor reload
  echo "AppArmor patched"
fi

EOF

chmod +x meta/hooks/install
