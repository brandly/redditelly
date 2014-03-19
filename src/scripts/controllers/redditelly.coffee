angular.module('redditelly')

.controller 'RedditellyCtrl', ['$scope', '$state', ($scope, $state) ->
    $scope.pickingSubreddit = false

    $scope.categories = [{
        name: 'general'
        list: [
            'videos'
            'youtubehaiku'
            'video'
            'youtube'
            'kidsafevideos'
        ]
    }, {
        name: 'music'
        list: [
            'music'
            'listentothis'
            'hiphopheads'
            'amv'
            'classicalmusic'
            'under10k'
        ]
    }, {
        name: 'film & tv'
        list: [
            'documentaries'
            'fullmoviesonyoutube'
            'movietrailers'
            'trailers'
            'television'
        ]
    }, {
        name: 'sports'
        list: [
            'sports'
            'nba'
        ]
    }, {
        name: 'cats'
        list: [
            'catvideos'
            'catpranks'
        ]
    }, {
        name: 'games'
        list: [
            'gaming'
            'games'
        ]
    }]

    $scope.goTo = (subreddit) ->
        $scope.pickingSubreddit = false
        $state.go 'subreddit',
            r: subreddit
]
