var dependencies;angular.module("redditelly.services",[]),angular.module("redditelly.filters",[]),angular.module("redditelly.directives",[]),dependencies=["redditelly.services","redditelly.filters","redditelly.directives","ui.router","youtube"],angular.module("redditelly",dependencies).config(["$stateProvider","$urlRouterProvider",function(e,r){return e.state("subreddit",{url:"/r/:r?v",templateUrl:"views/subreddit.html",controller:"SubredditCtrl"}),r.otherwise("/r/videos")}]).run(["$rootScope",function(e){return e.$on("$stateChangeSuccess",function(r,t,d){var l;return e.currentSubreddit=d.r,l="redditelly",d.r&&(l+=" | r/"+d.r),e.pageTitle=l})}]);
angular.module("redditelly").controller("RedditellyCtrl",["$scope","$state",function(e,t){return e.pickingSubreddit=!1,e.categories=[{name:"general",list:["videos","youtubehaiku","video","youtube"]},{name:"music",list:["listentothis","amv"]},{name:"film & tv",list:["fullmoviesonyoutube","television"]},{name:"sports",list:["sports","nba"]},{name:"games",list:["gaming"]}],e.goTo=function(i){return e.pickingSubreddit=!1,t.go("subreddit",{r:i})}}]);
angular.module("redditelly").controller("SubredditCtrl",["$scope","$stateParams","$state","$reddit","$youtube",function(t,e,n,r,o){var u,d,i,l;return i=null!=e.v,t.posts=null,t.currentPost=null,l=function(e){return"youtube.com"===e.domain&&e.subreddit===t.currentSubreddit},i&&(d=function(){var e;return i=!1,(null!=(e=t.posts)?e.length:void 0)?t.nextVideo():void 0},r.getPostById(e.v).then(function(e){return l(e)?t.currentPost=e:d()},d)),r.get(e.r).then(function(e){return console.log("POSTS",e),t.posts=e.filter(l),i?void 0:t.nextVideo()}),u=function(){return t.posts.shift()},t.nextVideo=function(){return t.currentPost=u(),t.$broadcast("redditelly.post.change")},t.selectPost=function(e){var n,r;for(r=[];(null!=(n=t.currentPost)?n.id:void 0)!==e;)r.push(t.nextVideo());return r},t.$on("youtube.player.ended",function(){return t.nextVideo()}),t.$on("youtube.player.ready",function(){return o.player.playVideo()}),t.$on("redditelly.post.change",function(){return n.go("subreddit",{r:e.r,v:t.currentPost.id},{location:!0,reload:!1,notify:!1})})}]);
angular.module("redditelly.directives").directive("clickToExpand",[function(){return{link:function(n,r,e){var l,o,c;return r.addClass("click-to-expand"),l=null,o=function(n){var e;return l=n,e=n?"addClass":"removeClass",r[e]("collapsed")},c=function(){return o(!l)},o(!0),r.on("click",function(){return n.$apply(c)}),n.$on("$destroy",function(){return r.off("click")}),e.collapseOn?n.$on(e.collapseOn,function(){return l?void 0:o(!0)}):void 0}}}]);
angular.module("redditelly.directives").directive("screenHeight",["$window",function(e){return{link:function(i,n,t){var r,c,d;return d=t.heightOffset||"0",c=parseInt(d,10),r=e.innerHeight-c,n.css("max-height",""+r+"px")}}}]);
angular.module("redditelly.filters").filter("timeago",function(){return function(t){var a,n,r,e,o,u,d,i,g;return a=1e3*t,u=(new Date).getTime(),n=u-a,i=Math.abs(n)/1e3,45>i?"just now":(d=function(t){return Math.round(t)>1?"s":""},o=i/60,45>o?""+Math.round(o)+" minute"+d(o)+" ago":(e=o/60,24>e?""+Math.round(e)+" hour"+d(e)+" ago":(r=e/24,365>r?""+Math.round(r)+" day"+d(r)+" ago":(g=r/365,""+Math.round(g)+" year"+d(g)+" ago"))))}});
angular.module("redditelly.filters").filter("getVideoIDfromURL",[function(){var e,t;return t=/https?:\/\/(?:[0-9A-Z-]+\.)?(?:youtu\.be\/|youtube(?:-nocookie)?\.com\S*[^\w\s-])([\w-]{11})(?=[^\w-]|$)(?![?=&+%\w.-]*(?:['"][^<>]*>|<\/a>))[?=&+%\w.-]*/gi,e=function(e,t){return e.indexOf(t)>-1},function(o){var n,r,u;return null==o&&(o=""),n=o.replace(t,"$1"),e(n,";")?(r=n.split(";"),e(r[1],"%")?(u=decodeURIComponent(n.split(";")[1]),n=("http://youtube.com"+u).replace(t,"$1")):n=r[0]):e(n,"#")&&(n=n.split("#")[0]),n}}]);
angular.module("redditelly.filters").filter("idToThumbnail",[function(){return function(t,u){return null==u&&(u="default"),"http://img.youtube.com/vi/"+t+"/"+u+".jpg"}}]);
angular.module("redditelly.services").service("$reddit",["$http",function(t){var n,r,e;return n="http://www.reddit.com",e=function(t){return""+n+"/r/"+t+"/.json"},r=function(t){return""+n+"/by_id/t3_"+t+"/.json"},{get:function(n){return t.get(e(n)).then(function(t){return _.map(t.data.data.children,function(t){return t.data})})},getPostById:function(n){return t.get(r(n)).then(function(t){var n;return null!=(n=t.data.data.children[0])?n.data:void 0},function(t){throw t.data})}}}]);