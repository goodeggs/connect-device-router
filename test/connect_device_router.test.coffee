deviceRouter = require '..'
connect = require 'connect'
supertest = require 'supertest'

describe 'connect-device-router', ->
  app = connect()
    .use (req, res, next) ->
      res.setHeader 'Vary', 'Accept-Encoding'
      next()
    .use connect.query()
    .use deviceRouter
      phone: (req, res) ->
        res.end 'phone'
      tablet: (req, res) ->
        res.end 'tablet'
    .use (req, res) ->
      res.end 'desktop'

  request = supertest app

  it 'adds Vary: X-UA-Device', (done) ->
    request.get('/')
      .expect('Vary', 'Accept-Encoding, X-UA-Device')
      .end(done)

  describe 'a request with an expected X-UA-Device header', ->
    it 'is routed to the configured middleware', (done) ->
      request.get('/')
        .set('X-UA-Device', 'phone')
        .expect(200, 'phone', done)

  describe 'a request with an undeclared X-UA-Device header', ->
    it 'falls through', (done) ->
      request.get('/')
        .set('X-UA-Device', 'laptop')
        .expect(200, 'desktop', done)

  describe 'a request with a device querystring', ->
    it 'overrides the header', (done) ->
      request.get('/?device=tablet')
        .set('X-UA-Device', 'phone')
        .expect(200, 'tablet', done)
