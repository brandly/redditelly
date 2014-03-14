angular.module('redditelly.services')

.service '$reddit', ['$http', ($http) ->
    url = (subreddit) ->
        "http://www.reddit.com/r/#{subreddit}/.json"

    return {
        get: (subreddit) ->
            $http.get(url(subreddit)).then (response) ->
                # Strip things down to the post objects
                _.map response.data.data.children, (data) ->
                    data.data
    }
]
