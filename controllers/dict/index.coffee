auth = require '../../lib/auth'
Dict = require('../../models').Dict

module.exports = (app) ->

  app.get '/get', auth.isAuthenticated(), (req, res) ->
    data = req.query
    Dict.findOne
      key:data.key
      'value list'
      (err, result) ->
        if err
          res.josn err:err
        else
          if result
            arr = []
            normal = false
            result.list.forEach (r) ->
              if typeof r == 'string'
                normal = true
                arr.push(r)
            result.list = arr if normal
          res.json result:result

  app.post '/update/list', auth.isAuthenticated(), (req, res) ->
    console.log 'update'
    data = req.body
    delete data['_id']
    Dict.findOneAndUpdate
      key: data.key
      data
      upsert: true
      (err, result) ->
        if err
          res.json err:err
        else
          res.json result: true