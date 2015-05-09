'use strict'

define ['humane', 'console'], (humane, console)->
  err = $('#err').text()
  if err
    console.error err
    humane.log err