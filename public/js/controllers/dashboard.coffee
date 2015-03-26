'use strict'

define ['console', 'humane'], (console, humane)->
  return ($scope, $http)->

    console.group 'dashboard'

    $http.get('/m/count').success((result)->
      console.log 'GotCount', result
      if result.err
        humane.log result.err
      else
        result.size = bytesToSize result.size
        $scope.count = result
    ).error (err)->
      console.err err

    console.groupEnd()