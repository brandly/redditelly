angular.module('rddt')

.controller 'SubredditCtrl', ['$scope', '$stateParams', '$reddit', '$youtube', ($scope, $stateParams, $reddit, $youtube) ->
    $scope.posts = null
    $scope.currentPost = null

    $reddit.get($stateParams.r).then (posts) ->
        $scope.posts = posts
        $scope.setNext()

    getNextPost = ->
        # no `do while` in coffeescript :(
        post = $scope.posts.shift()
        while post?.domain isnt 'youtube.com'
            post = $scope.posts.shift()
        return post

    $scope.setNext = ->
        $scope.currentPost = getNextPost()

    $scope.$on 'youtube.player.ended', ->
        $scope.setNext()

    $scope.$on 'youtube.player.ready', ->
        $youtube.player.playVideo()
]
