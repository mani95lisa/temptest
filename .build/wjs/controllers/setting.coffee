'use strict'

define ['console', 'humane', 'moment'], (console, humane, moment)->
  return ($scope, $http, $q, $filter, uiGridConstants, $modal, $interval, $location)->

    console.group 'setting'

    getTags = (key, callback, subKey, valuePro) ->
      getDict $http, key, (result) ->
        console.log(result)
        if subKey
          if result and valuePro
            $scope[subKey][key] = result[valuePro]
          else
            $scope[subKey][key] = result
        else
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
      data.list.forEach (text) ->
        arr.push text.text
      data.list = arr
      $scope.handling = true
      console.log data
      $http.post '/dict/update/list', data
      .success (result) ->
        $scope.handling = false
        if !result.err
          callback true
        else
          humane.log result.err
      return

    $scope.update = (key)->
      data = {}
      data.key = key
      data.value = $scope[key].value
      data._csrf = csrf
      $http.post '/dict/update/list', data
      .success (result) ->
        $scope.handling = false
        if !result.err
          humane.log '更新成功'
        else
          humane.log result.err
      return

    updateResult = (result) ->
      humane.log result.err if result.err

    $scope.tagAdded = (key) ->
      updateTags key, $scope[key], updateResult
    $scope.tagRemoved = (key) ->
      updateTags key, $scope[key], updateResult

    getTags 'LotteryRatio'
    getTags 'LotteryLimit'

    $scope.Pros = {}
    $scope.proRemoved = (key) ->
      updateTags key, $scope.Pros[key], updateResult, true
    $scope.proAdded = (key) ->
      updateTags key, $scope.Pros[key], updateResult, true

    getTags 'Areas', (result) ->
      if result and result.list and result.list.length
        ((pro) ->
          getTags pro, null, 'Pros', 'list'
        ) pro for pro in result.list

    $scope.loadTags = (query) ->
      deffered = $q.defer()
      deffered.resolve $filter('filter') $scope.Building.list, query
      return deffered.promise

    console.groupEnd()