angular.module('redditelly')

.controller 'SubredditCtrl', ['$scope', '$stateParams', '$state', '$reddit', '$youtube', ($scope, $stateParams, $state, $reddit, $youtube) ->
    linkedToPost = $stateParams.v?

    $scope.posts = []
    $scope.currentPost = null
    $scope.history = []
    $scope.lastPostId = null
    $scope.noMorePosts = null

    validPost = (post) ->
        # when switching subreddits,
        # the post might be leftover from a different subreddit.
        # we only know how to youtube, currently.
        (post.domain is 'youtube.com') and (post.subreddit.toLowerCase() is $scope.currentSubreddit)

    updateLocalPosts = (posts=[]) ->
        $scope.lastPostId = if posts?.length then posts[posts.length - 1].id else null
        acceptedPosts = posts.filter validPost
        $scope.posts = $scope.posts.concat acceptedPosts
        $scope.noMorePosts = acceptedPosts.length < 1

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
        updateLocalPosts posts

        unless linkedToPost
            $scope.nextVideo()

    $scope.getMorePosts = ->
        return if $scope.noMorePosts
        $reddit.getAfter($stateParams.r, $scope.lastPostId).then (posts) ->
            updateLocalPosts posts

    getNextPost = ->
        if $scope.currentPost?
            $scope.history.push $scope.currentPost
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

    setURL = (subreddit, post={}) ->
        # update 'v' in query string
        # https://github.com/angular-ui/ui-router/wiki/Quick-Reference#state-1
        $state.go 'subreddit', {
            r: subreddit
            v: post.id
        }, {
            location: true
            reload: false
            notify: false
        }

    $scope.$on 'redditelly.post.change', ->
        setURL $stateParams.r, $scope.currentPost

    $scope.preventDefault = (e) ->
        e.preventDefault()
]
