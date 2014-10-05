angular.module('redditelly.directives')

.directive 'tweet', ['$window', ($window) ->
    return {
        scope:
            tweet: '@'
        link: (scope, element, attrs) ->
            base = 'http://twitter.com/share'

            element.on 'click', (e) ->
                e.preventDefault()

                width = 600
                height = 250

                top = ($window.innerHeight - height) / 2
                left = ($window.innerWidth - width) / 2

                url = "#{base}?text=#{encodeURIComponent scope.tweet}"
                opts = "status=1,width=#{width},height=#{height},top=#{top},left=#{left}"

                $window.open url, 'twitter', opts
    }
]
