function varyOnDevice (res) {
  var vary = res.getHeader('vary') || '',
      varyHeaders = vary.split(', ');

  varyHeaders.push('X-UA-Device');
  res.setHeader('vary', varyHeaders.join(', '));
}

module.exports = function(deviceToAppMapping) {
  return function(req, res, next) {
    var app, device;
    varyOnDevice(res);
    device = req.headers['x-ua-device'];
    app = deviceToAppMapping[device];
    if (app) {
      return app(req, res, next);
    } else {
      return next();
    }
  };
}
