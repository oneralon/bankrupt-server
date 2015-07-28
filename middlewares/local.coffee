module.exports = (req, res, next)->
  hostmachine = req.headers.host.split(':')[0]
  if hostmachine isnt 'localhost' then res.status(401).send()
  next()