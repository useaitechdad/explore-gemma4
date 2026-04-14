#!/bin/bash
cd "$(dirname "$0")"

echo "Cleaning up..."
if [ -f .env ]; then
  cp .env env.txt
fi
# Kill any existing server on port 8000 to prevent 'Address already in use' errors
lsof -ti:8000 | xargs kill -9 2>/dev/null

echo "Starting Gemma 4 Demo Local Server..."
python3 -m http.server 8000 &
SERVER_PID=$!

sleep 1
open http://localhost:8000

echo "Server is running!"
echo "Press ANY KEY in this window to stop the server and close..."
read -n 1
kill $SERVER_PID
