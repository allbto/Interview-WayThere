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

        self.retrieveWeathers = function()
        {
            var weathers = LocalStorage.get(WeathersKey, []);

            if (weathers.length == 0)
            {
                weathers = _defaultWeathers();
                LocalStorage.get(WeathersKey, weathers);
            }

            return weathers;
        }

    });

})(angular);
