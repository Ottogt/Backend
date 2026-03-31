#!/usr/bin/env bash
# Uso (una vez):
#   1) GitHub → Settings → Developer settings → Personal access tokens
#      Crea un token (classic) con scope "repo", o fine-grained con permiso crear repos.
#   2) export GITHUB_TOKEN=ghp_xxxxxxxx
#   3) bash scripts/crear-repo-y-push.sh
set -euo pipefail
REPO_NAME="${GITHUB_REPO_NAME:-Habitos-Atomicos-API}"
OWNER="${GITHUB_OWNER:-Ottogt}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "Falta GITHUB_TOKEN. Ejemplo: export GITHUB_TOKEN=ghp_xxxx && bash scripts/crear-repo-y-push.sh"
  exit 1
fi

# Fine-grained: Bearer. Classic (ghp_): token
if [[ "${GITHUB_TOKEN}" == github_pat_* ]]; then
  AUTH_HDR="Authorization: Bearer ${GITHUB_TOKEN}"
else
  AUTH_HDR="Authorization: token ${GITHUB_TOKEN}"
fi

echo "Creando https://github.com/${OWNER}/${REPO_NAME} (si no existe)..."
HTTP=$(curl -sS -o /tmp/gh-create.json -w '%{http_code}' \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "${AUTH_HDR}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/user/repos" \
  -d "{\"name\":\"${REPO_NAME}\",\"description\":\"API Hábitos Atómicos\",\"private\":false,\"auto_init\":false}")

if [[ "$HTTP" == "201" ]]; then
  echo "Repo creado."
elif [[ "$HTTP" == "422" ]]; then
  echo "El repo ya podría existir (HTTP 422). Intentando push de todas formas."
else
  echo "Error al crear repo (HTTP $HTTP):"
  cat /tmp/gh-create.json
  exit 1
fi

git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/${OWNER}/${REPO_NAME}.git"

echo "Subiendo rama main..."
git push -u origin main
echo "Listo: https://github.com/${OWNER}/${REPO_NAME}"
