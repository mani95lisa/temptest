// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  define(['console', 'humane', 'moment'], function(console, humane, moment) {
    return function($scope, $http, data, $modalInstance) {
      console.group('edit_collection');
      console.log(data);
      $scope.data = angular.copy(data);
      $scope.title = '编辑 ' + data.name;
      if (data.cover.indexOf('http://') === -1) {
        $scope.data.cover = host + data.cover;
      }
      $scope.$apply();
      $scope.ok = function() {
        return $modalInstance.close($scope.data);
      };
      $scope.cancel = function() {
        return $modalInstance.dismiss('cancel');
      };
      return console.groupEnd();
    };
  });

}).call(this);
