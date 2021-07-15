# フロントエンド(Next.js)のビルド
FROM node:15.14.0-alpine3.13 as frontend
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

# バックエンドのビルドとフロントエンドの成果物の設置
FROM node:15.14.0-alpine3.13 as backend
WORKDIR /backend
COPY /backend/src /backend/src
COPY /backend/package.json /backend/package.json
COPY /backend/package-lock.json /backend/package-lock.json
COPY /backend/tsconfig.json /backend/tsconfig.json

ARG BASIC_AUTH_USERNAME 
ARG BASIC_AUTH_PASSWORD
ENV BASIC_AUTH_USERNAME=${BASIC_AUTH_USERNAME}
ENV BASIC_AUTH_PASSWORD=${BASIC_AUTH_PASSWORD}

RUN npm ci
RUN npm run build
RUN chmod -R 755 dist

COPY --from=frontend /frontend/out/ public/
EXPOSE 3000
