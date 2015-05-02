/**
 * Created by allan on 5/2/15.
 */

(function(ng) {
    'use strict';

    var mod = angular.module("local-storage", []);

    mod.factory('LocalStorageFactory', function() {
        return {
            TimeBeforeOutDated: 300000 // In milliseconds, 5 minutes
        };
    });

    mod.service('LocalStorage', function(LocalStorageFactory) {
        var self = this;
        // Local Storage

        self.useSession = false;

        self.get = function(key, defValue) {
            defValue = defValue || null;

            var item = null;

            // Check browser support
            if (_isLocalStorageAvailable()) {
                item = angular.fromJson(currentStorage().getItem(key));
            } else {
                item = LocalStorageFactory[key];
            }


            if (!angular.isDefined(item) || !item || !item.value)// || _isOutDated(item))
                return defValue;

            return item.value;
        };

        var _isLocalStorageAvailable = function() {
            return (typeof(Storage) != "undefined");
        };

        var _isOutDated = function(object) {
            object = object || {};
            object.storedAt = object.storedAt || (new Date()).getTime();

            var date = new Date();

            return (date.getTime() - object.storedAt > LocalStorageFactory.TimeBeforeOutDated);
        };

        var currentStorage = function() {
            return self.useSession ? sessionStorage : localStorage;
        };

        self.set = function(key, value) {
            var val = {
                value: value || "",
                storedAt: (new Date()).getTime()
            };

            // Check browser support
            if (_isLocalStorageAvailable()) {
                currentStorage().setItem(key, angular.toJson(val));
            } else {
                LocalStorageFactory[key] = val;
            }
        };

        self.clear = function() {
            if (_isLocalStorageAvailable()) {
                currentStorage().clear();
            } else {
                LocalStorageFactory.length = 0; // Clear
            }
        };
    });

})(angular);