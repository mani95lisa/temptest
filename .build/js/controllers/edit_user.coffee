'use strict'

define ['console', 'humane', 'moment'], (console, humane, moment)->
  return ($scope, $http, data, $modalInstance)->

    console.group 'edit_user'

    console.log data
    $scope.data = angular.copy data
    $scope.title = '编辑用户 '+data.nickname
    $scope.$apply()

    $scope.ok = ->
      data = $scope.data
      $modalInstance.close(data)

    $scope.cancel = ->
      $modalInstance.dismiss 'cancel'


    console.groupEnd()