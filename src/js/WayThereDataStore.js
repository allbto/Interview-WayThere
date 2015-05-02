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
        
        function _videoIdsForForecast(forecast)
        {
            var ids = [];

            switch (forecast.icon)
            {
                case 'chanceflurries':
                case 'chancesnow':
                case 'chancesleet':
                case 'flurries':
                case 'sleet':
                case 'snow':
                    ids = ['V6cNXL2TUIM', 'u153b2MO5Lg', 'RuqVnqNPyC0', 'zGD5C4wLsrs'];
                    break;

                case 'chancerain':
                case 'rain':
                    ids = ['yYZioushoK4', 'naOBXOdLiig', 'UmHEU2LArbA', 'RvInwvtZw-8'];
                    break;

                case 'chancetstorms':
                case 'tstorms':
                    ids = ['XZD1zK4QQSA', 'ywBxqqpyfOc', 'aQlJRMOJfyQ'];
                    break;

                case 'cloudy':
                case 'fog':
                case 'hazy':
                case 'mostlycloudy':
                case 'mostlysunny':
                case 'partlycloudy':
                case 'partlysunny':
                    ids = ['psdLqhWmhe8', '8gD_9WPPFb4', 'E8TUzXK6nu4', 'v-vXqBJCqI0'];
                    break;

                case 'sunny':
                case 'clear':
                case 'unknown':
                default:
                    ids = ['ubVa-Lygl2I', '4NG30BMPqn8', '2G8LAiHSCAs', 'PwSHOI7DwWM', 'OG2eGVt6v2o'];
            }
            return ids;
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
                {
                    var forecasts = data.forecast.txt_forecast.forecastday;
                    weathers[index].forecasts = forecasts || [];
                    weathers[index].video_ids = _videoIdsForForecast(forecasts[0]);
                }

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

            _getWeatherForeCastForWeathers(weathers, 0, function(updatedWeathers) {
                LocalStorage.get(WeathersKey, weathers);
                success(updatedWeathers);
            });

            return weathers;
        }

    });

})(angular);
