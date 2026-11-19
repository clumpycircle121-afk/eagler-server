#!/bin/bash

# Start Paper in the background (sized for Render's 512MB free RAM limit)
cd /app/server
java -Xms256M -Xmx350M -jar paper.jar --nogui &

# Wait 10 seconds for Paper to load
sleep 10

# Keep-Alive loop (pings your Render URL every 10 minutes to prevent sleeping)
(
  while true; do
    sleep 600
    if [ -n "$RENDER_EXTERNAL_URL" ]; then
      curl -s "$RENDER_EXTERNAL_URL" > /dev/null
    fi
  done
) &

# Start Velocity in the foreground
cd /app/proxy
java -Xms64M -Xmx128M -jar velocity.jar
