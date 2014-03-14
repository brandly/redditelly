angular.module('rddt.filters')

.filter 'getVideoIDfromURL', [ ->
    ### Known exceptions
        "http://www.youtube.com/attribution_link?a=pxa6goHqzaA&amp;u=%2Fwatch%3Fv%3DdPdgx30w9sU%26feature%3Dshare"
    ###
    return (url='') ->
        queryString = url.split('?')[1] or ''
        pairs = queryString.split '&'
        queryObject = {}
        for pair in pairs
            keyAndValue = pair.split '='
            queryObject[keyAndValue[0]] = keyAndValue[1]

        video = queryObject.v or ''

        pieces = video.split '#'
        pieces[0]
]
