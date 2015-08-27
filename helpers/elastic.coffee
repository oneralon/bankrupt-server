elasticsearch = require 'elasticsearch'
Promise       = require 'promise'

console.log 'created elastic client'
client = new elasticsearch.Client
  host: 'localhost:9200'
  log: 'error'

exports.like = (fields, text, from, take, ids, trade_ids) ->
  new Promise (resolve, reject) ->

    query = 
      bool:
        should: [
          function_score:
            weight: 100
            query: multi_match:
              query: text
              fields: ['title^10', 'information^5']
              operator: 'and'
              fuzziness: 2
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
    query.min_score = 0.9
    query.fields = fields

    client.search
      index: 'lots'
      body: query
    .then (resp) ->
      resolve resp.hits.hits.map (hit) -> hit.fields._id
    .catch (err) ->
      console.log err
      reject err
