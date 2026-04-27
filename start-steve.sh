#!/usr/bin/env bash

# Colors for pretty logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_err() { echo -e "${RED}[ERROR]${NC} $1"; }

PROJECT_ROOT=$(pwd)

# 1. Dependency Checks
MISSING_DEPS=0

log_info "Checking dependencies..."

if ! command -v docker &> /dev/null; then
    log_err "Docker is not installed."
    MISSING_DEPS=1
elif ! docker compose version &> /dev/null; then
    log_err "Docker Compose (v2) is not installed or not in your PATH."
    log_info "Please install the Docker Compose plugin."
    MISSING_DEPS=1
fi

if ! command -v ngrok &> /dev/null; then
    log_err "ngrok is not installed or not in your PATH."
    log_info "Please install ngrok: https://ngrok.com/download"
    MISSING_DEPS=1
fi

if [ ! -d "steve" ] || [ ! -f "steve/docker-compose.yml" ]; then
    log_err "Steve submodule not found or not initialized in ./steve/"
    log_info "Try running: ${YELLOW}git submodule update --init --recursive${NC}"
    MISSING_DEPS=1
fi

if [ $MISSING_DEPS -ne 0 ]; then
    exit 1
fi

# 2. Start Steve
log_info "Starting Steve via Docker Compose..."
cd "$PROJECT_ROOT/steve" || exit 1

# Check if it's already running
if docker compose ps | grep -q "Up"; then
    log_warn "Steve seems to be already running. Restarting..."
    docker compose restart
else
    docker compose up -d
fi

# Wait for Steve to become healthy
log_info "Waiting for Steve to become ready..."
STEVE_MAX_RETRIES=60
STEVE_COUNT=0
until curl -sf http://localhost:8180/steve/manager > /dev/null 2>&1; do
    if [ $STEVE_COUNT -ge $STEVE_MAX_RETRIES ]; then
        log_err "Steve did not become ready in time."
        docker compose logs --tail=20
        exit 1
    fi
    sleep 1
    STEVE_COUNT=$((STEVE_COUNT + 1))
done
log_success "Steve is ready."

# 3. Start Ngrok
log_info "Exposing Steve (port 8180) via ngrok..."
# Start ngrok in background
ngrok http 8180 --log=stdout > /dev/null &
NGROK_PID=$!

# Wait for ngrok to initialize and provide a URL
log_info "Waiting for ngrok URL..."
MAX_RETRIES=15
COUNT=0
NGROK_URL=""

while [ $COUNT -lt $MAX_RETRIES ]; do
    # Try to get the URL from the ngrok local API
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o 'https://[a-zA-Z0-9.-]*\.ngrok-free\.app' | head -n 1)
    if [ -n "$NGROK_URL" ]; then
        break
    fi
    # Alternative grep if the above fails (ngrok URLs can vary)
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^"]*' | head -n 1)
    if [ -n "$NGROK_URL" ]; then
        break
    fi
    sleep 1
    COUNT=$((COUNT + 1))
done

if [ -z "$NGROK_URL" ]; then
    log_err "Failed to get ngrok URL."
    log_info "Make sure ngrok is configured with an authtoken: ${YELLOW}ngrok config add-authtoken <TOKEN>${NC}"
    kill $NGROK_PID 2>/dev/null
    exit 1
fi

log_success "Steve is running and exposed!"
echo -e "----------------------------------------------------"
echo -e "${GREEN}Public URL:${NC}       ${NGROK_URL}/steve/manager"
echo -e "${GREEN}Local URL:${NC}        http://localhost:8180/steve/manager"
echo -e "${GREEN}WebSocket URL:${NC}    ${NGROK_URL/https/wss}/steve/websocket/CentralSystemService"
echo -e "${GREEN}Credentials:${NC}      admin / 1234"
echo -e "----------------------------------------------------"
echo -e "${YELLOW}Logs:${NC} docker compose -f steve/docker-compose.yml logs -f"
echo -e "${YELLOW}Stop:${NC} kill $NGROK_PID && docker compose -f steve/docker-compose.yml down"
echo -e "----------------------------------------------------"

# Optional: keep script running to handle cleanup on Ctrl+C
trap "kill $NGROK_PID 2>/dev/null; log_info 'Ngrok stopped.'; exit" SIGINT SIGTERM
wait $NGROK_PID
