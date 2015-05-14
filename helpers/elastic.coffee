elasticsearch = require 'elasticsearch'
Promise       = require 'promise'

console.log 'created elastic client'
client = new elasticsearch.Client
  host: 'localhost:9200'
  log: 'error'

exports.like = (fields, filter_fields, text, ids) ->
  new Promise (resolve, reject) ->
    query = {}
    if ids?
      query.filter =
        query:
          ids:
            values: ids

    query.query =
      fuzzy_like_this:
        fields: filter_fields
        like_text: text
    query.fields = fields

    client.search
      index: 'lots'
      body: query
    .then (resp) ->
      resolve resp.hits.hits.map (hit) -> hit.fields._id
    .catch (err) ->
      reject err

