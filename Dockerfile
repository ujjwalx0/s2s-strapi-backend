# Use official Node.js image as a base
FROM node:20

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (or yarn.lock)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Set environment variable for production
ENV NODE_ENV=production

# Expose the port the app will run on
EXPOSE 1337

# Command to run the app
CMD ["npm", "run", "start"]
