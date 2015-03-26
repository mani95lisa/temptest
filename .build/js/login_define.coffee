'use strict';

define ['angular', 'controllers/login', 'controllers/error'], (angular)->

  app = angular.module 'MainApp', ['login', 'ipCookie']
  app.init = ->
    angular.bootstrap document, ['MainApp']

  return app