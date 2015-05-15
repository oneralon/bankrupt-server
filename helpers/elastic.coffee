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
      bool:
        should: [
          function_score:
            query:
              multi_match:
                query: text,
                fields: filter_fields
            ,
            boost_factor: 100
        ,
          function_score:
            query:
              fuzzy_like_this:
                fields: filter_fields,
                like_text: text
            ,
            # boost_factor: 10
        ]

    query.fields = fields

    client.search
      index: 'lots'
      body: query
    .then (resp) ->
      resolve resp.hits.hits.map (hit) -> hit.fields._id
    .catch (err) ->
      console.log err
      reject err
