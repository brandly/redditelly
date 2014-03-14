angular.module('rddt.services', [])
angular.module('rddt.filters', [])
angular.module('rddt.directives', [])

dependencies = [
    'rddt.services'
    'rddt.filters'
    'rddt.directives'
    'ui.router'
    'youtube'
]

angular.module('rddt', dependencies).config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
    $stateProvider

        .state 'app',
            url: '/'
            templateUrl: 'views/app.html'
            controller: 'AppCtrl'

        .state 'subreddit',
            url: '/r/:r'
            templateUrl: 'views/subreddit.html'
            controller: 'SubredditCtrl'

        $urlRouterProvider.otherwise '/'

])
