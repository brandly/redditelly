angular.module('rddt')

.controller 'AppCtrl', ['$scope', ($scope) ->
    $scope.subreddits = [
        'videos'
        'youtubehaiku'
        'deepintoyoutube'
    ]
]
