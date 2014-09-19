device = require '..'
connect = require 'connect'
supertest = require 'supertest'
assert = require 'assert'

describe 'connect-device-router', ->
  describe 'object literal configuration', ->
    beforeEach ->
      app = connect()
        .use (req, res, next) ->
          res.setHeader 'Vary', 'Accept-Encoding'
          next()
        .use connect.query()
        .use device
          phone: (req, res) ->
            assert.equal(req.device, 'phone')
            res.end 'phone'
          tablet: (req, res) ->
            res.end 'tablet'
        .use device
          desktop: (req, res) ->
            assert.equal(req.device, 'desktop')
            res.end 'desktop'
        .use (req, res) ->
          res.end 'fell through'

      @request = supertest app

    it 'adds Vary: X-UA-Device once', (done) ->
      @request.get('/')
        .expect('Vary', 'Accept-Encoding, X-UA-Device')
        .end(done)

    describe 'a request with an expected X-UA-Device header', ->
      it 'is routed to the configured middleware', (done) ->
        @request.get('/')
          .set('X-UA-Device', 'phone')
          .expect(200, 'phone', done)

    describe 'a request with an undeclared X-UA-Device header', ->
      it 'falls through', (done) ->
        @request.get('/')
          .set('X-UA-Device', 'laptop')
          .expect(200, 'fell through', done)

    describe 'a request with a device querystring', ->
      it 'overrides the header', (done) ->
        @request.get('/?device=tablet')
          .set('X-UA-Device', 'phone')
          .expect(200, 'tablet', done)

  describe 'chaining configuration', ->
    beforeEach ->
      app = connect()
        .use (req, res, next) ->
          res.setHeader 'Vary', 'Accept-Encoding'
          next()
        .use connect.query()
        .use device 'phone', (req, res) ->
          assert.equal(req.device, 'phone')
          res.end 'phone'
        .use device 'tablet', (req, res) ->
          res.end 'tablet'
        .use device 'desktop', (req, res) ->
          assert.equal(req.device, 'desktop')
          res.end 'desktop'
        .use (req, res) ->
          res.end 'fell through'

      @request = supertest app

    describe 'a request with an expected X-UA-Device header', ->
      it 'is routed to the configured middleware', (done) ->
        @request.get('/')
          .set('X-UA-Device', 'phone')
          .expect(200, 'phone', done)

    describe 'a request with an undeclared X-UA-Device header', ->
      it 'falls through', (done) ->
        @request.get('/')
          .set('X-UA-Device', 'laptop')
          .expect(200, 'fell through', done)
