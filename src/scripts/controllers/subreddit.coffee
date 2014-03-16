angular.module('redditelly')

.controller 'SubredditCtrl', ['$scope', '$stateParams', '$state', '$reddit', '$youtube', ($scope, $stateParams, $state, $reddit, $youtube) ->
    linkedToPost = $stateParams.v?

    $scope.posts = null
    $scope.currentPost = null

    if linkedToPost
        id = $stateParams.v
        $reddit.getPostById(id).then (post) ->
            $scope.currentPost = post
        , (e) ->
            # clear state params
            # call next video if we have them
            # otherwise, somehow let the video list know to call

    $reddit.get($stateParams.r).then (posts) ->
        console.log 'POSTS', posts
        $scope.posts = posts.filter (post) ->
            post.domain is 'youtube.com'
        unless linkedToPost
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

    $scope.$on 'redditelly.post.change', ->
        # update 'v' in query string
        # https://github.com/angular-ui/ui-router/wiki/Quick-Reference#state-1
        $state.go 'subreddit', {
            r: $stateParams.r
            v: $scope.currentPost.id
        },  {
            location: true
            reload: false
            notify: false
        }
]
