connect-device-router [![NPM version](https://badge.fury.io/js/connect-device-router.png)](http://badge.fury.io/js/connect-device-router) [![Build Status](https://travis-ci.org/goodeggs/connect-device-router.png)](https://travis-ci.org/goodeggs/connect-device-router)
==============

Connect middleware to route based on X-UA-Device.

Use with [varnish-devicedetect](https://github.com/varnish/varnish-devicedetect/) or [connect-devicedetect](https://github.com/goodeggs/connect-devicedetect) to generate X-UA-Device headers.

Querystring overrides require `connect.query` or similar.

```coffee
connect = require 'connect'
deviceDetect = require 'connect-devicedetect'
deviceRouter = require 'connect-device-router'

desktopApp = connect()
  .use( ... )

mobileApp = connect()
  .use( ... )

app = connect()
  .use(connect.query())
  .use(deviceDetect())
  .use(deviceRouter(
    phone: mobileApp
  ))
  .use(desktopApp)

```

Or use per-route with express:

``` coffee
express = require 'express'

express()
  .get '/', deviceRouter
    phone: (req, res, next) -> # ...
    tablet: (req, res, next) -> # ...
  , (req, res, next) -> # default ...
  .get '/foo', deviceRouter
    desktop: (req, res, next) -> # ...
    phone: (req, res, next) -> # ...
```
