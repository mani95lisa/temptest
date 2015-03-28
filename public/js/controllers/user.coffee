'use strict'

define ['console', 'humane', 'moment'], (console, humane, moment)->
  return ($scope, $http, uiGridConstants, $modal, $interval, $location)->

    console.group 'user'

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
      edit:(row)->
        modalInstance = $modal.open
          templateUrl:'modals/user.html'
          controller:'EditUser'
          backdrop:'static'
          resolve:
            data:->
              return row.entity
        modalInstance.result.then (data)->
          data._csrf = csrf
          $http.post('/user/update',data).success (result)->
            if result.err
              humane.error result.err
            else
              humane.log '更新成功'
              console.log result
              $scope.getData()
        ,
          ->
            console.log 'dismiss'

    handler = '<div style="text-align: left"><div class="btn-group" ng-disabled="getExternalScopes().requesting">
                <button ng-click="getExternalScopes().edit(row)" class="btn btn-default btn-flat btn-sm">编辑</button>
            </div></div>'

    $scope.gridOptions =
      enableSorting: false
      columnDefs:[
        {name:'手机号', field:'mobile', width:100, enableSorting: false}
        {name:'姓名', field:'truename', width:100, enableSorting: false}
        {name:'昵称', field:'nickname', width:100, enableSorting: false}
        {name:'最近登录', field:'last_login', width:200, enableSorting: false}
        {name: '创建时间',field: 'created_at',width: 200, enableSorting: false}
        {name: '操作',field: 'created_at',width: 120, enableSorting: false, cellTemplate:handler}
      ]

    $scope.getData = ->
      if $scope.requesting
        return
      $scope.requesting = true
      $http.get('/user/list',params:page:$scope.page,pageSize:$scope.pageSize,keywords:$scope.keywords).success((result)->
        console.group 'user'
        console.log 'GotUser', result
        console.groupEnd()
        $scope.requesting = false
        if result.err
          humane.log result.err
        else
          $scope.count = result.count
          if result.result
            result.result.forEach (r)->
              r.last_login = moment(r.last_login).format('YYYY-MM-DD HH:mm:ss')
              r.created_at = moment(r.created_at).format('YYYY-MM-DD HH:mm:ss')
          $scope.gridOptions.data = result.result
      ).error (err)->
        $scope.requesting = false
        if err
          humane.log err

    $scope.getData()

    console.groupEnd()