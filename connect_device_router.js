module.exports = function(deviceToAppMapping) {
  return function(req, res, next) {
    var app, device;
    device = req.headers['x-ua-device'];
    app = deviceToAppMapping[device];
    if (app) {
      return app(req, res, next);
    } else {
      return next();
    }
  };
}
