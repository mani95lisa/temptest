'use strict'

define ['angular'], (angular)->

  angular.module('collection.service', []).service 'collectionService', ->
    console.group 'collection service'
    console.log 'inited'
    console.groupEnd()
    checking = null
    return {
      setCheck : (data)->
        console.group 'collection service'
        console.log data
        console.groupEnd()
        checking = data
      getCheck : ->
        return checking
    }