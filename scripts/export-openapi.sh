#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JAR_PATH="$REPO_ROOT/target/blogging-app-apis-0.0.1-SNAPSHOT.jar"
OUT_DIR="$REPO_ROOT/docs"
OPENAPI_JSON="$OUT_DIR/openapi.json"

mkdir -p "$OUT_DIR"

# Wait until application health endpoint responds, starting the app if needed
if ! curl -sSf http://localhost:9090/api/v1/health >/dev/null 2>&1; then
  if [ ! -f "$JAR_PATH" ]; then
    echo "Error: jar not found at $JAR_PATH. Build the project with 'mvn -B package -DskipTests' first." >&2
    exit 1
  fi
  echo "Starting app from $JAR_PATH ..."
#   java -jar "$JAR_PATH" &>/dev/null &
#   APP_PID=$!
#   echo "App started (pid=$APP_PID), waiting for health endpoint..."
  # wait for health
  for i in {1..30}; do
    if curl -sSf http://localhost:9090/api/v1/health >/dev/null 2>&1; then
      break
    fi
    sleep 2
  done
  if ! curl -sSf http://localhost:9090/api/v1/health >/dev/null 2>&1; then
    echo "App did not become healthy in time." >&2
    # kill $APP_PID || true
    exit 1
  fi
else
  echo "App already running on http://localhost:9090"
fi

# Fetch the Swagger/OpenAPI JSON (springfox v2)
echo "Fetching Swagger JSON from /v2/api-docs ..."
curl -sSf http://localhost:9090/v2/api-docs -o "$OPENAPI_JSON"
if [ $? -eq 0 ]; then
  echo "Saved OpenAPI JSON to $OPENAPI_JSON"
else
  echo "Failed to fetch /v2/api-docs" >&2
  exit 1
fi

echo "You can import $OPENAPI_JSON into Postman (Import -> File) or convert it to a Postman collection using:
  npx openapi-to-postmanv2 -s $OPENAPI_JSON -o $OUT_DIR/postman_collection.json -p"

echo "Done."
