#!/bin/bash
set -e

echo "Starting Ollama server..."
ollama serve &
OLLAMA_PID=$!

echo "Waiting for Ollama to be ready..."
until curl -s http://localhost:11434/api/tags > /dev/null 2>&1; do
  sleep 1
done

echo "Pulling r1-1776:70b model..."
ollama pull r1-1776:70b

# Automatycznie pobierz publiczny endpoint z Fly.io metadata
FLY_APP_NAME="${FLY_APP_NAME:-ollama-r1-1776}"
ENDPOINT="https://${FLY_APP_NAME}.fly.dev"

echo "=========================================="
echo "Ollama ready!"
echo "Endpoint: ${ENDPOINT}"
echo "=========================================="
echo ""
echo "Połączenie CLI:"
echo "  OLLAMA_HOST=${ENDPOINT} ollama run r1-1776:70b"
echo ""
echo "API streaming:"
echo "  curl ${ENDPOINT}/api/chat -d '{\"model\":\"r1-1776:70b\",\"messages\":[{\"role\":\"user\",\"content\":\"Hello\"}],\"stream\":true}'"
echo "=========================================="

wait $OLLAMA_PID
