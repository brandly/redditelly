angular.module('redditelly')

.controller 'SubredditCtrl', ['$scope', '$stateParams', '$state', '$reddit', 'isMobile', ($scope, $stateParams, $state, $reddit, isMobile) ->
    linkedToPost = $stateParams.v?

    $scope.posts = []
    $scope.currentPost = null
    $scope.previousPost = null
    $scope.history = []
    $scope.lastPostId = null
    $scope.noMorePosts = null
    $scope.loadingPosts = false
    $scope.player = null

    validDomains = ['youtube.com', 'youtu.be']
    validPost = (post) ->
        # when switching subreddits,
        # the post might be leftover from a different subreddit.
        # we only know how to youtube, currently.
        (post.domain in validDomains) and (post.subreddit.toLowerCase() is $scope.currentSubreddit)

    ensureEnoughPosts = ->
        if $scope.posts.length < 8 and not $scope.noMorePosts
            $scope.getMorePosts()

    updateLocalPosts = (posts=[]) ->
        $scope.lastPostId = if posts?.length then posts[posts.length - 1].id else null
        acceptedPosts = posts.filter validPost
        $scope.posts = $scope.posts.concat acceptedPosts
        $scope.noMorePosts = acceptedPosts.length < 1
        ensureEnoughPosts()

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

    $scope.loadingPosts = true
    $reddit.get($stateParams.r).then (posts) ->
        $scope.loadingPosts = false
        updateLocalPosts posts

        unless linkedToPost
            $scope.nextVideo()

    $scope.getMorePosts = ->
        return if $scope.noMorePosts
        $scope.loadingPosts = true
        $reddit.getAfter($stateParams.r, $scope.lastPostId).then (posts) ->
            $scope.loadingPosts = false
            updateLocalPosts posts

    getNextPost = ->
        if $scope.previousPost
            $scope.history.push $scope.previousPost
        if $scope.currentPost
            $scope.previousPost = $scope.currentPost
        $scope.posts.shift()

    getPreviousPost = ->
        if $scope.currentPost
            $scope.posts.unshift $scope.currentPost
        previous = $scope.previousPost
        $scope.previousPost = $scope.history.pop()
        return previous

    $scope.nextVideo = ->
        next = getNextPost()
        if next.id is $scope.currentPost?.id
            # we want something new
            $scope.nextVideo()
        else
            $scope.currentPost = next
            $scope.$broadcast 'redditelly.post.change'

    $scope.prevVideo = ->
        $scope.currentPost = getPreviousPost()
        $scope.$broadcast 'redditelly.post.change'

    $scope.selectPost = (index) ->
        for i in [0..index] by 1
            $scope.nextVideo()

    $scope.$on 'youtube.player.ended', ->
        $scope.nextVideo()

    $scope.$on 'youtube.player.ready', ($event, player) ->
        player.playVideo() unless isMobile
        ga('send', 'event', 'Video', 'Play', $stateParams.r)

    setURL = (subreddit, post={}) ->
        # update 'v' in query string
        # https://github.com/angular-ui/ui-router/wiki/Quick-Reference#state-1
        $state.go 'subreddit', {
            r: subreddit
            v: post.id
        }, {
            location: false
            reload: false
            notify: false
        }

    $scope.$on 'redditelly.post.change', ->
        setURL $stateParams.r, $scope.currentPost
        ensureEnoughPosts()

    $scope.preventDefault = (e) ->
        e.preventDefault()

    $scope.togglePlayer = ->
        {player} = $scope
        return unless player?

        if player.currentState is 'playing'
            player.pauseVideo()
        else
            player.playVideo()

    truncate = (str, max) ->
        if str.length > max
            "#{str.substr(0, max - 3)}..."
        else
            str

    $scope.getTweet = (post) ->
        return '' unless post

        url = "http://redditel.ly/#/#{post.subreddit}/#{post.id}"
        space = ' '
        title = truncate post.title, (140 - url.length - space.length)
        "#{title}#{space}#{url}"
]
