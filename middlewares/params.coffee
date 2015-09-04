module.exports = (req, res, next) ->
  req.query = req.body
  next()