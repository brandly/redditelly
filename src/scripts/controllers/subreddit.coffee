angular.module('rddt')

.controller 'SubredditCtrl', ['$scope', '$stateParams', '$reddit', '$youtube', ($scope, $stateParams, $reddit, $youtube) ->
    $scope.posts = null
    $scope.currentVideo = null

    $reddit.get($stateParams.subreddit).then (posts) ->
        $scope.posts = posts
        $scope.setNext()

    getNextVideo = ->
        # no `do while` in coffeescript :(
        post = $scope.posts.shift()
        while post?.domain isnt 'youtube.com'
            post = $scope.posts.shift()
        return post

    $scope.setNext = ->
        $scope.currentVideo = getNextVideo().url

    $scope.$on 'youtube.player.ended', ->
        $scope.setNext()

    $scope.$on 'youtube.player.ready', ->
        $youtube.player.playVideo()

    window.butts = $scope
]
