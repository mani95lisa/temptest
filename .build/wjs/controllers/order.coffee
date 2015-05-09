'use strict'

define ['console', 'humane', 'moment'], (console, humane, moment)->
  return ($scope, $http, uiGridConstants, $modal, $interval, $location)->

    console.group 'order'

    $scope.page = 1
    $scope.search = ->
      $scope.page = 1
      $scope.getData()

    $scope.pageSize = 10
    $scope.pages = [10,25,50,100]

    $scope.footer = 'partials/grid/grid_footer.html'
    $scope.header = 'partials/grid/grid_header.html'

    $scope.$watch 'pageSize', (n)->
      $scope.getData()

    $scope.$watch 'page', (n)->
      $scope.getData()

    getStatus = (v)->
      switch v
        when 0
          return '下单成功'
        when 1
          return '确认成功'
        when 2
          return '订单完成'
        when 3
          return '订单取消'
        when 4
          return '开始配送'

    caching = []

    $scope.requesting = false

    $scope.externalScopes =

      $scope.gridOptions =
        enableSorting: false
        columnDefs:[
          {name:'状态', field:'status', width:100, enableSorting: false}
          {name:'订单详情', field:'detail', enableSorting: false}
          {name:'总价', field:'total_fee', width:60, enableSorting: false}
          {name:'联系人', field:'contact', width:100, enableSorting: false}
          {name:'地址', field:'full_address', width:100, enableSorting: false}
          {name:'确认时间', field:'confirmed_time', width:180, enableSorting: false}
          {name: '创建时间',field: 'created_at',width: 180, enableSorting: false}
        ]

    $scope.getData = ->
      if $scope.requesting
        return
      $scope.requesting = true
      $http.get('/m/order/list',params:page:$scope.page,pageSize:$scope.pageSize,keywords:$scope.keywords).success((result)->
        console.group 'order'
        console.log 'GotOrder', result
        console.groupEnd()
        $scope.requesting = false
        if result.err
          humane.log result.err
        else
          $scope.count = result.count
          if result.result
            result.result.forEach (r)->
              r.status = getStatus(r.status)
              r.full_address = r.areas.join(' ')+' '+r.address
              r.confirmed_time = moment(r.confirmed_time).format('YYYY-MM-DD HH:mm:ss')
              r.created_at = moment(r.created_at).format('YYYY-MM-DD HH:mm:ss')
          $scope.gridOptions.data = result.result
      ).error (err)->
        $scope.requesting = false
        if err
          humane.log err

    $scope.getData()

    console.groupEnd()