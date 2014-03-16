angular.module('redditelly.directives')

.directive 'screenHeight', ['$window', ($window) ->
    return {
        link: (scope, el, attrs) ->
            offsetString = attrs.heightOffset or '0'
            offset = parseInt offsetString, 10

            height = $window.innerHeight - offset
            el.css 'max-height', "#{height}px"
    }

]
