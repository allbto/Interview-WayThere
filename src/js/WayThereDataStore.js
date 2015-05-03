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
                },
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
                }
            ];
        }

        function _handleSpecialIcons(forecast)
        {
            switch (forecast.icon)
            {
                case 'chanceflurries':
                    forecast.icon = 'chancesnow';
                    break;
                case 'nt_chanceflurries':
                    forecast.icon = 'nt_chancesnow';
                    break;
                case 'flurries':
                    forecast.icon = 'snow';
                    break;
                case 'nt_flurries':
                    forecast.icon = 'nt_snow';
                    break;
                case 'chancesleet':
                case 'nt_chancesleet':
                case 'nt_sleet':
                    forecast.icon = 'sleet';
                    break;
                case 'nt_rain':
                    forecast.icon = 'rain';
                    break;

                case 'nt_cloudy':
                    forecast.icon = 'cloudy';
                    break;
                case 'hazy':
                    forecast.icon = 'fog';
                    break;
                case 'nt_hazy':
                    forecast.icon = 'nt_fog';
                    break;
                case 'clear':
                    forecast.icon = 'sunny';
                    break;
                case 'nt_clear':
                    forecast.icon = 'nt_sunny';
                    break;
                case 'nt_unknown':
                    forecast.icon = 'unknown';
            }
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
                case 'nt_chanceflurries':
                case 'nt_chancesnow':
                case 'nt_chancesleet':
                case 'nt_flurries':
                case 'nt_sleet':
                case 'nt_snow':
                    ids = ['V6cNXL2TUIM', 'u153b2MO5Lg', 'RuqVnqNPyC0', 'zGD5C4wLsrs'];
                    break;

                case 'chancerain':
                case 'rain':
                case 'nt_chancerain':
                case 'nt_rain':
                    ids = ['yYZioushoK4', 'naOBXOdLiig', 'UmHEU2LArbA', 'RvInwvtZw-8'];
                    break;

                case 'chancetstorms':
                case 'tstorms':
                case 'nt_chancetstorms':
                case 'nt_tstorms':
                    ids = ['XZD1zK4QQSA', 'ywBxqqpyfOc', 'aQlJRMOJfyQ'];
                    break;

                case 'cloudy':
                case 'fog':
                case 'hazy':
                case 'mostlycloudy':
                case 'mostlysunny':
                case 'partlycloudy':
                case 'partlysunny':
                case 'nt_cloudy':
                case 'nt_fog':
                case 'nt_hazy':
                case 'nt_mostlycloudy':
                case 'nt_mostlysunny':
                case 'nt_partlycloudy':
                case 'nt_partlysunny':
                    ids = ['psdLqhWmhe8', '8gD_9WPPFb4', 'E8TUzXK6nu4', 'v-vXqBJCqI0'];
                    break;

                case 'sunny':
                case 'clear':
                case 'unknown':
                case 'nt_sunny':
                case 'nt_clear':
                case 'nt_unknown':
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

                    weathers[index].forecasts.forEach(function(forecast) {
                        _handleSpecialIcons(forecast);
                    })
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
                LocalStorage.set(WeathersKey, weathers);
            }

            _getWeatherForeCastForWeathers(weathers, 0, function(updatedWeathers) {
                LocalStorage.set(WeathersKey, weathers);
                success(updatedWeathers);
            });

            return weathers;
        }

    });

})(angular);
