// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  define(['console', 'humane', 'moment'], function(console, humane, moment) {
    return function($scope, $http, $q, $filter, uiGridConstants, $modal, $interval, $location) {
      var getTags, updateResult, updateTags;
      console.group('setting');
      getTags = function(key, callback, subKey, valuePro) {
        getDict($http, key, function(result) {
          console.log(result);
          if (subKey) {
            if (result && valuePro) {
              $scope[subKey][key] = result[valuePro];
            } else {
              $scope[subKey][key] = result;
            }
          } else {
            $scope[key] = result;
          }
          if (result && callback) {
            return callback(result);
          }
        });
      };
      updateTags = function(key, list, callback, isPro) {
        var arr, data;
        if (isPro) {
          data = {
            key: key,
            list: list
          };
        } else {
          data = list;
        }
        data.key = key;
        arr = [];
        data.list.forEach(function(text) {
          return arr.push(text.text);
        });
        data.list = arr;
        $scope.handling = true;
        console.log(data);
        $http.post('/dict/update/list', data).success(function(result) {
          $scope.handling = false;
          if (!result.err) {
            return callback(true);
          } else {
            return humane.log(result.err);
          }
        });
      };
      $scope.update = function(key) {
        var data;
        data = {};
        data.key = key;
        data.value = $scope[key].value;
        data._csrf = csrf;
        $http.post('/dict/update/list', data).success(function(result) {
          $scope.handling = false;
          if (!result.err) {
            return humane.log('更新成功');
          } else {
            return humane.log(result.err);
          }
        });
      };
      updateResult = function(result) {
        if (result.err) {
          return humane.log(result.err);
        }
      };
      $scope.tagAdded = function(key) {
        return updateTags(key, $scope[key], updateResult);
      };
      $scope.tagRemoved = function(key) {
        return updateTags(key, $scope[key], updateResult);
      };
      getTags('LotteryRatio');
      getTags('LotteryLimit');
      $scope.Pros = {};
      $scope.proRemoved = function(key) {
        return updateTags(key, $scope.Pros[key], updateResult, true);
      };
      $scope.proAdded = function(key) {
        return updateTags(key, $scope.Pros[key], updateResult, true);
      };
      getTags('Areas', function(result) {
        var pro, _i, _len, _ref, _results;
        if (result && result.list && result.list.length) {
          _ref = result.list;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            pro = _ref[_i];
            _results.push((function(pro) {
              return getTags(pro, null, 'Pros', 'list');
            })(pro));
          }
          return _results;
        }
      });
      $scope.loadTags = function(query) {
        var deffered;
        deffered = $q.defer();
        deffered.resolve($filter('filter')($scope.Building.list, query));
        return deffered.promise;
      };
      return console.groupEnd();
    };
  });

}).call(this);
