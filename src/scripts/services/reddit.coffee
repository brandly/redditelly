angular.module('redditelly.services')

.service '$reddit', ['$http', ($http) ->
    base = 'http://www.reddit.com'
    subredditUrl = (subreddit) ->
        "#{base}/r/#{subreddit}/.json"

    postUrl = (id) ->
        "#{base}/by_id/t3_#{id}/.json"

    return {
        get: (subreddit) ->
            $http.get(subredditUrl(subreddit)).then (response) ->
                # Strip things down to the post objects
                _.map response.data.data.children, (data) ->
                    data.data

        getPostById: (id) ->
            $http.get(postUrl(id)).then (response) ->
                response.data.data.children[0]?.data
    }
]
