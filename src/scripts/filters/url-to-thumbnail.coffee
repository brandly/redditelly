angular.module('redditelly.filters')

.filter 'urlToThumbnail', ['$youtube', ($youtube) ->
    # various sizes
    # http://stackoverflow.com/a/2068371/1614967
    return (url, size='default') ->
        "http://img.youtube.com/vi/#{$youtube.getIdFromURL url}/#{size}.jpg"
]

