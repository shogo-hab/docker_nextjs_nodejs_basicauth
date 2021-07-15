# フロントエンド(Next.js)のビルド
FROM node:16-alpine as frontend
WORKDIR /frontend

COPY /frontend/pages /frontend/pages
COPY /frontend/public /frontend/public
COPY /frontend/styles /frontend/styles
COPY /frontend/.eslintrc /frontend/.eslintrc
COPY /frontend/next-env.d.ts /frontend/next-env.d.ts 
COPY /frontend/next.config.js  /frontend/next.config.js
COPY /frontend/package.json /frontend/package.json
COPY /frontend/package-lock.json /frontend/package-lock.json
COPY /frontend/tsconfig.json /frontend/tsconfig.json

RUN npm ci 
RUN npx next build
RUN npx next export

# バックエンドのビルド
FROM node:16-alpine as backend
RUN apk add make automake gcc g++ subversion python3
WORKDIR /backend
COPY /backend/src /backend/src
COPY /backend/package.json /backend/package.json
COPY /backend/package-lock.json /backend/package-lock.json
COPY /backend/tsconfig.json /backend/tsconfig.json

RUN npm ci
RUN npm run build

# ホスティング用のNode.jsコンテナ
FROM node:16-slim
WORKDIR /app

COPY --from=frontend /frontend/out/ public/
COPY --from=backend /backend/dist/index.js index.js

ARG BASIC_AUTH_USERNAME 
ARG BASIC_AUTH_PASSWORD
ENV BASIC_AUTH_USERNAME=${BASIC_AUTH_USERNAME}
ENV BASIC_AUTH_PASSWORD=${BASIC_AUTH_PASSWORD}

EXPOSE 3000
CMD ["node", "index.js"]
