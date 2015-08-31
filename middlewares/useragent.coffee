module.exports = (req, res, next) ->
  if req.query.render is 'true' and /\:\:1/.test req.connection.remoteAddress
    return next()
  if /android\-bankrupt/.test req.headers['user-agent']
    return next()
  return res.status(403).send()