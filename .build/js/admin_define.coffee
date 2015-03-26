'use strict';

define [
  'angular'
  'controllers/admin'
  'controllers/error'
  'angular-route'
  'angular-ui-grid'
  'angular-bootstrap'
  'global'
  'services/collection_service'
  'ng-tags-input'
], (angular)->

  app = angular.module 'MainApp', ['ngRoute', 'ui.grid', 'ui.bootstrap', 'ipCookie', 'admin', 'collection.service', 'ngTagsInput']
  app.init = ->
    angular.bootstrap document, ['MainApp']

  return app