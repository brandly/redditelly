angular.module('redditelly.filters')

.filter 'idToThumbnail', [ ->
    # various sizes
    # http://stackoverflow.com/a/2068371/1614967
    return (id, size='default') ->
        "http://img.youtube.com/vi/#{id}/#{size}.jpg"
]

