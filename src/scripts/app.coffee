angular.module('redditelly.services', [])
angular.module('redditelly.filters', [])
angular.module('redditelly.directives', [])

dependencies = [
    'redditelly.services'
    'redditelly.filters'
    'redditelly.directives'
    'ui.router'
    'youtube'
]

angular.module('redditelly', dependencies).config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
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

]).run(['$rootScope', ($rootScope) ->
    $rootScope.$on '$stateChangeSuccess', (e, toState, toParams) ->
        $rootScope.currentSubreddit = toParams.r
        $rootScope.pageTitle = toParams.r or 'redditelly'
])
