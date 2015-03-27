'use strict'

define ['console', 'humane', 'moment'], (console, humane, moment)->
  return ($scope, $http, data, $modalInstance)->

    console.group 'edit_lottery'

    console.log data
    $scope.data = angular.copy data
    $scope.title = if data then '编辑 '+ data.name else '新增抽奖活动'

    $scope.ok = ->
      data = $scope.data

      if !data.name || !data.begin || !data.end
        humane.log '活动名称、起止时间、链接地址、分享描述均不能为空'
      else
        right = true
        begin = moment(data.begin, 'YYYY-MM-DD HH:mm:ss').isValid()
        console.log begin, data.begin
        end = moment(data.end, 'YYYY-MM-DD HH:mm:ss').isValid()
        if !begin || !end
          humane.log '时间格式不对，需要是 2015-01-01 14:00:00 这样的'
        else
          $modalInstance.close(data)

    $scope.$watch 'channel', ->
      if data._id
        $scope.link_url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx1f9fe13fd3655a8d&redirect_uri=http://rsct.swift.tf/init_auto&state=c_|_'+$scope.channel+';;p_|_lottery;;id_|_'+data._id+'&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect'


    $scope.channel = 'weixin'
    $scope.$apply()

    $scope.cancel = ->
      $modalInstance.dismiss 'cancel'


    console.groupEnd()