# Use Java 8 (Required for most Bungee/Eagler setups) on Alpine Linux
FROM eclipse-temurin:8-jre-alpine

# Install Nginx (Web Server)
RUN apk add --no-cache nginx

# Set working directory
WORKDIR /server

# Copy all your files (jars, html, scripts) into the container
COPY . .

# Move your game file to where Nginx looks for websites
# NOTE: Ensure your game file is named 'index.html' locally before deploying
RUN mkdir -p /usr/share/nginx/html
RUN cp index.html /usr/share/nginx/html/index.html

# Configure Nginx to serve the game AND proxy the websocket connection
# This allows both the site and the game server to run on the same Render URL
RUN echo 'server { \
    listen 80; \
    server_name _; \
    \
    location / { \
        root /usr/share/nginx/html; \
        index index.html; \
        try_files $uri $uri/ =404; \
    } \
    \
    location /server { \
        proxy_pass http://127.0.0.1:8081; \
        proxy_http_version 1.1; \
        proxy_set_header Upgrade $http_upgrade; \
        proxy_set_header Connection "Upgrade"; \
        proxy_set_header Host $host; \
        proxy_set_header X-Real-IP $remote_addr; \
        proxy_read_timeout 86400; \
    } \
}' > /etc/nginx/http.d/default.conf

# Make the startup script executable
RUN chmod +x entrypoint.sh

# Expose the standard web port
EXPOSE 80

# Start the wrapper script
CMD ["./entrypoint.sh"]
