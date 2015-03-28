// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  define(['console', 'humane', 'moment'], function(console, humane, moment) {
    return function($scope, $http, data, $modalInstance) {
      console.group('edit_joined');
      console.log(data);
      $scope.data = angular.copy(data);
      $scope.title = data ? '编辑用户 ' + data.user.nickname + ' 抽奖号' : void 0;
      $scope.ok = function() {
        data = $scope.data;
        switch ($scope.radioModel) {
          case '1':
            data.status = false;
            break;
          case '2':
            data.status = true;
            break;
          default:
            data.dispatched = true;
        }
        return $modalInstance.close(data);
      };
      if (data.dispatched) {
        $scope.radioModel = '3';
      } else if (data.status) {
        $scope.radioModel = '2';
      } else {
        $scope.radioModel = '1';
      }
      $scope.$apply();
      $scope.cancel = function() {
        return $modalInstance.dismiss('cancel');
      };
      return console.groupEnd();
    };
  });

}).call(this);
