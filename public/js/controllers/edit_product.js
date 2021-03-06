// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  define(['console', 'humane', 'moment'], function(console, humane, moment) {
    return function($scope, $http, data, $modalInstance) {
      console.group('edit_product');
      console.log(data);
      $scope.data = angular.copy(data);
      $scope.title = data ? '编辑 ' + data.name : '新增产品';
      $scope.$apply();
      $scope.ok = function() {
        var arr, prices, right;
        data = $scope.data;
        if (!data.name || !data.category || !data.price) {
          return humane.log('所有项目不能为空');
        } else {
          arr = data.price.split(' ');
          right = true;
          prices = [];
          arr.forEach(function(price) {
            var arr2;
            arr2 = price.split('=');
            if (arr2.length !== 2) {
              return right = false;
            } else {
              return prices.push({
                label: arr2[0],
                value: arr2[1]
              });
            }
          });
          if (!right) {
            return humane.log('价格格式不正确，应该是 价格标签=价格 的格式，多个以空格隔开');
          } else {
            data.prices = prices;
            return $modalInstance.close(data);
          }
        }
      };
      $scope.cancel = function() {
        return $modalInstance.dismiss('cancel');
      };
      return console.groupEnd();
    };
  });

}).call(this);
