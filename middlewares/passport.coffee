module.exports = (req, res, next)->
  console.log 'asdfasdfasdf', req
  if req.isAuthenticated()
    next()
  else
    res.status(401).send()
