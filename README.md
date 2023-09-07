# Publishing

```sh
docker run --privileged --rm tonistiigi/binfmt --install arm64,arm
docker buildx create --use
docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag istvan32/php-server .
docker buildx prune -af
docker buildx stop
```

# Quick build and test

```sh
docker build -t php-test .
```

```sh
docker run --rm -p 8888:80 -v ./test/www:/www -v ./nginx-default.conf:/etc/nginx/conf.d/default.conf php-test
```
