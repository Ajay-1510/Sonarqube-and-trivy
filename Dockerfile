# Use Nginx to serve static site
FROM nginx:alpine

LABEL maintainer="you@example.com"
LABEL project="Integrating automated security scanning into DevOps pipelines with SonarQube and Trivy"

COPY static/ /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
