angular.module('redditelly')

.controller 'AppCtrl', ['$scope', ($scope) ->
    $scope.subreddits = [
        'videos'
        'youtubehaiku'
        'deepintoyoutube'
        'music'
        'listentothis'
    ]
]
