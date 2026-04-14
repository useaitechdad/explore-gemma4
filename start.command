#!/bin/bash
cd "$(dirname "$0")"

# Kill any existing server on port 8000
lsof -ti:8000 | xargs kill -9 2>/dev/null

echo "Starting Gemma 4 Demo..."
python3 -m http.server 8000 &
SERVER_PID=$!

sleep 1
open http://localhost:8000

echo "Server running at http://localhost:8000"
echo "Press any key to stop..."
read -n 1
kill $SERVER_PID
