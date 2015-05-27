/**
 * Created by allan on 5/2/15.
 */


(function(ng) {
    'use strict';

    var app = ng.module("wayThereApp", ["wayThere-dataStore", 'ui.bootstrap', 'youtube-embed']);

    app.directive('onCarouselChange', function ($parse) {
        return {
            require: 'carousel',
            link: function (scope, element, attrs, carouselCtrl) {
                var fn = $parse(attrs.onCarouselChange);
                var origSelect = carouselCtrl.select;
                carouselCtrl.select = function (nextSlide, direction) {
                    if (nextSlide !== this.currentSlide) {
                        fn(scope, {
                            nextSlide: nextSlide,
                            direction: direction,
                            index: nextSlide.$parent.$index
                        });
                    }
                    return origSelect.apply(this, arguments);
                };
            }
        };
    });

    app.controller('WayThereController', function($scope, WayThereDataStore, $modal)
    {
        //
        //  Vars
        //

        /// WayThere

        $scope.weathers = [];

        /// Youtube player

        $scope.yt = {
            player : null,
            playerVars : {
                controls: 0,
                autoplay: 1,
                disablekb : 1,
                showinfo : 0,
                vq : 'hd720',
                start: '30',
                iv_load_policy : 3
            },
            videoId : 'x0Pa8aIqmNI'
        };

        $scope.mute = true;

        //
        //  Scope functions
        //

        /// Carousel

        $scope.setMute =  function(newVal) {
            $scope.mute = newVal;
            if ($scope.yt.player && $scope.yt.player.mute)
                newVal ? $scope.yt.player.mute() : $scope.yt.player.unMute();
        };

        $scope.isPlaying = function() {
            if ($scope.yt.player && $scope.yt.player.getPlayerState)
                return $scope.yt.player.getPlayerState() != 2;
            return false;
        };

        function _randomTo(number)
        {
            return Math.floor((Math.random() * 100) + 1) % number;
        }

        $scope.onSlideChanged = function(index) {
            if (index < $scope.weathers.length && $scope.weathers[index].video_ids && $scope.weathers[index].video_ids.length > 0)
            {
                var ids = $scope.weathers[index].video_ids;
                $scope.yt.videoId = ids[_randomTo(ids.length)];
            }
        };

        /// Youtube player

        $scope.$on('youtube.player.ready', function ($event, player) {

            if ($scope.weathers.length == 0)
            {
                $scope.weathers = WayThereDataStore.retrieveWeathers(function(weathers) {
                    $scope.weathers = weathers;
                    $scope.onSlideChanged(0);
                });
            }

            if (player.hasOwnProperty('mute'))
            {
                player.mute();
                player.setPlaybackQuality('hd720');
            }
        });

        $scope.$on('youtube.player.ended', function ($event, player) {
            // play it again when it stops
            player.playVideo();
        });
    });

})(angular);
