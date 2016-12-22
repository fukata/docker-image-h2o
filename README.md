docker-image-h2o-php
----

# What's this

docker image of h2o(ssl,mruby) with php7.

# Example

```bash
$ docker pull fukata/h2o-php:v2.1.0-beta4
$ docker run -p 18080:80 fukata/h2o-php:v2.1.0-beta4
start_server (pid:1) starting now...
starting new worker 7
[INFO] raised RLIMIT_NOFILE to 1048576
h2o server (pid:7) is ready to serve requests

$ curl http://127.0.0.1:18080/index.html
<!DOCTYPE HTML>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Hello h2o on docker</title>
</head>
<body>
  <h1>Hello h2o on docker</h1>
</body>
</html>

$ curl -i http://127.0.0.1:18080/mruby
HTTP/1.1 200 OK
Date: Thu, 22 Dec 2016 20:35:44 GMT
Connection: keep-alive
Content-Length: 27
Server: h2o/2.1.0-beta4
content-type: text/plain

Hello h2o(mruby) on docker

$ curl http://127.0.0.1:18080/phpinfo.php
...phpinfo...
```
