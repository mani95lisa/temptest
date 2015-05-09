'use strict'

define ['console', 'humane', 'moment'], (console, humane, moment)->
  return ($scope, $http, $q, $filter, uiGridConstants, $modal, $interval, $location)->

    console.group 'promotion'

    getTags = (key, callback, subKey, valuePro) ->
      getDict $http, key, (result) ->
        if subKey
          if result and valuePro
            $scope[subKey][key] = result[valuePro]
          else
            $scope[subKey][key] = result
        else
          if key == 'PMTimes' && (!result || !result.list.length)
            result = list:[start:'', end:'']
          else if key == 'PMProducts' && !result
            result = list:[]
          $scope[key] = result
        callback result if result and callback
      return

    updateTags = (key, list, callback, isPro) ->
      if(isPro)
        data = key:key, list:list
      else
        data = list
      data.key = key
      arr = []
      normal = false
      data.list.forEach (text) ->
        if text.text
          normal = true
          arr.push text.text
        else
          return
      data.list = arr if normal
      $scope.handling = true
      console.log data
      $http.post '/dict/update/list', data
      .success (result) ->
        $scope.handling = false
        if !result.err
          callback true
          humane.log '保存成功'
        else
          humane.log result.err
      return

    updateResult = (result) ->
      humane.log result.err if result.err

    $scope.tagAdded = (key) ->
      updateTags key, $scope[key], updateResult
    $scope.tagRemoved = (key) ->
      updateTags key, $scope[key], updateResult

    $scope.productRemove = (pro)->
      console.log pro
      arr = $scope.PMProducts.list
      arr.forEach (p)->
        if p.name == pro.text
          arr.splice arr.indexOf(p), 1
          return

    $scope.productAdded = (pro)->
      console.log pro
      products.forEach (p)->
        if p.name == pro.text
          pinfo = []
          p.prices.forEach (pc)->
            pinfo.push pc.label+'='+pc.value
          p.price_info = pinfo.join ' '
          $scope.PMProducts.list.push p
          return

    getTags 'PMTimes'
    getTags 'PMProducts'
    getTags 'PMProductNames'

    $scope.addTime = ->
      $scope.PMTimes.list.push start:'', end:''

    products = []

    $scope.loadTags = (query) ->
      defer = $q.defer()
      $http.get('/m/product/list',params:page:1,pageSize:10,keywords:query).success (result)->
        products = result.result
        arr = []
        if products && products.length
          products.forEach (p)->
            if p.name
              arr.push p.name
        defer.resolve arr
      return defer.promise

    $scope.getPrices = (prices)->
      arr = []
      if prices
        prices.forEach (p)->
          arr.push p.label+'='+p.value
      return arr.join ' '

    $scope.save = ->
      times = $scope.PMTimes.list
      timesOK = true
      productsOK = true
      if times.length
        times.forEach (t)->
          if !t.start || !t.end
            times.splice times.indexOf(t), 1
          else if !moment(t.start, 'HH:mm').isValid() || !moment(t.end, 'HH:mm').isValid()
            timesOK = false
            humane.log '时段格式错误，应该是 08:00 或 14:00 这样的'
            return
      else
        timesOK = false
      products = $scope.PMProducts.list
      if products.length
        products.forEach (p)->
          if !p.price_info
            humane.log '价格标签不能为空'
            return
          else
            arr = p.price_info.split(' ')
            prices = []
            arr.forEach (pi)->
              arr2 = pi.split('=')
              if arr2.length != 2 || !parseInt(arr2[1])
                humane.log '价格标签格式错误'
                return
              else
                prices.push label:arr2[0],value:arr2[1]
            p.prices = prices
      else
        productsOK = false

      if timesOK
        $scope.tagAdded 'PMTimes'
      if productsOK
        $scope.tagAdded 'PMProducts'
        $scope.tagAdded 'PMProductNames'

    console.groupEnd()