FROM node:20-alpine AS build
WORKDIR /app

ARG VITE_API_URL=http://localhost:8000
ENV VITE_API_URL=$VITE_API_URL

COPY package.json ./
RUN npm install --no-audit --no-fund --loglevel=error

COPY . .
RUN npm run build

FROM nginx:1.27-alpine AS runtime
COPY --from=build /app/dist /usr/share/nginx/html
# Rendered by the nginx image's envsubst entrypoint at startup so the server
# binds to $PORT (Railway injects it; defaults to 80 for local/compose).
# NGINX_ENVSUBST_FILTER limits substitution to PORT so nginx runtime vars
# like $uri and $host are left untouched.
COPY nginx.conf /etc/nginx/templates/default.conf.template
ENV PORT=80 \
    NGINX_ENVSUBST_FILTER=PORT
EXPOSE 80
