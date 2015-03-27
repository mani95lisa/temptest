// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  define(['angular', 'admin_define'], function(angular, app) {
    return app.config([
      '$routeProvider', function($routeProvider) {
        $routeProvider.when('/dashboard', {
          templateUrl: 'partials/dashboard.html',
          controller: 'Dashboard'
        });
        $routeProvider.when('/user', {
          templateUrl: 'partials/user.html',
          controller: 'User'
        });
        $routeProvider.when('/lottery', {
          templateUrl: 'partials/lottery.html',
          controller: 'Lottery'
        });
        $routeProvider.when('/setting', {
          templateUrl: 'partials/setting.html',
          controller: 'Setting'
        });
        return $routeProvider.otherwise({
          redirectTo: '/dashboard'
        });
      }
    ]);
  });

}).call(this);
