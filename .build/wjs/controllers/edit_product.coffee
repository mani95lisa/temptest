'use strict'

define ['console', 'humane', 'moment'], (console, humane, moment)->
  return ($scope, $http, data, $modalInstance)->

    console.group 'edit_product'

    console.log data
    $scope.data = angular.copy data
    $scope.title = if data then '编辑 '+ data.name else '新增产品'
    $scope.$apply()

    $scope.ok = ->
      data = $scope.data

      if !data.name || !data.category || !data.price
        humane.log '所有项目不能为空'
      else
        arr = data.price.split ' '
        right = true
        prices = []
        arr.forEach (price)->
          arr2 = price.split('=')
          if arr2.length != 2
            right = false
          else
            prices.push label:arr2[0],value:arr2[1]
        if !right
          humane.log '价格格式不正确，应该是 价格标签=价格 的格式，多个以空格隔开'
        else
          data.prices = prices
          $modalInstance.close(data)

    $scope.cancel = ->
      $modalInstance.dismiss 'cancel'


    console.groupEnd()