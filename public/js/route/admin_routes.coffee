'use strict'

define ['angular', 'admin_define'], (angular, app)->

  return app.config ['$routeProvider', ($routeProvider)->

    $routeProvider.when '/dashboard', templateUrl:'partials/dashboard.html',controller:'Dashboard'
    $routeProvider.when '/user', templateUrl:'partials/user.html',controller:'User'
    $routeProvider.when '/product', templateUrl:'partials/product.html',controller:'Product'
    $routeProvider.when '/order', templateUrl:'partials/order.html',controller:'Order'
    $routeProvider.when '/setting', templateUrl:'partials/setting.html',controller:'Setting'
    $routeProvider.when '/promotion', templateUrl:'partials/promotion.html',controller:'Promotion'

    $routeProvider.otherwise redirectTo:'/dashboard'
  ]