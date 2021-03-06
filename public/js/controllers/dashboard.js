// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  define(['console', 'humane'], function(console, humane) {
    return function($scope, $http) {
      console.group('dashboard');
      $http.get('/m/count').success(function(result) {
        console.log('GotCount', result);
        if (result.err) {
          return humane.log(result.err);
        } else {
          return $scope.count = result;
        }
      }).error(function(err) {
        return console.err(err);
      });
      return console.groupEnd();
    };
  });

}).call(this);
