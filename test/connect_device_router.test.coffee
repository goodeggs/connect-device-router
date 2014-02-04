deviceRouter = require '..'
connect = require 'connect'
supertest = require 'supertest'

describe 'connect-device-router', ->
  app = connect()
    .use deviceRouter
      phone: (req, res) ->
        res.end 'phone'
      tablet: (req, res) ->
        res.end 'tablet'
    .use (req, res) ->
      res.end 'desktop'

  request = supertest app

  xit 'adds Vary: X-UA-Device', ->

  describe 'a request with an expected X-UA-Device header', ->
    it 'is routed to the configured middleware', (done) ->
      request.get('/')
        .set('X-UA-Device', 'phone')
        .expect(200, 'phone', done)
