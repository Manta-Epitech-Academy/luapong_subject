#!/usr/bin/env bash
# Re-encrypt quiz_answers.yaml and checkpoint_codes.yaml after editing them.
# Run this before committing. A file with no plaintext here is left as it is.
#
#   GPG_PASSPHRASE=... ./encrypt.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
if [[ -z "${GPG_PASSPHRASE:-}" ]]; then
  echo "Set GPG_PASSPHRASE in the environment." >&2
  exit 1
fi
done=0
for name in quiz_answers.yaml checkpoint_codes.yaml; do
  [[ -f "$ROOT/$name" ]] || continue
  gpg --batch --yes --pinentry-mode loopback --passphrase "$GPG_PASSPHRASE" \
    --symmetric --cipher-algo AES256 -o "$ROOT/$name.gpg" "$ROOT/$name"
  echo "encrypted $name -> $name.gpg"
  done=$((done + 1))
done
[[ $done -gt 0 ]] || { echo "no plaintext quiz_answers.yaml or checkpoint_codes.yaml to encrypt" >&2; exit 1; }
