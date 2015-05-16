/**
 * Created by allan on 5/2/15.
 */

(function(ng) {
    'use strict';

    var _DEV_ = true;

    var mod = angular.module("remote-storage", []);

    mod.factory('RemoteStorageFactory', function() {

        return {
            Status: {
                200: "OK",
                404: "Not Found",
                500: "Internal Server Error",
                201: "Created",
                304: "Not Modified",
                400: "Bad Request",
                401: "Unauthorized",
                403: "Forbidden"
            },
            errorMessageFromErrors: function(errors) {
                var message = "";

                for (var key in errors) {
                    var val = errors[key];

                    if (message.length > 0 && message.charAt(message.length - 1) != '\n')
                        message += '\n';

                    message += key.replace('_', ' ').capitalize() + " : " + val.capitalize();
                }
                return message;
            }
        };
    });

    mod.service('RemoteStorage', function($http, RemoteStorageFactory) {
        var self = this;

        //
        //  Vars
        //

        self.BaseUrl = "http://api.wunderground.com/api/ce4f06b766a604d5";

        //
        //  Funcs
        //

        /**
         * Transform data object to a url or post readable string
         * e.g. : { id:1, data:"my data" } -> "id=1&data=my%20data"
         * @param {object} data
         * @returns {string}
         */
        self.transformData = function(data) {
            var key, result = [];
            for (key in data) {
                if (data.hasOwnProperty(key)) {
                    result.push(encodeURIComponent(key) + "=" + encodeURIComponent(data[key]));
                }
            }
            return result.join("&");
        };

        /**
         * For each key, if the value is an array, the extension '[]' is added to the key
         * e.g. { 'id':1, 'filter': ['1', '2'] } -> { 'id':1, 'filter[]': ['1', '2'] }
         * @param {object} data
         * @returns {object}
         */
        self.transformArrayData = function(data) {
            var key, result = {};
            for (key in data) {
                if (angular.isArray(data[key]))
                    result[key + '[]'] = data[key];
                else
                    result[key] = data[key];
            }
            return result;
        };

        /**
         * Launch an http request
         * @param {string} method GET, POST, PUT, DELETE
         * @param {string} url that will be concatenated with BaseUrl
         * @param {object|null} params to send to request
         * @param {function} success callback
         * @param {function} failure callback
         * @param {*} [defaultResult={}] : is send to success callback if request is a success but there is no data
         */
        self.http = function(method, url, params, success, failure, defaultResult) {
            defaultResult = defaultResult || {};

            var request = {
                method: method,
                url: self.BaseUrl + (url.charAt(0) == "/" ? "" : "/") + url
            };

            if (method.toLowerCase() == "get")
                request.params = self.transformArrayData(params || {});
            else if (method.toLowerCase() == "post" || method.toLowerCase() == "put") {
                request.headers = {'Content-Type': 'application/x-www-form-urlencoded'};
                request.data = self.transformData(params);
            }
            else
                request.data = params || {};

            $http(request)
                .success(function(data, status, headers, config) {
                    // file is uploaded successfully
                    if (_DEV_) console.log('Request : [' + method + '] ' + url, params, '\n', status, ' Response: ', data);

                    if (status != 204) {
                        if (data.error)
                            failure(data.error);
                        else
                            success(data);
                    }
                    else
                        success(defaultResult);

                }).error(function(data, status, headers, config) {
                    if (_DEV_) console.log('Request : [' + method + '] ' + url, params, '\n', status, ' Error: ', data);
                    failure({
                        id: status,
                        message: data.error ? RemoteStorageFactory.errorMessageFromErrors(data.error) : RemoteStorageFactory.Status[status]
                    });
                });
        };

        /**
         * Same as doing http("GET", ...)
         * @param {string} url that will be concatenated with BaseUrl
         * @param {object|null} params to send to request
         * @param {function} success callback
         * @param {function} failure callback
         * @param {*} [defaultResult={}] : is send to success callback if request is a success but there is no data
         */
        self.get = function(url, params, success, failure, defaultResult) {
            self.http("GET", url, params, success, failure, defaultResult);
        };

        /**
         * Same as doing http("POST", ...)
         * @param {string} url that will be concatenated with BaseUrl
         * @param {object|null} params to send to request
         * @param {function} success callback
         * @param {function} failure callback
         * @param {*} [defaultResult={}] : is send to success callback if request is a success but there is no data
         */
        self.post = function(url, params, success, failure, defaultResult) {
            self.http("POST", url, params, success, failure, defaultResult);
        };

        /**
         * Same as doing http("PUT", ...)
         * @param {string} url that will be concatenated with BaseUrl
         * @param {object|null} params to send to request
         * @param {function} success callback
         * @param {function} failure callback
         * @param {*} [defaultResult={}] : is send to success callback if request is a success but there is no data
         */
        self.put = function(url, params, success, failure, defaultResult) {
            self.http("PUT", url, params, success, failure, defaultResult);
        };

        /**
         * Same as doing http("DELETE", ...)
         * @param {string} url that will be concatenated with BaseUrl
         * @param {object|null} params to send to request
         * @param {function} success callback
         * @param {function} failure callback
         * @param {*} [defaultResult={}] : is send to success callback if request is a success but there is no data
         */
        self.delete = function(url, params, success, failure, defaultResult) {
            self.http("DELETE", url, params, success, failure, defaultResult);
        };
    });

    /**
     * Build REST url params
     * @usage "/my/api/data/:dataId/detail/:detailId".buildURL(dataId, detailId);
     * @param arguments
     * @returns {String}
     */
    String.prototype.buildURL = function() {
        var base = this;
        var newArgs = base.match(/:[a-zA-Z]+/g);

        for (var i = 0; i < arguments.length, i < newArgs.length; ++i) {
            base = base.replace(newArgs[i], arguments[i]);
        }
        return base;
    };

})(angular);