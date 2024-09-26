# Base image for Python Flask
FROM python:3.12.2 AS flask_builder

# Set working directory
WORKDIR /usr/src/app/GenAIServer

# Copy requirements and install dependencies
COPY Apps/GenAIServer/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy Flask app code
COPY Apps/GenAIServer/ .

# Install PyArmor
RUN pip install pyarmor

# Obfuscate Python code, excluding config.json, and overwrite the original files
RUN pyarmor gen -O . -r --exclude config.json .

# Base image for Node.js Express
FROM node:14 AS node_builder

# Set working directory
WORKDIR /usr/src/app/widget

# Copy package.json and install dependencies
COPY Apps/widget/package.json ./
RUN npm install

# Copy Node.js app code
COPY Apps/widget/ ./

# Obfuscate Node.js code
RUN npm install -g javascript-obfuscator
RUN javascript-obfuscator public/widget.js --output public/widget.js
RUN javascript-obfuscator public/datapacket.js --output public/datapacket.js
RUN javascript-obfuscator public/utils.js --output public/utils.js
RUN javascript-obfuscator server.js --output server.js

# Final image
FROM python:3.12.2  

# Set up Flask server
WORKDIR /usr/src/app/GenAIServer

# Copy obfuscated files from the builder stage (the current directory)
COPY --from=flask_builder /usr/src/app/GenAIServer/. ./

# Expose Flask port
EXPOSE 4040

# Start Flask server
CMD ["python", "app.py"]

# Set up Node.js server
WORKDIR /usr/src/app/widget
COPY --from=node_builder /usr/src/app/widget/ ./

# Expose Node.js port
EXPOSE 3000

# Start Node.js server
CMD ["node", "server.js"]
