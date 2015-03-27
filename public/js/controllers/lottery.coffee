'use strict'

define ['console', 'humane', 'moment'], (console, humane, moment)->
  return ($scope, $http, uiGridConstants, $modal, $interval, $location)->

    console.group 'lottery'

    $scope.page = 1
    $scope.search = ->
      $scope.page = 1
      $scope.getData()

    $scope.pageSize = 10
    $scope.pages = [10,25,50,100]

    add = '新增'

    $scope.functions = [add]
    $scope.run = (value)->
      if value == add
        addProduct()

    addProduct = ->
      modalInstance = $modal.open
        templateUrl:'modals/lottery.html'
        controller:'EditLottery'
        backdrop:'static'
        resolve:
          data:->
            return ''
      modalInstance.result.then (data)->
        data._csrf = csrf
        if data._id
          $http.post('/lottery/update',data).success (result)->
            if result.err
              humane.error result.err
            else
              humane.log '更新成功'
              console.log result
              $scope.getData()
          ,
            ->
              console.log 'dismiss'
        else
          $http.post('/lottery/add',data).success (result)->
            if result.err
              humane.log result.err
            else
              humane.log '新增成功'
              console.log result
              $scope.getData()
          ,
          ->
            console.log 'dismiss'

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
          templateUrl:'modals/lottery.html'
          controller:'EditLottery'
          backdrop:'static'
          resolve:
            data:->
              return row.entity
        modalInstance.result.then (data)->
          data._csrf = csrf
          $http.post('/lottery/update',data).success (result)->
            if result.err
              humane.error result.err
            else
              humane.log '更新成功'
              console.log result
              $scope.getData()
        ,
          ->
            console.log 'dismiss'
      enable:(row)->
        data = row.entity
        data.enabled = !data.enabled
        console.log data.enabled
        data._csrf = csrf
        $http.post('/lottery/update',data).success (result)->
          if result.err
            humane.error result.err
          else
            humane.log '更新成功'
            console.log result
            $scope.getData()
      style:(row)->
        return if row.entity.enabled then 'btn btn-warn btn-flat btn-sm' else 'btn btn-success btn-flat btn-sm'
      label:(row)->
        return if row.entity.enabled then '禁用' else '启用'

    handler = '<div style="text-align: left"><div class="btn-group" ng-disabled="getExternalScopes().requesting">
            <button ng-click="getExternalScopes().edit(row)" class="btn btn-default btn-flat btn-sm">编辑</button>
            <button ng-click="getExternalScopes().enable(row)" ng-class="getExternalScopes().style(row)">{{ getExternalScopes().label(row) }}</button>
        </div></div>'

    $scope.gridOptions =
      enableSorting: false
      columnDefs:[
        {name:'活动名称', field:'name', enableSorting: false}
        {name:'开始时间', field:'begin', width:100, enableSorting: false}
        {name:'截止时间', field:'end', width:100, enableSorting: false}
        {name:'参与人数', field:'joined', width:100, enableSorting: false}
        {name: '创建时间',field: 'created_at',width: 200, enableSorting: false}
        {name: '操作',field: 'created_at',width: 120, enableSorting: false, cellTemplate:handler}
      ]

    $scope.getData = ->
      if $scope.requesting
        return
      $scope.requesting = true
      $http.get('/lottery/list',params:page:$scope.page,pageSize:$scope.pageSize,keywords:$scope.keywords).success((result)->
        console.group 'lottery'
        console.log 'GotProducts', result
        console.groupEnd()
        $scope.requesting = false
        if result.err
          humane.log result.err
        else
          $scope.count = result.count
          if result.result
            result.result.forEach (r)->
              r.begin = moment(r.begin).format('YYYY-MM-DD HH:mm:ss')
              r.end = moment(r.end).format('YYYY-MM-DD HH:mm:ss')
              r.created_at = moment(r.created_at).format('YYYY-MM-DD HH:mm:ss')
          $scope.gridOptions.data = result.result
      ).error (err)->
        $scope.requesting = false
        if err
          humane.log err

    $scope.getData()

    console.groupEnd()