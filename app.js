var dependencies;angular.module("redditelly.services",[]),angular.module("redditelly.filters",[]),angular.module("redditelly.directives",[]),dependencies=["redditelly.services","redditelly.filters","redditelly.directives","ui.router","ui.keypress","youtube"],angular.module("redditelly",dependencies).config(["$stateProvider","$urlRouterProvider",function(e,r){return e.state("subreddit",{url:"/r/:r?v",templateUrl:"views/subreddit.html",controller:"SubredditCtrl"}),r.otherwise("/r/videos")}]).run(["$rootScope",function(e){return e.$on("$stateChangeSuccess",function(r,t,d){var i;return e.currentSubreddit=d.r,i="redditelly",d.r&&(i+=" | r/"+d.r),e.pageTitle=i})}]);
angular.module("redditelly").controller("RedditellyCtrl",["$scope","$state",function(e,i){return e.pickingSubreddit=!1,e.categories=[{name:"general",list:["videos","youtubehaiku","video","youtube","kidsafevideos"]},{name:"music",list:["music","listentothis","hiphopheads","amv","classicalmusic","under10k"]},{name:"film & tv",list:["documentaries","fullmoviesonyoutube","movietrailers","trailers","television","standupcomedy"]},{name:"sports",list:["sports","nba"]},{name:"cats",list:["catvideos","catpranks"]},{name:"games",list:["gaming","games"]},{name:"learn",list:["lectures","interview"]}],e.goTo=function(t){return e.pickingSubreddit=!1,i.go("subreddit",{r:t})}}]);
var __indexOf=[].indexOf||function(t){for(var e=0,n=this.length;n>e;e++)if(e in this&&this[e]===t)return e;return-1};angular.module("redditelly").controller("SubredditCtrl",["$scope","$stateParams","$state","$reddit","$youtube",function(t,e,n,o,r){var u,s,i,l,d,a,c,P,p;return d=null!=e.v,t.posts=[],t.currentPost=null,t.previousPost=null,t.history=[],t.lastPostId=null,t.noMorePosts=null,t.loadingPosts=!1,P=["youtube.com","youtu.be"],p=function(e){var n;return n=e.domain,__indexOf.call(P,n)>=0&&e.subreddit.toLowerCase()===t.currentSubreddit},u=function(){return t.posts.length<8&&!t.noMorePosts?t.getMorePosts():void 0},c=function(e){var n;return null==e&&(e=[]),t.lastPostId=(null!=e?e.length:void 0)?e[e.length-1].id:null,n=e.filter(p),t.posts=t.posts.concat(n),t.noMorePosts=n.length<1,u()},d&&(l=function(){var e;return d=!1,(null!=(e=t.posts)?e.length:void 0)?t.nextVideo():void 0},o.getPostById(e.v).then(function(e){return p(e)?t.currentPost=e:l()},l)),t.loadingPosts=!0,o.get(e.r).then(function(e){return t.loadingPosts=!1,c(e),d?void 0:t.nextVideo()}),t.getMorePosts=function(){return t.noMorePosts?void 0:(t.loadingPosts=!0,o.getAfter(e.r,t.lastPostId).then(function(e){return t.loadingPosts=!1,c(e)}))},s=function(){return t.previousPost&&t.history.push(t.previousPost),t.currentPost&&(t.previousPost=t.currentPost),t.posts.shift()},i=function(){var e;return t.currentPost&&t.posts.unshift(t.currentPost),e=t.previousPost,t.previousPost=t.history.pop(),e},t.nextVideo=function(){return t.currentPost=s(),t.$broadcast("redditelly.post.change")},t.prevVideo=function(){return t.currentPost=i(),t.$broadcast("redditelly.post.change")},t.selectPost=function(e){var n,o;for(o=[];(null!=(n=t.currentPost)?n.id:void 0)!==e;)o.push(t.nextVideo());return o},t.$on("youtube.player.ended",function(){return t.nextVideo()}),t.$on("youtube.player.ready",function(){var n;return n=r.getTimeFromURL(t.currentPost.url),null!=n&&r.player.seekTo(n,!0),r.player.playVideo(),ga("send","event","Video","Play",e.r)}),a=function(t,e){return null==e&&(e={}),n.go("subreddit",{r:t,v:e.id},{location:!0,reload:!1,notify:!1})},t.$on("redditelly.post.change",function(){return a(e.r,t.currentPost),u()}),t.preventDefault=function(t){return t.preventDefault()},t.togglePlayer=function(){return null!=r.player?"playing"===r.currentState?r.player.pauseVideo():r.player.playVideo():void 0}}]);
angular.module("redditelly.directives").directive("clickToExpand",[function(){return{link:function(n,r,e){var l,o,c;return r.addClass("click-to-expand"),l=null,o=function(n){var e;return l=n,e=n?"addClass":"removeClass",r[e]("collapsed")},c=function(){return o(!l)},o(!0),r.on("click",function(){return n.$apply(c)}),n.$on("$destroy",function(){return r.off("click")}),e.collapseOn?n.$on(e.collapseOn,function(){return l?void 0:o(!0)}):void 0}}}]);
angular.module("redditelly.directives").directive("screenHeight",["$window",function(e){return{link:function(i,n,t){var r,c,d;return d=t.heightOffset||"0",c=parseInt(d,10),r=e.innerHeight-c,n.css("max-height",""+r+"px")}}}]);
angular.module("redditelly.filters").filter("timeago",function(){return function(t){var a,n,r,e,o,u,d,i,g;return a=1e3*t,u=(new Date).getTime(),n=u-a,i=Math.abs(n)/1e3,45>i?"just now":(d=function(t){return Math.round(t)>1?"s":""},o=i/60,45>o?""+Math.round(o)+" minute"+d(o)+" ago":(e=o/60,24>e?""+Math.round(e)+" hour"+d(e)+" ago":(r=e/24,365>r?""+Math.round(r)+" day"+d(r)+" ago":(g=r/365,""+Math.round(g)+" year"+d(g)+" ago"))))}});
angular.module("redditelly.filters").filter("getVideoIDfromURL",[function(){var e,t;return t=/https?:\/\/(?:[0-9A-Z-]+\.)?(?:youtu\.be\/|youtube(?:-nocookie)?\.com\S*[^\w\s-])([\w-]{11})(?=[^\w-]|$)(?![?=&+%\w.-]*(?:['"][^<>]*>|<\/a>))[?=&+%\w.-]*/gi,e=function(e,t){return e.indexOf(t)>-1},function(o){var n,r,u;return null==o&&(o=""),n=o.replace(t,"$1"),e(n,";")?(r=n.split(";"),e(r[1],"%")?(u=decodeURIComponent(n.split(";")[1]),n=("http://youtube.com"+u).replace(t,"$1")):n=r[0]):e(n,"#")&&(n=n.split("#")[0]),n}}]);
angular.module("redditelly.filters").filter("idToThumbnail",[function(){return function(t,u){return null==u&&(u="default"),"http://img.youtube.com/vi/"+t+"/"+u+".jpg"}}]);
angular.module("redditelly.services").service("$reddit",["$http",function(t){var n,r,e,u;return n="http://www.reddit.com",u=function(t){return""+n+"/r/"+t+"/.json"},r=function(t){return"t3_"+t},e=function(t){return""+n+"/by_id/"+r(t)+"/.json"},{get:function(n,r){return t.get(u(n),{params:r}).then(function(t){return _.map(t.data.data.children,function(t){return t.data})})},getAfter:function(t,n){return this.get(t,{after:r(n)})},getPostById:function(n){return t.get(e(n)).then(function(t){var n;return null!=(n=t.data.data.children[0])?n.data:void 0},function(t){throw t.data})}}}]);