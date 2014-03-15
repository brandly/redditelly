
describe 'get video id from url', ->
    getVideoId = null

    beforeEach module('redditelly.filters')
    beforeEach inject ($filter) ->
        getVideoId = $filter 'getVideoIDfromURL'

    it 'should handle regular query strings', ->
        url = 'https://www.youtube.com/watch?v=nViWpVc1x_4&feature=youtu.be'
        id = 'nViWpVc1x_4'
        expect(getVideoId(url)).toBe id

    it 'should handle attribution_link', ->
        url = 'http://www.youtube.com/attribution_link?a=pxa6goHqzaA&amp;u=%2Fwatch%3Fv%3DdPdgx30w9sU%26feature%3Dshare'
        id = 'dPdgx30w9sU'
        expect(getVideoId(url)).toBe id

    it 'should handle almost a query string', ->
        url = 'http://www.youtube.com/watch?feature=player_detailpage&amp;v=93LvTKF_jW0#t=1'
        id = '93LvTKF_jW0'
        expect(getVideoId(url)).toBe id
