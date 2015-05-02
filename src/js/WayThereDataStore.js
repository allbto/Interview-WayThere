/**
 * Created by allan on 5/2/15.
 */


(function(ng) {
    'use strict';

    var app = ng.module("wayThere-dataStore", ['remote-storage', 'local-storage']);

    app.service('WayThereDataStore', function(RemoteStorage, LocalStorage) {

        LocalStorage.useSession = true;

        //
        //  Vars
        //

        var self = this;



        // Urls

        var Forecast10daysURL = "/forecast10day:queryUrl.json";

        // Keys

        var WeathersKey = "weathers_key";

        //
        //  Functions
        //

        function _defaultWeathers()
        {
            // Got from wunderground api
            return [
                {
                    "name": "Nice, France",
                    "type": "city",
                    "c": "FR",
                    "zmw": "00000.1.07690",
                    "tz": "Europe/Paris",
                    "tzs": "CEST",
                    "l": "/q/zmw:00000.1.07690",
                    "ll": "43.650002 7.200000",
                    "lat": "43.650002",
                    "lon": "7.200000"
                },
                {
                    "name": "Paris, France",
                    "type": "city",
                    "c": "FR",
                    "zmw": "00000.37.07156",
                    "tz": "Europe/Paris",
                    "tzs": "CEST",
                    "l": "/q/zmw:00000.37.07156",
                    "ll": "48.866665 2.333333",
                    "lat": "48.866665",
                    "lon": "2.333333"
                },
                {
                    "name": "Prague, Czech Republic",
                    "type": "city",
                    "c": "CZ",
                    "zmw": "00000.1.11518",
                    "tz": "Europe/Prague",
                    "tzs": "CEST",
                    "l": "/q/zmw:00000.1.11518",
                    "ll": "50.099998 14.280000",
                    "lat": "50.099998",
                    "lon": "14.280000"
                }
            ];
        }

        /**
         * Recursive functions that goes through weathers and fetch forecast for each of them, one after the others
         * @param {Array} weathers
         * @param {Number} index = current index, if index == weathers.length, success is called
         * @param {Function} success
         * @private
         */
        function _getWeatherForeCastForWeathers(weathers, index, success)
        {
            if (index == weathers.length) return success(weathers);

            RemoteStorage.get(Forecast10daysURL.buildURL(weathers[index]['l']), null, function(data) {

                /**
                 "forecast": {
                    "txt_forecast": {
                        "date": "9:10 PM CEST",
                        "forecastday": [
                 */
                if (data && data.forecast && data.forecast.txt_forecast && data.forecast.txt_forecast.forecastday)
                    weathers[index].forecasts = data.forecast.txt_forecast.forecastday;

                _getWeatherForeCastForWeathers(weathers, index + 1, success);

            }, function(error) {
                console.log("Error getting weather forecast : ", error);

                _getWeatherForeCastForWeathers(weathers, index + 1, success);
            });
        }

        self.retrieveWeathers = function(success)
        {
            var weathers = LocalStorage.get(WeathersKey, []);

            if (weathers.length == 0)
            {
                weathers = _defaultWeathers();
                LocalStorage.get(WeathersKey, weathers);
            }

            _getWeatherForeCastForWeathers(weathers, 0, success);

            return weathers;
        }

    });

})(angular);
