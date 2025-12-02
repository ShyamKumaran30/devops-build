# We are serving a already-built React app.
# No npm install, no build, no Node needed.

FROM nginx:stable-alpine

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy your React build folder into nginx path
COPY build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

