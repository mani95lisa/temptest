'use strict'

define ['console', 'humane', 'moment'], (console, humane, moment)->
  return ($scope, $http, uiGridConstants, $modal, $interval, $location)->

    console.group 'sms'

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

    caching = []

    $scope.requesting = false

    $scope.externalScopes =

    $scope.gridOptions =
      enableSorting: false
      columnDefs:[
        {name:'手机号', field:'mobile', width:100, enableSorting: false}
        {name:'内容', field:'content', enableSorting: false}
        {name: '时间',field: 'created_at',width: 200, enableSorting: false}
      ]

    $scope.getData = ->
      if $scope.requesting
        return
      $scope.requesting = true
      $http.get('/m/sms/list',params:page:$scope.page,pageSize:$scope.pageSize,mobile:$scope.keywords).success((result)->
        console.group 'sms'
        console.log 'GotSMS', result
        console.groupEnd()
        $scope.requesting = false
        if result.err
          humane.log result.err
        else
          $scope.count = result.count
          if result.result
            result.result.forEach (r)->
              r.created_at = moment(r.creatd_at).format('YYYY-MM-DD HH:MM:SS')
          $scope.gridOptions.data = result.result
      ).error (err)->
        $scope.requesting = false
        if err
          humane.log err

    $scope.getData()

    console.groupEnd()
