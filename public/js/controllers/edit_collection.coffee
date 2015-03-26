'use strict'

define ['console', 'humane', 'moment'], (console, humane, moment)->
  return ($scope, $http, data, $modalInstance)->

    console.group 'edit_collection'

    console.log data
    $scope.data = angular.copy data
    $scope.title = '编辑 '+ data.name
    if data.cover.indexOf('http://') == -1
      $scope.data.cover = host+data.cover
    $scope.$apply()

    $scope.ok = ->
      $modalInstance.close($scope.data)

    $scope.cancel = ->
      $modalInstance.dismiss 'cancel'


    console.groupEnd()