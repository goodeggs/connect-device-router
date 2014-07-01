function varyOnDevice (res) {
  var vary = res.getHeader('vary') || '',
      varyHeaders = vary.split(', ');

  varyHeaders.push('X-UA-Device');
  res.setHeader('vary', varyHeaders.join(', '));
}

function normalizeDevice (req) {
  var query = req.query && req.query.device,
      header = req.headers['x-ua-device'];

  return query || header || 'unspecified';
}

module.exports = function(deviceToAppMapping) {
  return function(req, res, next) {
    var app;

    // Only add vary the first time
    if (!req.device) {
      req.device = normalizeDevice(req);
      varyOnDevice(res);
    }

    app = deviceToAppMapping[req.device];
    if (app) {
      return app(req, res, next);
    } else {
      return next();
    }
  };
};
