(function(){"use strict";define(["angular","console"],function(e,t){return e.module("admin",["ipCookie"]).controller("Dashboard",function(e,t){return require(["controllers/dashboard"],function(n){return t.invoke(n,this,{$scope:e})})}).controller("User",function(e,t){return require(["controllers/user"],function(n){return t.invoke(n,this,{$scope:e})})}).controller("Setting",function(e,t){return require(["controllers/setting"],function(n){return t.invoke(n,this,{$scope:e})})}).controller("Lottery",function(e,t){return require(["controllers/lottery"],function(n){return t.invoke(n,this,{$scope:e})})}).controller("EditLottery",function(e,t,n,r){return require(["controllers/edit_lottery"],function(i){return t.invoke(i,this,{$scope:e,data:n,$modalInstance:r})})}).controller("Joined",function(e,t){return require(["controllers/joined"],function(n){return t.invoke(n,this,{$scope:e})})}).controller("EditJoined",function(e,t,n,r){return require(["controllers/edit_joined"],function(i){return t.invoke(i,this,{$scope:e,data:n,$modalInstance:r})})}).controller("SMS",function(e,t){return require(["controllers/sms"],function(n){return t.invoke(n,this,{$scope:e})})}).controller("EditUser",function(e,t,n,r){return require(["controllers/edit_user"],function(i){return t.invoke(i,this,{$scope:e,data:n,$modalInstance:r})})}).controller("Navigator",function(e,t){return e.getStatus=function(e){return t.path().indexOf("/"+e)!==-1?"active":""}})})}).call(this);