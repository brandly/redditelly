angular.module('redditelly.filters')

.filter 'getVideoIDfromURL', [ ->

    # adapted from http://stackoverflow.com/a/5831191/1614967
    youtubeRegexp = /https?:\/\/(?:[0-9A-Z-]+\.)?(?:youtu\.be\/|youtube(?:-nocookie)?\.com\S*[^\w\s-])([\w-]{11})(?=[^\w-]|$)(?![?=&+%\w.-]*(?:['"][^<>]*>|<\/a>))[?=&+%\w.-]*/ig

    contains = (str, piece) ->
        str.indexOf(piece) > -1

    return (url='') ->
        id = url.replace youtubeRegexp, '$1'

        # links like this: "http://www.youtube.com/attribution_link?a=pxa6goHqzaA&amp;u=%2Fwatch%3Fv%3DdPdgx30w9sU%26feature%3Dshare"
        # have the real query string URI encoded behind a ';'.
        # at this point, `id is 'pxa6goHqzaA;u=%2Fwatch%3Fv%3DdPdgx30w9sU%26feature%3Dshare'
        if contains id, ';'
            uriComponent = decodeURIComponent id.split(';')[1]
            id = ('http://youtube.com' + uriComponent).replace youtubeRegexp, '$1'
        else if contains id, '#'
            # id might look like '93LvTKF_jW0#t=1'
            # and we want '93LvTKF_jW0'
            id = id.split('#')[0]

        return id
]
