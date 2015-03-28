'use strict'

define ['angular', 'console'], (angular, console)->

  angular.module('admin', ['ipCookie'])
  .controller('Dashboard', ($scope, $injector)->
    require ['controllers/dashboard'], (controller)->
      $injector.invoke controller, this, '$scope':$scope
  ).controller('User', ($scope, $injector)->
    require ['controllers/user'], (controller)->
      $injector.invoke controller, this, '$scope':$scope
  ).controller('Setting', ($scope, $injector)->
    require ['controllers/setting'], (controller)->
      $injector.invoke controller, this, '$scope':$scope
  ).controller('Lottery', ($scope, $injector)->
    require ['controllers/lottery'], (controller)->
      $injector.invoke controller, this, '$scope':$scope
  ).controller('EditLottery', ($scope, $injector, data, $modalInstance)->
    require ['controllers/edit_lottery'], (controller)->
      $injector.invoke controller, this, {'$scope':$scope,'data':data,'$modalInstance':$modalInstance}
  ).controller('Joined', ($scope, $injector)->
    require ['controllers/joined'], (controller)->
      $injector.invoke controller, this, '$scope':$scope
  ).controller('EditJoined', ($scope, $injector, data, $modalInstance)->
    require ['controllers/edit_joined'], (controller)->
      $injector.invoke controller, this, {'$scope':$scope,'data':data,'$modalInstance':$modalInstance}
  ).controller('EditUser', ($scope, $injector, data, $modalInstance)->
    require ['controllers/edit_user'], (controller)->
      $injector.invoke controller, this, {'$scope':$scope,'data':data,'$modalInstance':$modalInstance}
  ).controller('Navigator', ($scope, $location)->
    $scope.getStatus = (path)->
      if $location.path().indexOf('/'+path) != -1
        return 'active'
      else
        return ''
  )
