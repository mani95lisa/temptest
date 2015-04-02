// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  define(['console', 'humane', 'moment'], function(console, humane, moment) {
    return function($scope, $http, uiGridConstants, $modal, $interval, $location) {
      var caching, editRow, handler;
      console.group('joined');
      $scope.page = 1;
      $scope.search = function() {
        $scope.page = 1;
        return $scope.getData();
      };
      $scope.pageSize = 10;
      $scope.pages = [10, 25, 50, 100];
      $scope.footer = 'partials/grid/grid_footer.html';
      $scope.header = 'partials/grid/grid_header.html';
      $scope.filters = ['所有', '未中奖', '已中奖', '已派奖'];
      $scope.filter = {
        value: '所有'
      };
      $scope.$watch('filter.value', function(n) {
        return $scope.getData();
      });
      $scope.$watch('pageSize', function(n) {
        return $scope.getData();
      });
      $scope.$watch('page', function(n) {
        return $scope.getData();
      });
      caching = [];
      $scope.requesting = false;
      editRow = function(row) {
        var modalInstance;
        modalInstance = $modal.open({
          templateUrl: 'modals/joined.html',
          controller: 'EditJoined',
          backdrop: 'static',
          resolve: {
            data: function() {
              return row.entity;
            }
          }
        });
        return modalInstance.result.then(function(data) {
          data._csrf = csrf;
          return $http.post('/lottery_records/update', data).success(function(result) {
            if (result.err) {
              return humane.error(result.err);
            } else {
              humane.log('更新成功');
              console.log(result);
              return $scope.getData();
            }
          });
        }, function() {
          return console.log('dismiss');
        });
      };
      $scope.externalScopes = {
        edit: function(row) {
          return editRow(row);
        },
        enable: function(row) {
          var data;
          data = row.entity;
          data.enabled = !data.enabled;
          console.log(data.enabled);
          data._csrf = csrf;
          return $http.post('/lottery_records/update', data).success(function(result) {
            if (result.err) {
              return humane.error(result.err);
            } else {
              humane.log('更新成功');
              console.log(result);
              return $scope.getData();
            }
          });
        }
      };
      handler = '<div style="text-align: left"><div class="btn-group" ng-disabled="getExternalScopes().requesting"> <button ng-click="getExternalScopes().edit(row)" class="btn btn-default btn-flat btn-sm">编辑</button> </div></div>';
      $scope.gridOptions = {
        enableSorting: false,
        columnDefs: [
          {
            name: '活动名称',
            field: 'lottery.name',
            enableSorting: false
          }, {
            name: '用户手机号',
            field: 'user.mobile',
            width: 100,
            enableSorting: false
          }, {
            name: '用户昵称',
            field: 'user.nickname',
            width: 100,
            enableSorting: false
          }, {
            name: '抽奖号',
            field: 'number',
            width: 100,
            enableSorting: false
          }, {
            name: '是否中奖',
            field: 'status',
            width: 100,
            enableSorting: false
          }, {
            name: '是否派奖',
            field: 'dispatched',
            width: 100,
            enableSorting: false
          }, {
            name: '操作',
            field: 'created_at',
            width: 120,
            enableSorting: false,
            cellTemplate: handler
          }
        ]
      };
      $scope.getData = function() {
        var filter;
        if ($scope.requesting) {
          return;
        }
        $scope.requesting = true;
        console.log($scope.filter);
        filter = $scope.filters.indexOf($scope.filter.value);
        return $http.get('/lottery_records/list', {
          params: {
            filter: filter,
            page: $scope.page,
            pageSize: $scope.pageSize,
            keywords: $scope.keywords
          }
        }).success(function(result) {
          console.group('lottery_records');
          console.log('GotLotteryRecords', result);
          console.groupEnd();
          $scope.requesting = false;
          if (result.err) {
            return humane.log(result.err);
          } else {
            $scope.count = result.count;
            if (result.result) {
              result.result.forEach(function(r) {
                return r.created_at = moment(r.created_at).format('YYYY-MM-DD HH:mm:ss');
              });
            }
            return $scope.gridOptions.data = result.result;
          }
        }).error(function(err) {
          $scope.requesting = false;
          if (err) {
            return humane.log(err);
          }
        });
      };
      $scope.getData();
      return console.groupEnd();
    };
  });

}).call(this);
