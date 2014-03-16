angular.module('redditelly.directives')

.directive 'clickToExpand', [ ->
    return {
        link: (scope, el, attrs) ->
            el.addClass 'click-to-expand'
            collapsed = null

            setCollapsed = (bool) ->
                collapsed = bool
                method = if bool then 'addClass' else 'removeClass'
                el[method] 'collapsed'

            toggle = ->
                setCollapsed(not collapsed)

            # default
            setCollapsed true

            el.on 'click', ->
                scope.$apply toggle

            scope.$on '$destroy', ->
                el.off 'click'
    }

]
