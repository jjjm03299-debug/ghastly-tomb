# Use lightweight official Node.js Alpine image
FROM node:20-alpine

# Install curl, bash, and tar for downloading binaries
RUN apk add --no-cache curl bash tar

# Download and extract ngrok directly into /usr/local/bin
RUN curl -fsSL https://bin.ngrok.com/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz \
    | tar -xz -C /usr/local/bin

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
