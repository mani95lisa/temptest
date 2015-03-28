'use strict'

define ['angular', 'admin_define'], (angular, app)->

  return app.config ['$routeProvider', ($routeProvider)->

    $routeProvider.when '/dashboard', templateUrl:'partials/dashboard.html',controller:'Dashboard'
    $routeProvider.when '/user', templateUrl:'partials/user.html',controller:'User'
    $routeProvider.when '/lottery', templateUrl:'partials/lottery.html',controller:'Lottery'
    $routeProvider.when '/joined', templateUrl:'partials/joined.html',controller:'Joined'
    $routeProvider.when '/setting', templateUrl:'partials/setting.html',controller:'Setting'

    $routeProvider.otherwise redirectTo:'/dashboard'
  ]