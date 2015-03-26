'use strict'

requirejs.config
  paths:
    'console':'../components/console/console.min'
    'angular':'../components/angular/angular'
    'humane':'../components/humane/humane'
    'jquery':'../components/jquery/dist/jquery.min'
    'bootstrap':'../components/bootstrap/dist/js/bootstrap.min'
    'angular-cookie':'../components/angular-cookie/angular-cookie.min'
  shim:
    "angular":exports:"angular"
    'angular-cookie':deps:['angular']
    'jquery':['angular']
  priority: [
    'console',
    'jquery',
    'angular',
    'angular-cookie'
  ]
  urlArgs: 'v=2.0'

require ['require', 'console', 'jquery', 'angular' , 'angular-cookie'], (require, console, jquery)->

  console.group 'startup'

  require ['login_define'], (app)->
    app.init()
    console.groupEnd()