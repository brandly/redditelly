angular.module('redditelly.services')

.service '$reddit', ['$http', ($http) ->
    base = 'http://www.reddit.com'
    subredditUrl = (subreddit) ->
        "#{base}/r/#{subreddit}/.json"

    postFullname = (id) ->
        "t3_#{id}"

    postUrl = (id) ->
        "#{base}/by_id/#{postFullname(id)}/.json"

    return {
        get: (subreddit, params) ->
            $http.get(subredditUrl(subreddit), {params}).then (response) ->
                # Strip things down to the post objects
                _.map response.data.data.children, (data) ->
                    data.data

        getAfter: (subreddit, id) ->
            @get subreddit, {after: postFullname(id)}

        getPostById: (id) ->
            $http.get(postUrl(id)).then (response) ->
                response.data.data.children[0]?.data
            , (response) ->
                throw response.data
    }
]
