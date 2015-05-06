module.exports = (req, res, next) ->
  res.setHeader 'Access-Control-Allow-Origin', '*'
  res.setHeader 'Access-Control-Allow-Headers', 'Content-Type'
  res.setHeader 'Access-Control-Allow-Methods',
  'GET,HEAD,PUT,POST,DELETE,OPTIONS'
  if req.method is 'OPTIONS' then res.sendStatus(200)
  next()