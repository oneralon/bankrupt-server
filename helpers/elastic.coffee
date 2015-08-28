elasticsearch = require 'elasticsearch'
Promise       = require 'promise'

console.log 'created elastic client'
client = new elasticsearch.Client
  host: 'localhost:9200'
  log: 'error'
  requestTimeout: 60000

exports.like = (fields, text, from, take, ids, trade_ids) ->
  new Promise (resolve, reject) ->

    if text.length < 4
      query_fields = ['title']
      fuzziness = 0
      type = 'phrase_prefix'
      min_score = 0.9999
    else
      query_fields = ['title^1000', 'information^5']
      fuzziness = 1
      type = 'best_fields'
      min_score = 0.99

    query =
      bool:
        should: [
          function_score:
            weight: 100
            query: multi_match:
              query: text
              fields: query_fields
              operator: 'and'
              type: type
              fuzziness: fuzziness
        ]
    if ids? or trade_ids?
      query.bool.must = []
      if ids?
        should = []
        for id in ids
          should.push { "match": { "_id": id } }
        query.bool.must.push bool: { should: should }
      if trade_ids?
        should = []
        for id in trade_ids
          should.push { "match": { "trade": id } }
        query.bool.must.push bool: { should: should }

    query = query: query

    query.from = from
    query.size = take
    query.min_score = min_score
    query.fields = fields

    client.search
      index: 'lots'
      body: query
    .then (resp) ->
      console.log "===> ElasticSearch: #{resp.hits.hits.length}"
      resolve resp.hits.hits.map (hit) -> hit.fields._id
    .catch (err) ->
      console.log err
      reject err
