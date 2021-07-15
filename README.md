# build
```
docker build \
   --no-cache \
   --build-arg BASIC_AUTH_USER=123 \
   --build-arg BASIC_AUTH_PASSWORD=123 \
   -t node-next-basic-auth .
```

# run
```
docker run -it -p 3000:3000 --rm node-next-basic-auth 
```