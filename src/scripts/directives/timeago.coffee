angular.module('redditelly.filters')

.filter 'timeago', ->
    return (input) ->

        nowTime = (new Date()).getTime()
        date = (new Date(input * 1000)).getTime()
        dateDifference = nowTime - date

        seconds = Math.abs(dateDifference) / 1000
        if seconds < 45
            return 'just now'

        plural = (duration) ->
            if Math.round(duration) > 1
                return 's'
            else
                return ''

        minutes = seconds / 60
        if minutes < 45
            return "#{Math.round(minutes)} minute#{plural(minutes)} ago"

        hours = minutes / 60
        if hours < 24
            return "#{Math.round(hours)} hour#{plural(hours)} ago"

        days = hours / 24
        if days < 365
            return "#{Math.round(days)} day#{plural(days)} ago"

        years = days / 365
        return "#{Math.round(years)} year#{plural(years)} ago"
