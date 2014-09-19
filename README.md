connect-device-router [![NPM version](https://badge.fury.io/js/connect-device-router.png)](http://badge.fury.io/js/connect-device-router) [![Build Status](https://travis-ci.org/goodeggs/connect-device-router.png)](https://travis-ci.org/goodeggs/connect-device-router)
==============

Connect middleware to route based on X-UA-Device.

Use with [varnish-devicedetect](https://github.com/varnish/varnish-devicedetect/) or [connect-devicedetect](https://github.com/goodeggs/connect-devicedetect) to generate X-UA-Device headers.

Querystring overrides require `connect.query` or similar.

```coffee
connect = require 'connect'
deviceDetect = require 'connect-devicedetect'
device = require 'connect-device-router'

desktopApp = connect()
  .use( ... )

mobileApp = connect()
  .use( ... )

app = connect()
  .use(connect.query())
  .use(deviceDetect())
  .use(device(phone: mobileApp))
  .use(desktopApp)

```

Or use per-route with express:

``` coffee
express = require 'express'
deviceRouter = require 'connect-device-router'

express()
  # map devices to handlers with chained middleware:
  .get '/foo',
    device 'phone', (req, res, next) ->
      # ...
    device 'desktop', (req, res, next) ->
      # ...
    (req, res, next) ->
      # default

  # or an object literal:
  .get '/', device
    phone: (req, res, next) -> # ...
    tablet: (req, res, next) -> # ...
  , (req, res, next) -> # default ...

  # or mix both styles:
  .get '/',
    device phone: (req, res, next) ->
      # ...
    device tablet: (req, res, next) ->
      # ...
    (req, res, next) ->
      # default ...

```
