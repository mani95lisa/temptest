// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  define(['console', 'humane', 'moment'], function(console, humane, moment) {
    return function($scope, $http, uiGridConstants, $modal, $interval, $location, $timeout, collectionService) {
      var data, handler, length, player, url;
      console.group('collection_check');
      $scope.checking = collectionService.getCheck();
      if (!$scope.checking) {
        return $timeout(function() {
          return $location.path('collection');
        }, 1000);
      } else {
        $scope.info = '名称：' + $scope.checking.name;
        console.log($scope.checking);
        $scope.requesting = false;
        player = $("#player");
        $scope.externalScopes = {
          edit: function(row) {
            var modalInstance;
            modalInstance = $modal.open({
              templateUrl: 'modals/edit_collection.html',
              controller: 'EditCollection',
              backdrop: 'static',
              resolve: {
                data: function() {
                  return row.entity;
                }
              }
            });
            return modalInstance.result.then(function(data) {
              return console.log(data);
            }, function() {
              return console.log('dismiss');
            });
          },
          cache: function(row) {
            if ($scope.requesting) {
              return;
            }
            $scope.requesting = true;
            if (caching.indexOf(row.entity) === -1 || row.entity.cache_status === '缓存失败') {
              return $http.get('/m/cache', {
                params: {
                  id: row.entity._id
                }
              }).success(function(result) {
                if (result.err) {
                  humane.log(err);
                } else {
                  row.entity.cache_status = '开始缓存';
                  caching.push(row.entity);
                  humane.log('开始缓存');
                }
                return $scope.requesting = false;
              }).error(function(err) {
                if (err) {
                  humane.log(err);
                }
                return $scope.requesting = false;
              });
            }
          },
          check: function(row) {},
          cacheLabel: function(row) {
            return '缓存';
          },
          style: function(row) {
            return 'btn btn-warn btn-flat btn-sm';
          },
          "try": function(row) {
            var url;
            url = host + row.entity.content.url;
            player.prop("src", url);
            return true;
          }
        };
        handler = '<div style="text-align: center"><div class="btn-group" ng-disabled="getExternalScopes().requesting"> <button ng-click="getExternalScopes().edit(row)" class="btn btn-default btn-flat btn-sm">编辑</button> <button ng-click="getExternalScopes().try(row)" class="btn btn-default btn-flat btn-sm">试听</button> <button class="btn btn-warning btn-flat btn-sm">移除</button> </div></div>';
        $scope.gridOptions2 = {
          columnDefs: [
            {
              name: '序号',
              field: 'index',
              enableCellEdit: true,
              type: 'number'
            }, {
              name: '名称',
              field: 'content.name',
              enableSorting: false
            }, {
              name: '大小',
              field: 'getSize()',
              enableSorting: false
            }, {
              name: '时长',
              field: 'getTime()',
              enableSorting: false
            }, {
              name: '操作',
              width: 200,
              cellTemplate: handler,
              enableSorting: false
            }
          ]
        };
        data = $scope.checking;
        length = data.length;
        url = data.cache_url;
        console.log('contents:', data.contents);
        if (data.contents) {
          data.contents.forEach(function(c) {
            c.getSize = function() {
              return bytesToSize(c.content.size);
            };
            return c.getTime = function() {
              return getTime(c.content.duration);
            };
          });
        }
        console.log('set contents2');
        $scope.gridOptions2.data = data.contents;
        $scope.$apply();
        $scope.back = function() {
          return $location.path('collection');
        };
        $scope.save = function() {};
        return console.groupEnd();
      }
    };
  });

}).call(this);
