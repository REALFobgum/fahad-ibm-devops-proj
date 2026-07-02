# Use the official stable lightweight Nginx image
FROM nginx:alpine

# Copy static website files to the default Nginx public directory
COPY ./src /usr/share/nginx/html

# Expose HTTP port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
