'use strict'

define ['angular', 'admin_define'], (angular, app)->

  return app.config ['$routeProvider', ($routeProvider)->

    $routeProvider.when '/joined', templateUrl:'partials/joined.html',controller:'Joined'

    $routeProvider.otherwise redirectTo:'/joined'
  ]