angular.module('redditelly.filters')

.filter 'urlToThumbnail', ['youtubeEmbedUtils', (youtubeEmbedUtils) ->
    # various sizes
    # http://stackoverflow.com/a/2068371/1614967
    return (url, size='default') ->
        "http://img.youtube.com/vi/#{youtubeEmbedUtils.getIdFromURL url}/#{size}.jpg"
]

