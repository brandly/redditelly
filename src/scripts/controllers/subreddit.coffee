angular.module('redditelly')

.controller 'SubredditCtrl', ['$scope', '$stateParams', '$state', '$reddit', '$youtube', ($scope, $stateParams, $state, $reddit, $youtube) ->
    linkedToPost = $stateParams.v?

    $scope.posts = null
    $scope.currentPost = null

    validPost = (post) ->
        # when switching subreddits,
        # the post might be leftover from a different subreddit.
        # we only know how to youtube, currently.
        (post.domain is 'youtube.com') and (post.subreddit.toLowerCase() is $scope.currentSubreddit)

    if linkedToPost
        # in case anything goes wrong
        jkInvalidPost = ->
            linkedToPost = false
            if $scope.posts?.length
                $scope.nextVideo()

        $reddit.getPostById($stateParams.v).then (post) ->
            if validPost post
                $scope.currentPost = post
            else
                jkInvalidPost()
        , jkInvalidPost

    $reddit.get($stateParams.r).then (posts) ->
        console.log 'POSTS', posts
        $scope.posts = posts.filter validPost

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
        time = $youtube.getTimeFromURL $scope.currentPost.url
        if time?
            $youtube.player.seekTo time, true

        $youtube.player.playVideo()

    $scope.$on 'redditelly.post.change', ->
        # update 'v' in query string
        # https://github.com/angular-ui/ui-router/wiki/Quick-Reference#state-1
        $state.go 'subreddit', {
            r: $stateParams.r
            v: $scope.currentPost?.id
        }, {
            location: true
            reload: false
            notify: false
        }
]
