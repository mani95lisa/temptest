// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  requirejs.config({
    paths: {
      'console': '../components/console/console.min',
      'angular': '../components/angular/angular',
      'angular-route': '../components/angular-route/angular-route.min',
      'humane': '../components/humane/humane.min',
      'jquery': '../components/jquery/dist/jquery.min',
      'bootstrap': '../components/bootstrap/dist/js/bootstrap.min',
      'angular-cookie': '../components/angular-cookie/angular-cookie.min',
      'angular-ui-grid': '../components/angular-ui-grid/ui-grid-stable',
      'moment': '../components/moment/min/moment.min',
      'angular-bootstrap': '../components/angular-bootstrap/ui-bootstrap-tpls.min',
      'ng-tags-input': '../components/ng-tags-input/ng-tags-input.min'
    },
    shim: {
      'angular': {
        exports: 'angular'
      },
      'angular-cookie': ['angular'],
      'angular-route': ['angular'],
      'angular-ui-grid': ['angular'],
      'angular-bootstrap': ['angular'],
      'jquery': ['angular'],
      'ng-tags-input': ['angular']
    },
    priority: ['console', 'jquery', 'angular', 'angular-cookie'],
    urlArgs: 'v=1.0'
  });

  require(['require', 'console', 'jquery', 'angular', 'angular-cookie'], function(require, console, jquery) {
    console.group('startup');
    console.info('console', console);
    console.info('jquery', jquery);
    console.info('angular', angular);
    return require(['admin_define', 'route/admin_routes'], function(app) {
      console.info('start');
      console.info('app', app);
      app.init();
      return console.groupEnd();
    });
  });

}).call(this);
