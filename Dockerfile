# Use lightweight official Node.js image
FROM node:20-alpine

# Install curl, bash, wget, and ngrok
RUN apk add --no-cache curl bash wget && \
    curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
    | tee /etc/apk/keys/ngrok.asc >/dev/null && \
    echo "https://ngrok-agent.s3.amazonaws.com" >> /etc/apk/repositories && \
    apk add --no-cache ngrok

# Set working directory inside the container
WORKDIR /app

# Initialize node project and install express directly in container build
RUN npm init -y && npm install express

# Download server.js directly during image build
RUN wget https://raw.githubusercontent.com/jjjm03299-debug/ghastly-tomb/refs/heads/main/server.js

# Configure ngrok auth token during build
RUN ngrok config add-authtoken 3LQHBPTVdmLF44o9iA0U0IyC2F6_3xj4mdDrFSZrxzsXoGBMr

# Expose the application port
EXPOSE 3000

# Start both the Node.js server and the ngrok tunnel concurrently
CMD ["sh", "-c", "node server.js & ngrok http 3000"]
