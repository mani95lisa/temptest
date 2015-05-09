'use strict'

define ['console', 'humane', 'moment'], (console, humane, moment)->
  return ($scope, $http, uiGridConstants, $modal, $interval, $location, $timeout, collectionService)->

    console.group 'collection_check'

    $scope.checking = collectionService.getCheck()

    if !$scope.checking
      $timeout(->
        $location.path 'collection'
      , 1000)
    else
      $scope.info = '名称：'+$scope.checking.name
      console.log $scope.checking

      $scope.requesting = false

      player = $("#player")

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
            console.log data
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
                row.entity.cache_status = '开始缓存'
                caching.push row.entity
                humane.log '开始缓存'
              $scope.requesting = false
            ).error (err)->
              if err
                humane.log err
              $scope.requesting = false
        check:(row)->

        cacheLabel:(row)->
          return '缓存'
        style:(row)->
          return 'btn btn-warn btn-flat btn-sm'
        try:(row)->
          url = host+row.entity.content.url
          player.prop("src", url)
          return true

      handler = '<div style="text-align: center"><div class="btn-group" ng-disabled="getExternalScopes().requesting">
          <button ng-click="getExternalScopes().edit(row)" class="btn btn-default btn-flat btn-sm">编辑</button>
          <button ng-click="getExternalScopes().try(row)" class="btn btn-default btn-flat btn-sm">试听</button>
          <button class="btn btn-warning btn-flat btn-sm">移除</button>
      </div></div>'

      $scope.gridOptions2 =
        columnDefs:[
          {name: '序号', field:'index', enableCellEdit: true, type: 'number'}
          {name: '名称', field:'content.name', enableSorting: false}
          {name: '大小', field:'getSize()', enableSorting: false}
          {name: '时长', field:'getTime()', enableSorting: false}
          {name: '操作', width:200, cellTemplate:handler, enableSorting: false}
        ]

      data = $scope.checking
      length = data.length
      url = data.cache_url

      console.log 'contents:',data.contents
      if data.contents
        data.contents.forEach (c)->
          c.getSize = ->
            return bytesToSize(c.content.size)
          c.getTime = ->
            return getTime(c.content.duration)

      console.log 'set contents2'
      $scope.gridOptions2.data = data.contents
      $scope.$apply()

      $scope.back = ->
        $location.path 'collection'

      $scope.save = ->


  #    $scope.getData = ->
  #      $http.get('/m/collections',params:page:$scope.page).success((result)->
  #        console.log 'GotCollections', result
  #        if result.err
  #          humane.log result.err
  #        else
  #          $scope.count = result.count
  #          if result.result
  #            result.result.forEach (r)->
  #              r.created_at = moment(r.creatd_at).format('YYYY-MM-DD')
  #          $scope.gridOptions.data = result.result
  #      ).error (err)->
  #        if err
  #          humane.log err

  #    $scope.getData()

      console.groupEnd()
