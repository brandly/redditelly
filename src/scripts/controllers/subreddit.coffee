angular.module('redditelly')

.controller 'SubredditCtrl', ['$scope', '$stateParams', '$reddit', '$youtube', ($scope, $stateParams, $reddit, $youtube) ->
    $scope.posts = null
    $scope.currentPost = null

    $reddit.get($stateParams.r).then (posts) ->
        console.log 'POSTS', posts
        $scope.posts = posts.filter (post) ->
            post.domain is 'youtube.com'
        $scope.nextVideo()

    getNextPost = ->
        $scope.posts.shift()

    $scope.nextVideo = ->
        $scope.currentPost = getNextPost()
        $scope.$broadcast 'redditelly.post.change'

    $scope.selectPost = (id) ->
        while $scope.currentPost?.id isnt id
            $scope.nextVideo()

    $scope.$on 'youtube.player.ended', ->
        $scope.nextVideo()

    $scope.$on 'youtube.player.ready', ->
        $youtube.player.playVideo()
]
