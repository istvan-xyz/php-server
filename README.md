# Publishing

```sh
docker build -t istvan32/php-server .
docker push istvan32/php-server
```

```sh
docker run --privileged --rm tonistiigi/binfmt --install arm64,arm
docker buildx create --use
docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag istvan32/php-server .
docker buildx prune -af
docker buildx stop
```
