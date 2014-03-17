angular.module('redditelly')

.controller 'RedditellyCtrl', ['$scope', '$state', ($scope, $state) ->
    $scope.pickingSubreddit = false

    # routing is breaking on commented out ones
    # doing something wrong in subreddit.coffee
    $scope.categories = [{
        name: 'general'
        list: [
            'videos'
            'youtubehaiku'
            'video'
            'youtube'
        ]
    }, {
        name: 'music'
        list: [
            # 'music'
            'listentothis'
            'amv'
        ]
    }, {
        name: 'film & tv'
        list: [
            # 'documentaries'
            'fullmoviesonyoutube'
            'television'
        ]
    }, {
        name: 'sports'
        list: [
            'sports'
            'nba'
        ]
    }, {
        name: 'games'
        list: [
            'gaming'
            # 'games'
        ]
    }]

    $scope.goTo = (subreddit) ->
        $scope.pickingSubreddit = false
        $state.go 'subreddit',
            r: subreddit
]
