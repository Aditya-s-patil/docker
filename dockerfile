# Use a minimal base image
FROM alpine:latest

# Set the working directory inside the container
WORKDIR /app

# Copy your docker-compose.yml file into the container
COPY docker-compose.yml .

# Default command: print message to user
CMD ["docker-compose", "up"]
