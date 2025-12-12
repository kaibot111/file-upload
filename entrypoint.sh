#!/bin/sh

# 1. Start Nginx in the background (serves the HTML file)
nginx

# 2. Start BungeeCord in the foreground (runs the game logic)
# Ensure your jar file is named exactly 'BungeeCord.jar'
echo "Starting Eaglercraft Server..."
java -Xmx512M -Xms512M -jar BungeeCord.jar
