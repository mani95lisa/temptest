'use strict'

define ['console', 'humane', 'moment'], (console, humane, moment)->
  return ($scope, $http, data, $modalInstance)->

    console.group 'edit_joined'

    console.log data
    $scope.data = angular.copy data
    $scope.title = if data then '编辑用户 '+ data.user.nickname+ ' 抽奖号【'+data.number+'】'

    $scope.ok = ->
      data = $scope.data

      switch $scope.radioModel
        when '1'
          data.status = false
        when '2'
          data.status = true
        else
          data.dispatched = true

      $modalInstance.close(data)

    if data.dispatched
      $scope.status = '3'
    else if data.status
      $scope.status = '2'
    else
      $scope.status = '1'

    $scope.$apply()

    $scope.cancel = ->
      $modalInstance.dismiss 'cancel'


    console.groupEnd()