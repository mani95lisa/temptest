'use strict'

define ['console', 'humane', 'moment'], (console, humane, moment)->
  return ($scope, $http, uiGridConstants, $modal, $interval, $location, collectionService)->

    console.group 'collection'

    $scope.page = 1
    $scope.search = ->
      $scope.page = 1
      $scope.getData()

    $scope.pageSize = 10
    $scope.pages = [10,25,50,100]

    $scope.filters = ['所有','缓存失败','已缓存完毕']
    $scope.filter = {value:'所有'}

    $scope.footer = 'partials/grid/grid_footer.html'
    $scope.header = 'partials/grid/grid_header.html'

    $scope.$watch 'pageSize', (n)->
      if $scope.gridApi
        $('#grid1').height(n * 35)
        $scope.gridApi.grid.refresh()
      $scope.getData()

    $scope.$watch 'page', (n)->
      $scope.getData()

    $scope.$watch 'filter.value', (n)->
      $scope.getData()

    caching = []

    $interval(->
      if $location.path() == '/collection'
        $scope.getData()
    , 60000)

    $scope.requesting = false

    $scope.externalScopes =
      edit:(row)->
        modalInstance = $modal.open
          templateUrl:'modals/edit_collection.html'
          controller:'EditCollection'
          backdrop:'static'
          resolve:
            data:->
              return row.entity
        modalInstance.result.then (data)->
          $http.post('/m/collection/update',data).success (result)->
            if result.err
              humane.error result.err
              $scope.getData()
            else
              humane.log '更新成功'
              console.log result
        ,
          ->
            console.log 'dismiss'
      cache:(row)->
        if $scope.requesting
          return
        $scope.requesting = true
        if caching.indexOf(row.entity) == -1 || row.entity.cache_status == '缓存失败'
          $http.get('/m/cache', params:id:row.entity._id).success((result)->
            if result.err
              humane.log err
            else
              if !result.finished
                row.entity.cache_status = '开始缓存'
                caching.push row.entity
                humane.log '开始缓存'
              else
                humane.log '已缓存成功'
            $scope.requesting = false
          ).error (err)->
            if err
              humane.log err
            $scope.requesting = false
      check:(row)->
        content = JSON.stringify(row.entity)
        collectionService.setCheck row.entity
        $location.path 'collection/check'
      cacheLabel:(row)->
        return '缓存'
      style:(row)->
        return if row.enabled then 'btn btn-warn btn-flat btn-sm' else 'btn btn-success btn-flat btn-sm'
      label:(row)->
        return if row.enabled then '禁用' else '启用'

#        <button ng-if="!row.entity.finished" ng-click="getExternalScopes().cache(row)" class="btn btn-default btn-flat btn-sm">{{ getExternalScopes().cacheLabel(row) }}</button>
    handler = '<div style="text-align: left"><div class="btn-group" ng-disabled="getExternalScopes().requesting">
        <button ng-click="getExternalScopes().edit(row)" class="btn btn-default btn-flat btn-sm">编辑</button>
        <button ng-click="getExternalScopes().cache(row)" class="btn btn-default btn-flat btn-sm">{{ getExternalScopes().cacheLabel(row) }}</button>
        <button ng-click="getExternalScopes().check(row)" class="btn btn-default btn-flat btn-sm">检查</button>
        <button ng-class="getExternalScopes().style(row)">{{ getExternalScopes().label(row) }}</button>
    </div></div>'

    $scope.gridOptions =
      enableSorting: false
      columnDefs:[
        {name:'名称', field:'name' , enableSorting: false}
        {name:'绎者', field:'author_name', width:88 , enableSorting: false}
        {name:'大小', field:'size', width:99 , enableSorting: false}
        {name:'时长', field:'duration', width:99, enableSorting: false}
        {name:'总长', field:'length', width:88, enableSorting: false}
        {name:'已存', field:'cached', width:88, enableSorting: false}
        {name:'状态', field:'cache_status', width:88, enableSorting: false}
        {name: '操作',field: 'created_at',width: 200, enableSorting: false, cellTemplate:handler}
      ]
      onRegisterApi : (gridApi)->
        $scope.gridApi = gridApi

    $scope.getData = ->
      if $scope.requesting
        return
      $scope.requesting = true
      filter = if $scope.filter.value == '所有' then '' else $scope.filter.value
      $http.get('/m/collections',params:page:$scope.page,pageSize:$scope.pageSize,keywords:$scope.keywords,filter:filter).success((result)->
        console.group 'collection'
        console.log 'GotCollections', result
        console.groupEnd()
        $scope.requesting = false
        if result.err
          humane.log result.err
        else
          $scope.count = result.count
          if result.result
            result.result.forEach (r)->
              r.size = bytesToSize(r.size)
              if r.duration
                r.duration = getTime(r.duration)
              r.created_at = moment(r.creatd_at).format('YYYY-MM-DD')
          $scope.gridOptions.data = result.result
      ).error (err)->
        $scope.requesting = false
        if err
          humane.log err

    $scope.getData()

    console.groupEnd()
