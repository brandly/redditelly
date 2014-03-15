angular.module('redditelly')

.controller 'SubredditCtrl', ['$scope', '$stateParams', '$reddit', '$youtube', ($scope, $stateParams, $reddit, $youtube) ->
    $scope.posts = null
    $scope.currentPost = null

    $reddit.get($stateParams.r).then (posts) ->
        console.log 'POSTS', posts
        $scope.posts = posts.filter (post) ->
            post.domain is 'youtube.com'
        $scope.setNext()

    getNextPost = ->
        $scope.posts.shift()

    $scope.setNext = ->
        $scope.currentPost = getNextPost()

    $scope.$on 'youtube.player.ended', ->
        $scope.setNext()

    $scope.$on 'youtube.player.ready', ->
        $youtube.player.playVideo()
]
