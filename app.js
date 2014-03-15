var dependencies;angular.module("redditelly.services",[]),angular.module("redditelly.filters",[]),angular.module("redditelly.directives",[]),dependencies=["redditelly.services","redditelly.filters","redditelly.directives","ui.router","youtube"],angular.module("redditelly",dependencies).config(["$stateProvider","$urlRouterProvider",function(e,r){return e.state("app",{url:"/",templateUrl:"views/app.html",controller:"AppCtrl"}).state("subreddit",{url:"/r/:r",templateUrl:"views/subreddit.html",controller:"SubredditCtrl"}),r.otherwise("/")}]).run(["$rootScope",function(e){return e.$on("$stateChangeSuccess",function(r,t,l){return e.currentSubreddit=l.r,e.pageTitle=l.r||"redditelly"})}]);
angular.module("redditelly").controller("AppCtrl",["$scope",function(e){return e.subreddits=["videos","youtubehaiku","deepintoyoutube","music","listentothis"]}]);
angular.module("redditelly").controller("SubredditCtrl",["$scope","$stateParams","$reddit","$youtube",function(t,e,n,r){var u;return t.posts=null,t.currentPost=null,n.get(e.r).then(function(e){return console.log("POSTS",e),t.posts=e.filter(function(t){return"youtube.com"===t.domain}),t.setNext()}),u=function(){return t.posts.shift()},t.setNext=function(){return t.currentPost=u()},t.$on("youtube.player.ended",function(){return t.setNext()}),t.$on("youtube.player.ready",function(){return r.player.playVideo()})}]);
angular.module("redditelly.filters").filter("getVideoIDfromURL",[function(){return function(l){var t,r,e,i,n,u,f,o,s;for(null==l&&(l=""),u=l.split("?")[1]||"",e=u.split("&"),n={},o=0,s=e.length;s>o;o++)r=e[o],t=r.split("="),n[t[0]]=t[1];return f=n.v||"",i=f.split("#"),i[0]}}]);
angular.module("redditelly.filters").filter("idToThumbnail",[function(){return function(t,u){return null==u&&(u="default"),"http://img.youtube.com/vi/"+t+"/"+u+".jpg"}}]);
angular.module("redditelly.services").service("$reddit",["$http",function(t){var n;return n=function(t){return"http://www.reddit.com/r/"+t+"/.json"},{get:function(r){return t.get(n(r)).then(function(t){return _.map(t.data.data.children,function(t){return t.data})})}}}]);