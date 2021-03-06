'use strict'

define ['console', 'humane', 'moment'], (console, humane, moment)->
  return ($scope, $http, uiGridConstants, $modal, $interval, $location)->

    console.group 'joined'

    $scope.page = 1
    $scope.search = ->
      $scope.page = 1
      $scope.getData()

    $scope.pageSize = 10
    $scope.pages = [10,25,50,100]

    $scope.footer = 'partials/grid/grid_footer.html'
    $scope.header = 'partials/grid/grid_header.html'
    $scope.filters = ['所有','未中奖', '已中奖', '已派奖']
    $scope.searchTip = '请输入7位抽奖号或11位用户手机号或抽奖活动标题'
#    $http.get('/lottery/name_list').success (result)->
#      if result.err
#        humane.log result.err
#      else
#        defaut = name:'显示所有'
#        result.result.unshift(defaut)
#        $scope.category = value:defaut
#        $scope.categories = result.result

    $scope.filter = {value:'所有'}
    $scope.$watch 'filter.value', (n)->
      $scope.getData()

    $scope.$watch 'pageSize', (n)->
      $scope.getData()

    $scope.$watch 'page', (n)->
      $scope.getData()

    $scope.$watch 'category.value', (n)->
      $scope.getData()

    caching = []

    $scope.requesting = false

    editRow = (row)->
      modalInstance = $modal.open
        templateUrl:'modals/joined.html'
        controller:'EditJoined'
        backdrop:'static'
        resolve:
          data:->
            return row.entity
      modalInstance.result.then (data)->
        data._csrf = csrf
        $http.post('/lottery_records/update',data).success (result)->
          if result.err
            humane.log result.err
          else
            humane.log '更新成功'
            console.log result
            $scope.getData()
      ,
      ->
        console.log 'dismiss'

#    editRow {entity:name:'test',user:nickname:'test'}

    $scope.externalScopes =
      edit:(row)->
        editRow row
      enable:(row)->
        data = row.entity
        data.enabled = !data.enabled
        console.log data.enabled
        data._csrf = csrf
        $http.post('/lottery_records/update',data).success (result)->
          if result.err
            humane.error result.err
          else
            humane.log '更新成功'
            console.log result
            $scope.getData()

    handler = '<div style="text-align: left"><div class="btn-group" ng-disabled="getExternalScopes().requesting">
            <button ng-click="getExternalScopes().edit(row)" class="btn btn-default btn-flat btn-sm">编辑</button>
        </div></div>'

    $scope.gridOptions =
      enableSorting: false
      columnDefs:[
        {name:'用户手机号', field:'mobile', enableSorting: false}
        {name:'用户姓名', field:'truename', enableSorting: false}
        {name:'中奖奖品', field:'lottery', enableSorting: false}
        {name: '邮箱地址',field: 'email', enableSorting: false}
        {name: '日期',field: 'created_at', enableSorting: false}
      ]

    $scope.getData = ->
      if $scope.requesting
        return
      $scope.requesting = true
      console.log $scope.filter, $scope.category
      filter = $scope.filters.indexOf $scope.filter.value
      ca = $scope.category.value if $scope.category
      $http.get('/lottery_records/list',params:category:ca,filter:filter,page:$scope.page,pageSize:$scope.pageSize,keywords:$scope.keywords).success((result)->
        console.group 'lottery_records'
        console.log 'GotLotteryRecords', result
        console.groupEnd()
        $scope.requesting = false
        if result.err
          humane.log result.err
        else
          $scope.count = result.count
          if result.result
            result.result.forEach (r)->
              arr = ['黄金BB正品', '春漾优雅大拎包', '春漾遮阳伞', '春漾闪耀长方巾']
              r.lottery = arr[parseInt(r.lottery)]
              r.created_at = moment(r.created_at).format('MM-DD HH:mm:ss')
          $scope.gridOptions.data = result.result
      ).error (err)->
        $scope.requesting = false
        if err
          humane.log err

    $scope.getData()

    console.groupEnd()