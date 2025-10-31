# Build stage
FROM registry.access.redhat.com/ubi9/nodejs-20 AS builder

USER root

RUN dnf update -y

WORKDIR /app

RUN chown -R 1001:1001 /app

USER 1001

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

# Runtime stage
FROM registry.access.redhat.com/ubi9/nodejs-20-minimal

WORKDIR /app

USER root

RUN chgrp -R 0 /app && \
    chmod -R g=u /app

COPY package*.json ./

RUN npm ci --omit=dev && \
    npm cache clean --force && \
    chgrp -R 0 /app && \
    chmod -R g=u /app

COPY --from=builder /app/build ./build

RUN chgrp -R 0 /app && \
    chmod -R g=u /app

USER 1001

EXPOSE 3000

ENV NODE_ENV=production
ENV PORT=3000
ENV HOST=0.0.0.0

CMD ["node", "build/index.js"]

