elasticsearch = require 'elasticsearch'
Promise       = require 'promise'

console.log 'created elastic client'
client = new elasticsearch.Client
  host: 'localhost:9200'
  log: 'error'
  requestTimeout: 60000

exports.like = (fields, text, from, take, ids, trade_ids, regions, statuses, etps) ->
  new Promise (resolve, reject) ->

    terms = text.split(',').map((i)->i.trim())

    query = bool: should: []

    for text in terms
      if text.length <= 4
        query_fields = ['title']
        fuzziness = 0
        type = 'phrase'
        min_score = 0.99
        minimum_should_match = '100%'
      else
        query_fields = ['title', 'information', 'category']
        fuzziness = 1.5
        type = 'best_fields'
        min_score = 0.001
        minimum_should_match = '80%'

      query.bool.should.push function_score:
        weight: 100
        query: multi_match:
          query: text
          fields: query_fields
          operator: 'and'
          type: type
          fuzziness: fuzziness
          minimum_should_match: minimum_should_match

      query.bool.should.push function_score:
        weight: 100
        query: prefix: title: text

      query.bool.should.push function_score:
        weight: 100
        query: prefix: information: text

      query.bool.should.push function_score:
        weight: 100
        query: prefix: category: text

    query.bool.must = []

    if ids?
      should = []
      for id in ids
        should.push { "term": { "_id": id } }
      query.bool.must.push bool: { should: should }

    if trade_ids?
      should = []
      for id in trade_ids
        should.push { "term": { "trade": id } }
      query.bool.must.push bool: { should: should }

    if regions? end regions.length > 0
      should = []
      for region in regions
        should.push { "term": { "region": region } }
      query.bool.must.push bool: { should: should }

    if statuses? end statuses.length > 0
      should = []
      for status in statuses
        should.push { "term": { "status": status } }
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
      resolve resp.hits.hits.map (hit) -> hit.fields._id
    .catch (err) ->
      console.log err
      reject err
