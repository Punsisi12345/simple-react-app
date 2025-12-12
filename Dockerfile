#Stage 1 build the react app
FROM node:22 AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (or pnpm-lock.yaml/yarn.lock)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all source files
COPY . .

# Build the app for production (Vite outputs to /dist)
RUN npm run build

# Stage 2: Serve with NGINX
FROM nginx:stable-alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy the build output from Stage 1
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
