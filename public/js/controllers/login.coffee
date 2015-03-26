'use strict'

define ['angular', 'humane', 'console'], (angular, humane, console)->

  angular.module('login', ['ipCookie'])
  .controller('MainCtl', ($scope, $http, ipCookie)->

    console.group 'login controller'

    if ipCookie 'username' 
      $scope.username = ipCookie 'username'
      $scope.password = ipCookie 'password'
      $scope.remember_me = ipCookie 'remember_me'
      console.log $scope.password

    $scope.rememberChanged = ->
      if $scope.remember_me
        ipCookie 'username', $scope.username
        ipCookie 'password', $scope.password
        ipCookie 'remember_me', $scope.remember_me
      else
        ipCookie.remove 'username'
        ipCookie.remove 'password'
        ipCookie.remove 'remember_me'

    $scope.signIn = ->
      ipCookie.remove 'username'
      ipCookie.remove 'password'
      ipCookie.remove 'remember_me'
      ipCookie 'username', $scope.username
      ipCookie 'password', $scope.password
      ipCookie 'remember_me', $scope.remember_me

    console.groupEnd()
  )